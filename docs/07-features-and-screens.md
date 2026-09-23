# 07 — Features & Screens

> ✅ **UPDATED** with the product owner's confirmed v1 scope.
> Screens live in `features/<name>/presentation/screens/`.
> All text uses `context.<weight><size><Colour>` atoms and `t.*` slang keys.

---

## 0. Confirmed v1 Scope

| # | Feature | Role |
|---|---|---|
| 1 | Role selection **before** entering the app | both |
| 2 | Email/Password + Google auth | both |
| 3 | Doctor sets specialization, bio, what they treat | doctor |
| 4 | Doctor sets weekly availability (days + hours) | doctor |
| 5 | Doctor sets clinic address + coordinates (**map UI deferred to v1.1**) | doctor |
| 6 | Doctor sets clinic **contact phone** | doctor |
| 7 | Patient searches by **name** or **specialization** | patient |
| 8 | Patient books a slot; app confirms the exact time | patient |
| 9 | Patient sees the doctor's phone to confirm by call | patient |
| 10 | Interactive maps, geolocation, and nearest-doctor map → **deferred to v1.1** (no Maps API key yet) | patient |
| 11 | Patient **rates** the doctor after the visit | patient |
| 12 | Doctor views/manages incoming bookings | doctor |

**Deferred to v1.1:** the map UI (nearest-doctor map, map picker) — blocked on a
Google Maps API key with billing. **The data model keeps `location.lat/lng/address`
from day one**, so enabling maps later is additive, not a migration. In v1 the doctor
types an address and the patient sees it as text with an "open in Maps" link
(`url_launcher` needs no API key).

**Deferred later still:** chat, medical records, prescriptions, online payment,
video calls, family members, recurring appointments, push reminders.

**Three notable capabilities vs. the previous draft** — search, ratings, and an
explicit role-selection step. Location data is retained in the schema, while interactive
map/geolocation UI is explicitly deferred to v1.1.

---

## A. Onboarding & Auth

### A1. Splash (`splash_screen.dart`)
- Holds the user while `SessionService` resolves. Logo + `AppLoader`.
- No timer-based navigation — `go_router` redirect moves the user out.

### A2. 🆕 Role Selection (`role_selection_screen.dart`)
**First screen a new user sees.** Two large cards:

| Card | Icon | Label | Goes to |
|---|---|---|---|
| Patient | person | `t.auth.rolePatient` | Register (patient) |
| Doctor | stethoscope | `t.auth.roleDoctor` | Register (doctor) |

- Chosen role is passed as a **route parameter** to Register: `/register?role=doctor`.
- A "I already have an account" link goes straight to Login — **role is not asked at
  login**, it's read from PostgreSQL.

> **Security note:** the security rule in `06 §2` allows both roles to self-register.
> The create rule accepts `role in ['patient', 'doctor']`.
>
> **Accepted risk for a portfolio project:** anyone can register as a doctor, which
> means anyone can create a fake doctor profile. Acceptable for a demo, **not** for
> production. Mitigations if this ever goes live: a verification workflow
> (`isVerified: false` until approved), medical licence number upload, or invite codes.
> Documented in the README as a known limitation.

### A3. Login (`login_screen.dart`)
- Email, password, forgot-password link, submit, divider, Google button, link to
  role selection.
- Role comes from the `profiles` table — the user never picks it here.

### A4. Register (`register_screen.dart`)
- Receives `role` from the route. Header shows which role is being created.
- **Patient fields:** name, email, phone, password, confirm.
- **Doctor fields:** name, email, phone, password, confirm — then on submit goes to
  the **doctor onboarding wizard** (A5) instead of straight to the dashboard.

### A5. 🆕 Doctor Onboarding Wizard (`doctor_onboarding_screen.dart`)
A doctor's profile is useless until it has a specialization, hours, location and phone.
A 4-step `PageView` with a progress indicator, shown once right after doctor signup:

1. **Professional info** — specialization (dropdown from a fixed enum), years of
   experience, bio EN/AR, what they treat (free text / chips), consultation fee.
2. **Availability** — the weekly editor from C3.
3. **Clinic location** — v1: address text fields (EN/AR). Optional lat/lng may be
   supplied by seed data or an existing profile, but there is no map picker in v1.
   v1.1: map picker + geocoding.
4. **Contact** — clinic phone, optional WhatsApp, address text.

- `doctors.is_profile_complete` gates it. `go_router` redirects any doctor with
  `is_profile_complete == false` back into the wizard.
- Each step saves as it completes, so a dropout can resume.

### A6. Forgot Password
Email → `sendPasswordResetEmail` → confirmation view.

