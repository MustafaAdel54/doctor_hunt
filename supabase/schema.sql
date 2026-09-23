-- ============================================================
-- DOCTOR HUNT — FINAL DATABASE MIGRATION (v5-final)
-- Apply to Supabase SQL Editor.
-- No slot_locks table. No aggregate trigger.
-- ============================================================

-- ============================================================
-- 0. EXTENSIONS & SCHEMAS
-- ============================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- private schema: SECURITY DEFINER implementations live here.
-- PostgREST does NOT expose this schema by default. Clients cannot
-- call private.* directly — only via public.* INVOKER wrappers.
CREATE SCHEMA IF NOT EXISTS private;
REVOKE ALL ON SCHEMA private FROM PUBLIC;
-- authenticated needs USAGE to execute private.* called from
-- public SECURITY INVOKER wrappers.
GRANT USAGE ON SCHEMA private TO authenticated;
GRANT USAGE ON SCHEMA private TO service_role;

-- ============================================================
-- 1. TABLES
-- ============================================================

CREATE TABLE public.profiles (
  id          uuid        PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email       text        NOT NULL,
  role        text        NOT NULL CHECK (role IN ('patient', 'doctor')),
  name        text,
  phone       text,
  photo_url   text,
  is_verified boolean     NOT NULL DEFAULT false,
  is_active   boolean     NOT NULL DEFAULT true,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

-- FK chain: doctors.id → profiles.id → auth.users.id
-- No doctor row can exist without a matching profile.
CREATE TABLE public.doctors (
  id               uuid             PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,
  name             jsonb            NOT NULL DEFAULT '{}'::jsonb,
  -- JSONB format: {"en": "...", "ar": "..."}
  image            text,
  phone            text             NOT NULL DEFAULT '',
  rating_sum       double precision NOT NULL DEFAULT 0.0 CHECK (rating_sum >= 0),
  rating_count     integer          NOT NULL DEFAULT 0   CHECK (rating_count >= 0),
  specialization   text             NOT NULL DEFAULT 'Unspecified',
  years_experience integer          NOT NULL DEFAULT 0   CHECK (years_experience >= 0),
  patients_count   integer          NOT NULL DEFAULT 0   CHECK (patients_count >= 0),
  -- GROUP C — deferred/compatibility only (kept for Dart model deserialization):
  running_count    integer          NOT NULL DEFAULT 0   CHECK (running_count >= 0),
  ongoing_count    integer          NOT NULL DEFAULT 0   CHECK (ongoing_count >= 0),
  hourly_rate      double precision NOT NULL DEFAULT 0.0 CHECK (hourly_rate >= 0),
  services         text[]           NOT NULL DEFAULT '{}',
  created_at       timestamptz      NOT NULL DEFAULT now()
);

-- JSONB structure mirrors Dart AvailabilityModel exactly:
-- days: [{"weekday": 1, "ranges": [{"start": "09:00", "end": "12:00"}]}]
-- weekday: 1=Monday..7=Sunday  (Dart DateTime.weekday = PostgreSQL ISODOW)
CREATE TABLE public.availability (
  doctor_id             uuid        PRIMARY KEY REFERENCES public.doctors(id) ON DELETE CASCADE,
  slot_duration_minutes integer     NOT NULL DEFAULT 30 CHECK (slot_duration_minutes > 0),
  days                  jsonb       NOT NULL DEFAULT '[]'::jsonb,
  updated_at            timestamptz NOT NULL DEFAULT now()
);

-- No slot_locks table. Concurrency enforced by partial unique index.
-- end_time is NOT NULL: always derived server-side.
CREATE TABLE public.appointments (
  id           uuid        PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id   uuid        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  doctor_id    uuid        NOT NULL REFERENCES public.doctors(id)  ON DELETE CASCADE,
  doctor_name  jsonb       NOT NULL DEFAULT '{}'::jsonb,
  status       text        NOT NULL CHECK (status IN ('pending','confirmed','cancelled','completed')),
  start_time   timestamptz NOT NULL,
  end_time     timestamptz NOT NULL,
  patient_name text,
  notes        text,
  created_at   timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT chk_appointments_time CHECK (start_time < end_time)
);

-- UNIQUE(appointment_id): one review per appointment ever.
CREATE TABLE public.reviews (
  id             uuid        PRIMARY KEY DEFAULT uuid_generate_v4(),
  appointment_id uuid        NOT NULL UNIQUE REFERENCES public.appointments(id) ON DELETE CASCADE,
  patient_id     uuid        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  doctor_id      uuid        NOT NULL REFERENCES public.doctors(id)  ON DELETE CASCADE,
  rating         integer     NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment        text,
  patient_name   text,
  created_at     timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- 2. INDEXES
-- ============================================================

CREATE INDEX idx_appointments_patient_time ON public.appointments(patient_id, start_time DESC);
CREATE INDEX idx_appointments_doctor_time  ON public.appointments(doctor_id,  start_time DESC);
CREATE INDEX idx_doctors_specialization    ON public.doctors(specialization);
CREATE INDEX idx_reviews_doctor_created    ON public.reviews(doctor_id, created_at DESC);

-- CONCURRENCY GUARANTEE: at most one active (pending or confirmed)
-- appointment per (doctor, start_time). Cancelled/completed rows leave
-- the index, immediately freeing the slot. No slot_locks table needed.
CREATE UNIQUE INDEX idx_appointments_concurrent_lock
  ON public.appointments(doctor_id, start_time)
  WHERE status IN ('pending','confirmed');

-- ============================================================
-- 3. GRANTS — PRINCIPLE OF LEAST PRIVILEGE
-- ============================================================

REVOKE ALL ON public.profiles     FROM PUBLIC, anon, authenticated;
REVOKE ALL ON public.doctors      FROM PUBLIC, anon, authenticated;
REVOKE ALL ON public.availability FROM PUBLIC, anon, authenticated;
REVOKE ALL ON public.appointments FROM PUBLIC, anon, authenticated;
REVOKE ALL ON public.reviews      FROM PUBLIC, anon, authenticated;

-- profiles: SELECT all; UPDATE only user-editable columns.
-- role, email, is_verified, is_active, created_at, updated_at: NO UPDATE grant.
-- updated_at maintained server-side by trigger (Section 4).
GRANT SELECT ON public.profiles TO authenticated;
GRANT UPDATE (name, phone, photo_url) ON public.profiles TO authenticated;

-- doctors: SELECT all; UPDATE only content/profile fields.
-- rating_sum, rating_count, patients_count, running_count, ongoing_count,
-- services, hourly_rate: NO UPDATE grant.
GRANT SELECT ON public.doctors TO authenticated;
GRANT UPDATE (name, image, phone, specialization, years_experience)
  ON public.doctors TO authenticated;

-- availability: full CRUD — RLS restricts writes to own doctor_id.
GRANT SELECT, INSERT, UPDATE, DELETE ON public.availability TO authenticated;

-- appointments: SELECT only — all mutations via RPCs.
GRANT SELECT ON public.appointments TO authenticated;

-- reviews: SELECT only — all mutations via RPCs.
GRANT SELECT ON public.reviews TO authenticated;

-- service_role: full access for internal Supabase operations.
GRANT ALL ON public.profiles, public.doctors, public.availability,
             public.appointments, public.reviews TO service_role;

-- ============================================================
-- 4. TRIGGERS
-- ============================================================

-- 4a. Server-side updated_at for profiles.
--     authenticated has no UPDATE grant on updated_at, so this trigger
--     is the only mechanism that advances it, ensuring accurate tracking.
CREATE OR REPLACE FUNCTION private.set_profiles_updated_at()
RETURNS trigger
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;

ALTER FUNCTION private.set_profiles_updated_at() OWNER TO postgres;
REVOKE EXECUTE ON FUNCTION private.set_profiles_updated_at() FROM PUBLIC, anon, authenticated, service_role;

CREATE TRIGGER trg_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION private.set_profiles_updated_at();

-- NOTE: No doctor aggregate trigger.
-- rating_sum, rating_count, patients_count, running_count, ongoing_count
-- are protected purely by the absence of an UPDATE column-level grant for
-- the authenticated role. SECURITY DEFINER RPCs run as postgres and
-- update them freely without any trigger interference.

-- ============================================================
-- 5. RLS POLICIES
-- ============================================================

ALTER TABLE public.profiles     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.doctors      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.availability ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews      ENABLE ROW LEVEL SECURITY;

-- profiles: own row only; no INSERT policy (create_profile RPC handles it)
CREATE POLICY "profiles_select_own" ON public.profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "profiles_update_own" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);

-- doctors: any authenticated may SELECT (patient discovery/search)
CREATE POLICY "doctors_select_all" ON public.doctors
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "doctors_update_own" ON public.doctors
  FOR UPDATE USING (auth.uid() = id);

-- availability: any authenticated may SELECT (booking UI needs it)
CREATE POLICY "availability_select_all" ON public.availability
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "availability_manage_own" ON public.availability
  FOR ALL
  USING     (auth.uid() = doctor_id)
  WITH CHECK (auth.uid() = doctor_id);

-- appointments: patient or doctor may SELECT their own rows only.
-- No INSERT/UPDATE/DELETE policies → denied for authenticated.
CREATE POLICY "appointments_select_own" ON public.appointments
  FOR SELECT TO authenticated
  USING (auth.uid() = patient_id OR auth.uid() = doctor_id);

-- reviews: publicly readable (doctor profiles, ratings)
-- No INSERT/UPDATE/DELETE policies → denied for authenticated.
CREATE POLICY "reviews_select_all" ON public.reviews
  FOR SELECT TO authenticated USING (true);

-- ============================================================
-- 6. PRIVATE HELPERS
-- ============================================================

-- 6a. Pure slot boundary validator (no DB calls).
--
-- TIMEZONE — v1 canonical rule:
--   v1 uses UTC as the single canonical timezone for both appointment
--   timestamps and availability "HH:mm" wall-clock ranges.
--   Doctors configure their availability in UTC. Clients must send
--   appointment times as UTC ISO8601. Doctor-local multi-timezone
--   scheduling is deferred to a future version.
--
-- ISODOW (PostgreSQL): 1=Mon..7=Sun — identical to Dart DateTime.weekday.
-- No offset conversion is needed.
--
CREATE OR REPLACE FUNCTION private.is_slot_valid(
  p_days      jsonb,
  p_slot_min  integer,
  p_start_time timestamptz
)
RETURNS boolean
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  v_day_entry   jsonb;
  v_range       jsonb;
  v_range_start time;
  v_range_end   time;
  v_current     time;
  v_req_time    time;
  v_weekday     integer;
BEGIN
  IF p_days IS NULL OR jsonb_array_length(p_days) = 0 THEN
    RETURN false;
  END IF;

  v_weekday  := EXTRACT(ISODOW FROM p_start_time AT TIME ZONE 'UTC')::integer;
  v_req_time := (p_start_time AT TIME ZONE 'UTC')::time;

  SELECT elem INTO v_day_entry
    FROM jsonb_array_elements(p_days) AS elem
   WHERE (elem->>'weekday')::integer = v_weekday
   LIMIT 1;

  IF v_day_entry IS NULL THEN RETURN false; END IF;

  FOR v_range IN SELECT * FROM jsonb_array_elements(v_day_entry->'ranges') LOOP
    v_range_start := (v_range->>'start')::time;
    v_range_end   := (v_range->>'end')::time;
    v_current     := v_range_start;
    WHILE v_current + (p_slot_min || ' minutes')::interval <= v_range_end LOOP
      IF v_current = v_req_time THEN RETURN true; END IF;
      v_current := v_current + (p_slot_min || ' minutes')::interval;
    END LOOP;
  END LOOP;

  RETURN false;
END;
$$;

ALTER FUNCTION private.is_slot_valid(jsonb, integer, timestamptz) OWNER TO postgres;
REVOKE EXECUTE ON FUNCTION private.is_slot_valid(jsonb, integer, timestamptz) FROM PUBLIC, anon, authenticated, service_role;

-- 6b. Convenience wrapper (fetches from DB; not used in booking path
--     which uses FOR SHARE to lock the row first).
CREATE OR REPLACE FUNCTION private.is_slot_available(
  p_doctor_id  uuid,
  p_start_time timestamptz
)
RETURNS boolean
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  v_slot_min integer;
  v_days     jsonb;
BEGIN
  SELECT slot_duration_minutes, days
    INTO v_slot_min, v_days
    FROM public.availability
   WHERE doctor_id = p_doctor_id;

  IF NOT FOUND THEN RETURN false; END IF;

  RETURN private.is_slot_valid(v_days, v_slot_min, p_start_time);
END;
$$;

ALTER FUNCTION private.is_slot_available(uuid, timestamptz) OWNER TO postgres;
REVOKE EXECUTE ON FUNCTION private.is_slot_available(uuid, timestamptz) FROM PUBLIC, anon, authenticated, service_role;

-- ============================================================
-- 7. RPCs
-- ============================================================

-- ── 7a. create_profile ──────────────────────────────────────
CREATE OR REPLACE FUNCTION private.create_profile_impl(
  p_role text, p_name text, p_phone text, p_photo_url text
)
RETURNS public.profiles
LANGUAGE plpgsql SECURITY DEFINER SET search_path = ''
AS $$
DECLARE
  v_uid     uuid := auth.uid();
  v_email   text;
  v_profile public.profiles;
BEGIN
  IF v_uid IS NULL THEN RAISE EXCEPTION 'Not authenticated'; END IF;
  IF p_role NOT IN ('patient','doctor') THEN
    RAISE EXCEPTION 'Invalid role: %', p_role;
  END IF;

  SELECT email INTO v_email FROM auth.users WHERE id = v_uid;
  IF NOT FOUND THEN RAISE EXCEPTION 'Auth user not found'; END IF;

  INSERT INTO public.profiles (id, email, role, name, phone, photo_url, is_verified, is_active)
  VALUES (v_uid, v_email, p_role, p_name, p_phone, p_photo_url, false, true)
  RETURNING * INTO v_profile;

  IF p_role = 'doctor' THEN
    INSERT INTO public.doctors (id, phone) VALUES (v_uid, COALESCE(p_phone,''));
  END IF;

  RETURN v_profile;
END;
$$;

ALTER FUNCTION private.create_profile_impl(text,text,text,text) OWNER TO postgres;
REVOKE EXECUTE ON FUNCTION private.create_profile_impl(text,text,text,text) FROM PUBLIC;
GRANT  EXECUTE ON FUNCTION private.create_profile_impl(text,text,text,text) TO authenticated;
GRANT  EXECUTE ON FUNCTION private.create_profile_impl(text,text,text,text) TO service_role;

CREATE OR REPLACE FUNCTION public.create_profile(
  p_role text, p_name text, p_phone text, p_photo_url text DEFAULT NULL
)
RETURNS public.profiles
LANGUAGE sql SECURITY INVOKER SET search_path = '' AS $$
  SELECT private.create_profile_impl(p_role, p_name, p_phone, p_photo_url);
$$;
REVOKE EXECUTE ON FUNCTION public.create_profile(text,text,text,text) FROM PUBLIC, anon;
GRANT  EXECUTE ON FUNCTION public.create_profile(text,text,text,text) TO authenticated;

-- ── 7b. book_appointment ────────────────────────────────────
-- Accepts: p_doctor_id, p_start_time (UTC), p_notes.
-- Derives server-side: patient_id, patient_name, doctor_name, status, end_time.
--
-- Availability hardening:
--   The availability row is locked with FOR SHARE before validation.
--   Both is_slot_valid() and slot_duration_minutes use the same locked
--   in-memory record, guaranteeing no availability change can slip
--   between slot validation and end_time computation.
--
CREATE OR REPLACE FUNCTION private.book_appointment_impl(
  p_doctor_id  uuid,
  p_start_time timestamptz,
  p_notes      text
)
RETURNS public.appointments
LANGUAGE plpgsql SECURITY DEFINER SET search_path = ''
AS $$
DECLARE
  v_patient_id   uuid := auth.uid();
  v_patient_name text;
  v_doctor_name  jsonb;
  v_avail        public.availability;
  v_appt         public.appointments;
BEGIN
  IF v_patient_id IS NULL THEN RAISE EXCEPTION 'Not authenticated'; END IF;

  IF p_start_time <= now() THEN
    RAISE EXCEPTION 'Appointment time must be in the future';
  END IF;

  SELECT name INTO v_patient_name
    FROM public.profiles
   WHERE id = v_patient_id AND role = 'patient' AND is_active = true;
  IF NOT FOUND THEN RAISE EXCEPTION 'Caller must be an active patient'; END IF;

  SELECT d.name INTO v_doctor_name
    FROM public.doctors  d
    JOIN public.profiles p ON p.id = d.id
   WHERE d.id = p_doctor_id AND p.is_active = true;
  IF NOT FOUND THEN RAISE EXCEPTION 'Doctor does not exist or is inactive'; END IF;

  -- Lock availability row FOR SHARE to prevent concurrent modifications
  -- between slot validation and end_time computation (booking hardening).
  SELECT * INTO v_avail
    FROM public.availability
   WHERE doctor_id = p_doctor_id
     FOR SHARE;

  IF NOT FOUND OR NOT private.is_slot_valid(v_avail.days, v_avail.slot_duration_minutes, p_start_time) THEN
    RAISE EXCEPTION 'Requested time is not within the doctor''s configured availability';
  END IF;

  -- Use the slot_duration_minutes from the same locked record.
  INSERT INTO public.appointments
    (patient_id, doctor_id, doctor_name, status, start_time, end_time, patient_name, notes)
  VALUES
    (v_patient_id, p_doctor_id, v_doctor_name, 'pending',
     p_start_time,
     p_start_time + (v_avail.slot_duration_minutes || ' minutes')::interval,
     v_patient_name, p_notes)
  RETURNING * INTO v_appt;

  RETURN v_appt;
END;
$$;

ALTER FUNCTION private.book_appointment_impl(uuid,timestamptz,text) OWNER TO postgres;
REVOKE EXECUTE ON FUNCTION private.book_appointment_impl(uuid,timestamptz,text) FROM PUBLIC;
GRANT  EXECUTE ON FUNCTION private.book_appointment_impl(uuid,timestamptz,text) TO authenticated;
GRANT  EXECUTE ON FUNCTION private.book_appointment_impl(uuid,timestamptz,text) TO service_role;

CREATE OR REPLACE FUNCTION public.book_appointment(
  p_doctor_id uuid, p_start_time timestamptz, p_notes text DEFAULT NULL
)
RETURNS public.appointments
LANGUAGE sql SECURITY INVOKER SET search_path = '' AS $$
  SELECT private.book_appointment_impl(p_doctor_id, p_start_time, p_notes);
$$;
REVOKE EXECUTE ON FUNCTION public.book_appointment(uuid,timestamptz,text) FROM PUBLIC, anon;
GRANT  EXECUTE ON FUNCTION public.book_appointment(uuid,timestamptz,text) TO authenticated;

-- ── 7c. update_appointment_status / cancel_appointment ──────
-- Status transition matrix:
--   Patient: pending/confirmed → cancelled
--   Doctor:  pending → confirmed | cancelled
--            confirmed → completed | cancelled
--   cancelled/completed: terminal — no further transitions allowed
--
-- Ownership check happens BEFORE transition matrix to avoid leaking
-- whether another user's appointment exists (consistent error message).
--
CREATE OR REPLACE FUNCTION private.update_appointment_status_impl(
  p_appointment_id uuid,
  p_new_status     text
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER SET search_path = ''
AS $$
DECLARE
  v_uid     uuid := auth.uid();
  v_appt    public.appointments;
  v_allowed boolean := false;
BEGIN
  IF v_uid IS NULL THEN RAISE EXCEPTION 'Not authenticated'; END IF;

  SELECT * INTO v_appt
    FROM public.appointments
   WHERE id = p_appointment_id
     FOR UPDATE;
  IF NOT FOUND THEN RAISE EXCEPTION 'Appointment not found'; END IF;

  -- Ownership check BEFORE transition matrix.
  -- Returns the same 'Appointment not found' to avoid revealing whether
  -- a row exists that belongs to another user.
  IF v_uid <> v_appt.patient_id AND v_uid <> v_appt.doctor_id THEN
    RAISE EXCEPTION 'Appointment not found';
  END IF;

  IF v_uid = v_appt.patient_id THEN
    v_allowed := (p_new_status = 'cancelled' AND v_appt.status IN ('pending','confirmed'));
  ELSIF v_uid = v_appt.doctor_id THEN
    v_allowed := CASE v_appt.status
      WHEN 'pending'   THEN p_new_status IN ('confirmed','cancelled')
      WHEN 'confirmed' THEN p_new_status IN ('completed','cancelled')
      ELSE false
    END;
  END IF;

  IF NOT v_allowed THEN
    RAISE EXCEPTION 'Transition from "%" to "%" is not permitted for this caller',
      v_appt.status, p_new_status;
  END IF;

  UPDATE public.appointments SET status = p_new_status WHERE id = p_appointment_id;
END;
$$;

ALTER FUNCTION private.update_appointment_status_impl(uuid,text) OWNER TO postgres;
REVOKE EXECUTE ON FUNCTION private.update_appointment_status_impl(uuid,text) FROM PUBLIC;
GRANT  EXECUTE ON FUNCTION private.update_appointment_status_impl(uuid,text) TO authenticated;
GRANT  EXECUTE ON FUNCTION private.update_appointment_status_impl(uuid,text) TO service_role;

CREATE OR REPLACE FUNCTION public.cancel_appointment(p_appointment_id uuid)
RETURNS void LANGUAGE sql SECURITY INVOKER SET search_path = '' AS $$
  SELECT private.update_appointment_status_impl(p_appointment_id,'cancelled');
$$;
CREATE OR REPLACE FUNCTION public.update_appointment_status(p_appointment_id uuid, p_new_status text)
RETURNS void LANGUAGE sql SECURITY INVOKER SET search_path = '' AS $$
  SELECT private.update_appointment_status_impl(p_appointment_id, p_new_status);
$$;
REVOKE EXECUTE ON FUNCTION public.cancel_appointment(uuid) FROM PUBLIC, anon;
GRANT  EXECUTE ON FUNCTION public.cancel_appointment(uuid) TO authenticated;
REVOKE EXECUTE ON FUNCTION public.update_appointment_status(uuid,text) FROM PUBLIC, anon;
GRANT  EXECUTE ON FUNCTION public.update_appointment_status(uuid,text) TO authenticated;

-- ── 7d. add_review ──────────────────────────────────────────
CREATE OR REPLACE FUNCTION private.add_review_impl(
  p_appointment_id uuid, p_rating integer, p_comment text
)
RETURNS public.reviews
LANGUAGE plpgsql SECURITY DEFINER SET search_path = ''
AS $$
DECLARE
  v_patient_id uuid := auth.uid();
  v_appt       public.appointments;
  v_review     public.reviews;
BEGIN
  IF v_patient_id IS NULL THEN RAISE EXCEPTION 'Not authenticated'; END IF;
  IF p_rating < 1 OR p_rating > 5 THEN
    RAISE EXCEPTION 'Rating must be between 1 and 5';
  END IF;

  SELECT * INTO v_appt
    FROM public.appointments
   WHERE id = p_appointment_id AND patient_id = v_patient_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Appointment not found or not owned by caller';
  END IF;
  IF v_appt.status <> 'completed' THEN
    RAISE EXCEPTION 'Only completed appointments can be reviewed';
  END IF;

  INSERT INTO public.reviews
    (appointment_id, patient_id, doctor_id, rating, comment, patient_name)
  VALUES
    (p_appointment_id, v_patient_id, v_appt.doctor_id,
     p_rating, p_comment, v_appt.patient_name)
  RETURNING * INTO v_review;

  UPDATE public.doctors
     SET rating_sum   = rating_sum   + p_rating,
         rating_count = rating_count + 1
   WHERE id = v_appt.doctor_id;

  RETURN v_review;
END;
$$;

ALTER FUNCTION private.add_review_impl(uuid,integer,text) OWNER TO postgres;
REVOKE EXECUTE ON FUNCTION private.add_review_impl(uuid,integer,text) FROM PUBLIC;
GRANT  EXECUTE ON FUNCTION private.add_review_impl(uuid,integer,text) TO authenticated;
GRANT  EXECUTE ON FUNCTION private.add_review_impl(uuid,integer,text) TO service_role;

CREATE OR REPLACE FUNCTION public.add_review(
  p_appointment_id uuid, p_rating integer, p_comment text DEFAULT NULL
)
RETURNS public.reviews LANGUAGE sql SECURITY INVOKER SET search_path = '' AS $$
  SELECT private.add_review_impl(p_appointment_id, p_rating, p_comment);
$$;
REVOKE EXECUTE ON FUNCTION public.add_review(uuid,integer,text) FROM PUBLIC, anon;
GRANT  EXECUTE ON FUNCTION public.add_review(uuid,integer,text) TO authenticated;

-- ── 7e. update_review ───────────────────────────────────────
-- FOR UPDATE on reviews row before computing diff prevents concurrent
-- edits from producing incorrect rating_sum totals.
CREATE OR REPLACE FUNCTION private.update_review_impl(
  p_review_id uuid, p_rating integer, p_comment text
)
RETURNS public.reviews
LANGUAGE plpgsql SECURITY DEFINER SET search_path = ''
AS $$
DECLARE
  v_uid    uuid := auth.uid();
  v_review public.reviews;
  v_diff   integer;
BEGIN
  IF v_uid IS NULL THEN RAISE EXCEPTION 'Not authenticated'; END IF;
  IF p_rating < 1 OR p_rating > 5 THEN
    RAISE EXCEPTION 'Rating must be between 1 and 5';
  END IF;

  SELECT * INTO v_review
    FROM public.reviews
   WHERE id = p_review_id AND patient_id = v_uid
     FOR UPDATE;
  IF NOT FOUND THEN RAISE EXCEPTION 'Review not found or not authorized'; END IF;
  IF v_review.created_at < now() - interval '7 days' THEN
    RAISE EXCEPTION 'Review edit window (7 days) has expired';
  END IF;

  v_diff := p_rating - v_review.rating;

  UPDATE public.reviews
     SET rating = p_rating, comment = p_comment
   WHERE id = p_review_id
  RETURNING * INTO v_review;

  UPDATE public.doctors SET rating_sum = rating_sum + v_diff
   WHERE id = v_review.doctor_id;

  RETURN v_review;
END;
$$;

ALTER FUNCTION private.update_review_impl(uuid,integer,text) OWNER TO postgres;
REVOKE EXECUTE ON FUNCTION private.update_review_impl(uuid,integer,text) FROM PUBLIC;
GRANT  EXECUTE ON FUNCTION private.update_review_impl(uuid,integer,text) TO authenticated;
GRANT  EXECUTE ON FUNCTION private.update_review_impl(uuid,integer,text) TO service_role;

CREATE OR REPLACE FUNCTION public.update_review(
  p_review_id uuid, p_rating integer, p_comment text DEFAULT NULL
)
RETURNS public.reviews LANGUAGE sql SECURITY INVOKER SET search_path = '' AS $$
  SELECT private.update_review_impl(p_review_id, p_rating, p_comment);
$$;
REVOKE EXECUTE ON FUNCTION public.update_review(uuid,integer,text) FROM PUBLIC, anon;
GRANT  EXECUTE ON FUNCTION public.update_review(uuid,integer,text) TO authenticated;

-- ── 7f. deactivate_account ──────────────────────────────────
-- SECURITY DEFINER runs as postgres (table owner), bypassing the
-- column-level UPDATE revoke on is_active for authenticated.
-- No session variable needed.
CREATE OR REPLACE FUNCTION private.deactivate_account_impl()
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER SET search_path = ''
AS $$
DECLARE v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN RAISE EXCEPTION 'Not authenticated'; END IF;
  UPDATE public.profiles SET is_active = false WHERE id = v_uid;
END;
$$;

ALTER FUNCTION private.deactivate_account_impl() OWNER TO postgres;
REVOKE EXECUTE ON FUNCTION private.deactivate_account_impl() FROM PUBLIC;
GRANT  EXECUTE ON FUNCTION private.deactivate_account_impl() TO authenticated;
GRANT  EXECUTE ON FUNCTION private.deactivate_account_impl() TO service_role;

CREATE OR REPLACE FUNCTION public.deactivate_account()
RETURNS void LANGUAGE sql SECURITY INVOKER SET search_path = '' AS $$
  SELECT private.deactivate_account_impl();
$$;
REVOKE EXECUTE ON FUNCTION public.deactivate_account() FROM PUBLIC, anon;
GRANT  EXECUTE ON FUNCTION public.deactivate_account() TO authenticated;