---

## B. Patient

### B1. Home / Find a Doctor (`patient_home_screen.dart`)
- Greeting, search field, specialization chips, next-appointment card, doctor list.
- ⏸️ *(v1.1)* Toggle: List view ↔ Map view in the app bar.
- `DoctorCard`: avatar, name, specialization, ⭐ rating + count, fee, and a call-icon
  button. Distance is **v1.1 only**, when geolocation/map support is enabled.

### B2. 🆕 Search (`search_screen.dart`)
Search by **name** or **specialization** — both explicitly required.

> ⚠️ **Search Implementation.**
> Unlike Firestore, PostgreSQL handles substring and fuzzy search natively. Options:
> - **(a) Native Supabase query:** `.ilike('name', '%$query%')`.
> - **(b) Client-side filter** over all active doctors, cached locally. Fine up to a
>   few hundred doctors; perfect for a demo with seeded data.
> - **(c) Full-Text Search (FTS)** using PostgreSQL `to_tsvector`.
>
> **Recommendation: (a) for v1.**
> Specialization filtering is a normal `.eq('specialization', x)` query.

- UI: search field, recent searches, specialization grid, results list.
- Debounce input 300 ms.

### B3. ⏸️ Nearby Doctors Map — **DEFERRED to v1.1**
> Blocked on a Google Maps API key + billing. Everything below is the v1.1 spec,
> kept here so the data model stays compatible. **Do not build this in v1.**
>
> **v1 substitute:** the doctor list shows the clinic address as text, and the doctor
> details screen has an "Open in Maps" button via `url_launcher` (`geo:` URI / maps
> web URL) — no API key, no billing, works on both platforms.

- Requests location permission with a clear rationale first (`permission_handler`).
- `GoogleMap` centred on the patient, doctor markers, tap marker → bottom sheet with
  a mini `DoctorCard` → doctor details.
- Radius filter chips: 5 / 10 / 25 / 50 km.

All bullets in this section are **v1.1 only**; do not implement them in v1.

> ⚠️ **Native geo-radius query.** Options:
> - **(a) PostGIS** — real radius queries natively supported by PostgreSQL.
>   The correct answer.
> - **(b) Fetch all active doctors, compute distance client-side** with the Haversine
>   formula, sort, filter. Trivial to build, fine for a demo, does not scale.
>
> **Recommendation: (a) for v1.1** (keeps the first map implementation simple),
> Neither approach is implemented in v1.

- **Permission denied** is a first-class state for v1.1: show the list view with an explanatory
  banner, never a blank map.

### B4. Doctor Details (`doctor_details_screen.dart`)
- Collapsing header, name, specialization, ⭐ rating + review count.
- Stat row: experience / rating / fee.
- **About** + **what they treat**.
- 🆕 **Clinic location card** — address text + "Open in Maps" (`url_launcher`).
  *(static map preview and distance arrive in v1.1; the v1 screen is address text only)*
- 🆕 **Contact card** — phone with a **Call** button (`tel:` via `url_launcher`) and
  optional WhatsApp button.
- 🆕 **Reviews section** — average, rating distribution bars, latest 3 reviews,
  "see all".
- Sticky bottom bar: **Book** (primary) + **Call** (secondary).

> The spec explicitly wants *both* paths: book in-app **or** phone the clinic to
> confirm. Both actions are equally prominent.

### B5. Book Appointment (`book_appointment_screen.dart`)
Unchanged from the previous draft and still the most complex screen:
- 14-day date strip (disabled on non-working days / exception days).
- Slot grid: available / booked / selected / past.
- Notes field, summary card, confirm button.
- Slots computed by the pure `calculateAvailableSlots()` in
  `features/availability/data/repo/slot_calculator.dart`.
- Booking runs via a **PostgreSQL RPC** (e.g. `book_appointment`) that safely inserts the appointment and relies on a `Unique Partial Index` (`idx_appointments_concurrent_lock`) so
  two patients cannot take the same slot.
- On `SlotTakenFailure`: show `t.errors.slotTaken`, refresh the grid, stay on screen.
- On success: confirmation dialog showing **the exact confirmed date and time**, plus
  the clinic phone for follow-up, then go to My Appointments.

### B6. My Appointments (`my_appointments_screen.dart`)
- Tabs: Upcoming / Past. `AppointmentCard` with `StatusBadge`.
- Cancel with confirmation (only if pending/confirmed and in the future).
- **Reschedule** is implemented as cancel + new booking. There is no atomic
  reschedule operation in v1.
- � On a **completed** appointment, the card shows a **"Rate your visit"** button if
  the patient hasn't reviewed it yet.

### B7. 🆕 Rate Doctor (`rate_doctor_screen.dart` / bottom sheet)
- 1–5 star selector, optional comment, submit.
- **Only allowed** when an appointment between this patient and doctor has
  `status == 'completed'`. Enforced in security rules, not just in the UI.
- **One review per appointment**, enforced by a unique constraint on `appointment_id` in the `reviews` table, and editable for 7 days.
- Writing or editing a review updates the doctor's aggregate — see §F.

### B8. Profile / Edit Profile
Avatar, name, email, phone, links to appointments / settings / sign out.

---

## C. Doctor

### C1. Dashboard (`doctor_dashboard_screen.dart`)
- Greeting + profile-completeness banner if anything is missing.
- Stat cards: today's appointments, pending requests, total patients, ⭐ average rating.
- Today's schedule timeline.
- Quick actions: availability, profile, requests.

### C2. Requests / Appointments (`doctor_appointments_screen.dart`)
- Status filter chips, list with patient name + **phone (tap to call)**.
- Accept / Reject on pending. Reject must also delete the `slotLock`.
- Mark as **completed** after the visit — this is what unlocks the patient's review.

> **Rejection** is modelled as cancellation with `cancelledBy: 'doctor'` and
> `cancelReason: 'rejected'`. There is no separate `rejected` status.

> ⚠️ **Single point of failure, by decision.** Only the doctor can mark an appointment
> completed, so if they forget, the patient can never leave a review and the ratings
> feature stays empty. Mitigations to build in v1 — they're cheap and they matter:
> 1. **Badge + banner on the dashboard:** "3 appointments awaiting completion" for any
>    `confirmed` appointment whose `startAt` is in the past.
> 2. **Bulk action:** "Mark all of yesterday's as completed".
> 3. **Sort past-due appointments to the top** of the requests list.
> 4. **Seed data must include completed appointments** so the review flow is
>    demonstrable immediately.
>
> If ratings still look sparse in practice, the fallback is an auto-complete sweep
> 24h after `startAt` — computable client-side without a server-side function.

### C3. Availability (`availability_screen.dart`)
- 7 weekday rows, `Switch` per day, multiple time ranges per day, add/edit/remove.
- Slot duration selector (15 / 20 / 30 / 45 / 60 min).
- Calendar section for one-off closed days (`exceptions`).
- Validation: no overlapping ranges, `end > start`, range length a multiple of the
  slot duration.
- Warn about existing bookings that fall outside the new hours.

### C4. Doctor Profile (`doctor_profile_screen.dart`)
Everything from the onboarding wizard, editable: specialization, bio EN/AR, what they
treat, fee, **clinic address**, **contact phone**, optional remote `photoUrl`,
`isActive` toggle. The map picker is v1.1. Profile-photo uploads are deferred because
Supabase Storage is excluded in v1.

### C5. 🆕 My Reviews (`doctor_reviews_screen.dart`)
Read-only list of received reviews with the rating distribution. No replies in v1.

---

## D. Settings
Language (EN/AR), theme (light + dark, default `ThemeMode.system`), sign out,
**account deactivation**, about/version.

> **Account deactivation (v1):** see `12-supabase-plan.md §3` for the
> canonical flow and constraints. The Settings UI triggers that contract; this feature
> spec does not duplicate the backend lifecycle policy.


> **Email verification:** send on sign-up, but don't hard-block login in v1 —
> show a dismissible banner on the home screen using `t.errors.auth.emailNotVerified`
> until the user verifies.

---

## E. 🆕 Maps & Location — Technical Notes

> **Deferred.** Only `url_launcher` is used in v1 (for `tel:` and "open in Maps"),
> and it needs no API key or billing.

**v1.1 packages:** `google_maps_flutter`, `geolocator`, `permission_handler`, `geocoding`.

**Setup cost (don't underestimate this):**
- Google Maps API key, restricted per platform, billing enabled on Google Cloud.
- Android: key in `AndroidManifest.xml`, `minSdk` ≥ 21, location permissions.
- iOS: key in `AppDelegate.swift`, `NSLocationWhenInUseUsageDescription` in `Info.plist`.
- **Never commit the API key.** Use `--dart-define` or a gitignored config file, and
  document the setup in the README.

**Location permission flow:** rationale dialog → request → handle *granted /
denied / permanently-denied / services-disabled* separately. Permanently denied must
offer `openAppSettings()`. The app stays fully usable without location — map view is
an enhancement, never a gate.

**Doctor location is stored as:**
```jsonc
"location": {
  "lat": 31.2001, "lng": 29.9187,
  "geohash": "stq4s3x",            // only if geoflutterfire is adopted
  "address": { "en": "...", "ar": "..." }
}
```

**Map picker (doctor side):** map + centre pin + "use my current location" + search,
returning lat/lng and a reverse-geocoded address (`geocoding` package).

---

## F. 🆕 Ratings — Technical Notes

### Data
```jsonc
// reviews/{appointmentId}
{
  "id": "apt_001",
  "doctorId": "doc_001",
  "patientId": "pat_001",
  "patientName": "Mona Ali",
  "appointmentId": "apt_001",      // same value as document ID; guarantees one review per visit
  "rating": 5,                      // 1..5 integer
  "comment": "Very helpful",
  "createdAt": "<Timestamp>",
  "updatedAt": "<Timestamp>"
}
```

Denormalised onto the doctor for fast list rendering:
```jsonc
"rating": 4.7, "ratingCount": 128, "ratingSum": 601
```

### ⚠️ Keeping the aggregate correct
Updating `rating` / `rating_count` from the client directly is **racy and spoofable**.

**Recommendation:** A PostgreSQL RPC (e.g., `add_review`) that safely inserts the review and updates the aggregate on the doctor in a single database transaction. This is the v1 implementation defined in `supabase/schema.sql`.

### Security rules

The authoritative PostgreSQL RLS rules for the `reviews` table live in
`supabase/schema.sql`. Implement and test that single source of truth;
do not duplicate the rules here. The same document also defines the seven-day edit
window and completed-appointment gate.

---

## F2. 🆕 Appointment Lifecycle — Who Moves What

```
      patient books
            │
            ▼
      ┌──────────┐   doctor accepts    ┌────────────┐
      │ pending  │ ──────────────────► │ confirmed  │
      └──────────┘                     └────────────┘
            │                                │
            │ doctor rejects                 │ doctor marks done
            │ patient cancels                │ (AFTER the visit)
            ▼                                ▼
      ┌────────────┐                   ┌────────────┐
      │ cancelled  │                   │ completed  │
      └────────────┘                   └────────────┘
            │                                │
       slotLock deleted              unlocks patient review
```

| Transition | Who | Notes |
|---|---|---|
| → `pending` | patient | creates `slotLock` in a transaction |
| `pending` → `confirmed` | doctor | |
| `pending`/`confirmed` → `cancelled` | doctor **or** patient | **must delete `slotLock`** |
| `confirmed` → `completed` | **doctor only** | the only gate to reviews |

> ⚠️ **No notifications in v1.** The patient is not told when the doctor accepts or
> rejects — they have to open the app and look. This is precisely why the spec's
> "confirm by calling the clinic" path matters, and why the doctor's phone number is
> prominent on the details screen, in the booking confirmation dialog, and on the
> appointment card. Make the booking confirmation dialog say clearly:
> *"Your request was sent. The clinic will confirm — you can call them to confirm now."*
> Push notifications are the first thing to add in v1.1.

---

## G. Shared Widget Inventory

`core/widgets/` — no state-management imports, identical across all three branches.

| Widget | Notes |
|---|---|
| `AppButton` | variants: primary / secondary / outline / text; `isLoading` |
| `AppTextField` | validator, prefix/suffix, obscure toggle |
| `AppScaffold` | title, actions, back button, padding |
| `AppLoader` / `ShimmerBox` / `ShimmerList` | loading |
| `AppErrorView` / `AppEmptyView` | with retry / illustration |
| `StateHandler<T>` | the 4-state adapter (see `01 §5`) |
| `AppAvatar` | network image + initials fallback |
| `StatusBadge` | appointment status → colour + label |
| `DoctorCard` | avatar, name, specialization, rating + count, fee, call button in v1; distance is v1.1 |
| `AppointmentCard` | role-aware actions |
| `SlotChip` / `DateStrip` | booking UI |
| `StatCard` | dashboard |
| 🆕 `RatingStars` | display + interactive modes |
| 🆕 `RatingBarDistribution` | 5→1 star breakdown bars |
| 🆕 `ReviewTile` | avatar, name, stars, comment, date |
| ⏸️ `LocationPickerMap` | doctor-side picker — **v1.1** |
| ⏸️ `MiniMapPreview` | static map — **v1.1** |
| 🆕 `AddressCard` | address text + "Open in Maps" button (v1, no API key) |
| 🆕 `CallButton` | `tel:` launcher with a confirm dialog |
| 🆕 `SpecializationChip` | filter chip |
| `AppDialogs` | confirm / error / success |

**Contract:** plain data in, callbacks out. No `context.read`, no `ref.watch`,
no `Get.find`.
