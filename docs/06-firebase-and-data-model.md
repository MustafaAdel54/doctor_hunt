# 06 — Firebase, Data Model & Security

## 1. Services Used

| Service | Purpose |
|---|---|
| **Firebase Auth** | Email/Password + Google Sign-In |
| **Cloud Firestore** | users, doctors, availability, appointments |
| **Profile photos** | Optional remote `photoUrl` only; no uploads in Spark v1 |
| *(later)* Cloud Messaging | booking notifications — out of scope v1 |

---

## 2. Role Resolution — Decided Approach

**Firestore `users/{uid}.role`.**

Flow:
1. User signs in → `FirebaseAuth` returns a `uid`.
2. `SessionService` reads/streams `users/{uid}`.
3. `role` field (`'doctor'` | `'patient'`) populates `UserModel.role`.
4. `go_router` redirect uses it (see `04`).
5. If the Firebase user exists but `users/{uid}` is missing, `SessionService` exposes
   `SessionStatus.authenticatedWithoutProfile` and the router sends the user to role
   selection without inventing a role.

**Registration** writes the doc with the role chosen on the **role selection screen**
(`07 §A2`), which is now the first screen of the app.

> 🔒 **Security position — CHANGED, read this.** The product owner confirmed that
> **both** patients and doctors self-select their role before signing up. That means
> self-service doctor registration is allowed, and the earlier "patient-only signup"
> rule no longer applies.
>
> What still holds:
> - `role` is **immutable after creation**: `request.resource.data.role == resource.data.role`.
>   A patient can never promote themselves later.
> - `role` must be one of `['patient', 'doctor']` on create — no arbitrary values.
>
> **Accepted risk:** anyone can register as a doctor and publish a fake profile.
> For a portfolio demo this is fine and should be stated in the README. For production
> you need one of: an admin verification queue (`isVerified` gate on visibility),
> medical licence upload + manual review, or invite codes. Recommended cheap
> mitigation even for the demo: add `isVerified: false` and only surface verified
> doctors in patient search, with a seeded set of verified doctors.

---

## 3. Firestore Schema

### `users/{uid}`
```jsonc
{
  "uid": "abc123",
  "email": "ahmed@example.com",
  "name": "Ahmed Hassan",
  "phone": "+201001234567",
  "photoUrl": "https://...",          // optional remote URL; no Firebase Storage in Spark v1
  "role": "patient",                  // "patient" | "doctor"  — IMMUTABLE after create
  "isActive": true,                    // false after Spark v1 account deactivation
  "createdAt": "<Timestamp>",
  "updatedAt": "<Timestamp>",
  "fcmToken": "..."                   // optional, v2
}
```

### `doctors/{doctorId}`
`doctorId == uid` of the doctor user. Public-readable profile data.
```jsonc
{
  "uid": "doc_001",
  "name":  { "en": "Dr. Ahmed Hassan", "ar": "د. أحمد حسن" },
  "specialization": "cardiology",     // see Specializations enum below
  "bio":   { "en": "...", "ar": "..." },
  "photoUrl": "https://...",
  "yearsOfExperience": 12,
  "consultationFee": 300,
  "currency": "EGP",
  "clinicAddress": { "en": "...", "ar": "..." },
  "slotDurationMinutes": 30,
  "isActive": true,
  "isProfileComplete": true,          // gates the onboarding wizard
  "isVerified": false,                // recommended: only verified doctors are searchable
  // --- search support (Firestore has no substring search) ---
  "nameSearch": "dr. ahmed hassan",   // lowercased name for prefix/contains matching
  "treats": ["heart", "blood pressure"],

  // --- contact (required by spec) ---
  "clinicPhone": "+201001234567",
  "whatsapp": "+201001234567",

  // --- location (required by spec) ---
  "location": {
    "lat": 31.2001,
    "lng": 29.9187,
    "geohash": "stq4s3x",             // only if geoflutterfire_plus is adopted
    "address": { "en": "12 Fouad St, Alexandria", "ar": "١٢ شارع فؤاد، الإسكندرية" }
  },

  // --- rating aggregate (denormalised) ---
  "rating": 4.7,
  "ratingCount": 128,
  "ratingSum": 601,                   // keep the sum so increments stay exact

  "createdAt": "<Timestamp>"
}
```

**Specializations enum** (translatable via `t.specializations.<key>`):
```
general, cardiology, dermatology, orthopedics,
pediatrics, neurology, dentistry, ophthalmology
```

### `doctors/{doctorId}/availability/{weekday}`
One doc per weekday (`"0"`=Sunday … `"6"`=Saturday). The doctor's *recurring* schedule.
```jsonc
{
  "weekday": 1,
  "isWorking": true,
  "ranges": [
    { "start": "09:00", "end": "13:00" },
    { "start": "16:00", "end": "20:00" }
  ]
}
```
Concrete slots are **derived** client-side: expand ranges by `slotDurationMinutes`,
then subtract already-booked appointments for that date. No need to pre-materialise
thousands of slot documents.

### `doctors/{doctorId}/exceptions/{yyyy-MM-dd}`
Day off / custom hours overriding the weekly pattern.
```jsonc
{ "date": "2026-10-06", "isClosed": true, "ranges": [] }
```

### `appointments/{appointmentId}`
Top-level collection (queried by both roles).
```jsonc
{
  "id": "apt_001",
  "doctorId": "doc_001",
  "doctorName": {
    "en": "Dr. Ahmed Hassan",
    "ar": "د. أحمد حسن"
  },                                      // denormalised bilingual snapshot
  "patientId": "pat_001",
  "patientName": "Mona Ali",            // denormalised
  "patientPhone": "+2010...",
  "date": "2026-10-06",                 // yyyy-MM-dd, string → easy equality queries
  "startTime": "09:30",                 // HH:mm 24h
  "endTime": "10:00",
  "startAt": "<Timestamp>",             // full datetime — used for ordering & upcoming/past
  "slotLockId": "doc_001_2026-10-06_09:30", // matching lock; required for booking/cancel rules
  "status": "pending",                  // pending | confirmed | cancelled | completed
  "notes": "",
  "cancelReason": null,
  "cancelledBy": null,                  // "patient" | "doctor"
  "createdAt": "<Timestamp>",
  "updatedAt": "<Timestamp>"
}
```

> **Denormalization note:** `doctorName` and `patientName` on appointments are
> snapshot values captured at booking time and are not updated retroactively.
> This is a known trade-off for avoiding N+1 reads. For bilingual `doctorName`,
> store as a map `{"en": "...", "ar": "..."}` matching the doctor's `name` format.

> **Time handling:** All date strings and Timestamps use **Cairo local time**
> (the app's only deployment region in v1). `startAt` is constructed as
> `DateTime(date.year, date.month, date.day, hour, minute)` in local time, then
> stored as a Firestore Timestamp (which converts to UTC internally). The `date`
> string is always the local date.

### `reviews/{appointmentId}`  🆕
The document ID is the **completed appointment ID**, which makes one-review-per-appointment
structurally enforceable.
```jsonc
{
  "id": "apt_001",
  "doctorId": "doc_001",
  "patientId": "pat_001",
  "patientName": "Mona Ali",
  "appointmentId": "apt_001",         // must equal the document ID
  "rating": 5,                        // integer 1..5
  "comment": "Very helpful",
  "createdAt": "<Timestamp>",
  "updatedAt": "<Timestamp>"
}
```
See `07 §F` for how the aggregate on `doctors/{id}` is kept in sync. For v1 we keep
the client-side transaction approach; the rules below enforce the review eligibility,
identity, and edit window. A server-side recomputation can be added later on Blaze; it
is explicitly **not** part of the Spark v1 implementation.

### `slotLocks/{doctorId}_{date}_{startTime}`  ← concurrency guard
A document whose **ID encodes the slot**. Created inside the booking transaction.
Because Firestore document IDs are unique, two simultaneous bookings cannot both
succeed.

---

## 4. Booking Transaction (the important bit)

```dart
Future<AppointmentModel> book(BookingParams p) async {
  final lockId = '${p.doctorId}_${p.date}_${p.startTime}';
  final lockRef = _db.collection(FbC.slotLocks).doc(lockId);
  final aptRef  = _db.collection(FbC.appointments).doc();

  return _db.runTransaction((tx) async {
    final lock = await tx.get(lockRef);
    if (lock.exists) throw SlotTakenException();

    final apt = AppointmentModel(id: aptRef.id, status: AppointmentStatus.pending, ...);
    tx.set(lockRef, {
      'appointmentId': aptRef.id,
      'patientId': p.patientId,
      'doctorId': p.doctorId,
      'date': p.date,
      'startTime': p.startTime,
      'createdAt': FieldValue.serverTimestamp(),
    });
    tx.set(aptRef, apt.copyWith(slotLockId: lockId).toJson());
    return apt;
  });
}
```
On cancel: delete the lock doc in the same transaction that flips `status` to `cancelled`,
so the slot frees up.

---

## 5. Required Indexes

`firestore.indexes.json` — these composite indexes are mandatory or queries throw:

| Collection | Fields |
|---|---|
| `appointments` | `patientId` ASC, `startAt` DESC |
| `appointments` | `doctorId` ASC, `date` ASC, `startTime` ASC |
| `appointments` | `doctorId` ASC, `status` ASC, `startAt` ASC |
| `doctors` | `isActive` ASC, `specialization` ASC, `rating` DESC |
| `doctors` | `isActive` ASC, `nameSearch` ASC  *(prefix search)* |
| `doctors` | `isActive` ASC, `isVerified` ASC, `rating` DESC |
| `reviews` | `doctorId` ASC, `createdAt` DESC |
| `reviews` | `patientId` ASC, `appointmentId` ASC |

---

## 6. Security Rules (starting point)

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function signedIn()  { return request.auth != null; }
    function uid()       { return request.auth.uid; }
    function userRole()  { return get(/databases/$(database)/documents/users/$(uid())).data.role; }
    function isDoctor()  { return signedIn() && userRole() == 'doctor'; }

    match /users/{userId} {
      // Both roles can read their own profile. Doctors can read patient
      // profiles for booking contact info. For production, restrict to
      // patients who have booked with the doctor.
      allow read: if signedIn() && (uid() == userId || isDoctor());
      // both roles may self-register, but only these two values
      allow create: if signedIn() && uid() == userId
                    && request.resource.data.role in ['patient', 'doctor']
                    && request.resource.data.isActive == true;
      // role can NEVER change from the client. The user may toggle only account-state
      // fields needed by the Spark deactivation flow; other immutable identity fields
      // keep their normal feature-specific update rules.
      allow update: if signedIn() && uid() == userId
                    && request.resource.data.role == resource.data.role
                    && request.resource.data.uid == resource.data.uid;
      allow delete: if false;
    }

    match /doctors/{doctorId} {
      allow read: if signedIn();
      allow write: if isDoctor() && uid() == doctorId;

      match /availability/{day} {
        allow read: if signedIn();
        allow write: if isDoctor() && uid() == doctorId;
      }
      match /exceptions/{date} {
        allow read: if signedIn();
        allow write: if isDoctor() && uid() == doctorId;
      }
    }

    match /appointments/{id} {
      allow read: if signedIn() &&
        (resource.data.patientId == uid() || resource.data.doctorId == uid());

      // A booking must be created atomically with its matching slot lock.
      allow create: if signedIn()
        && request.resource.data.patientId == uid()
        && request.resource.data.status == 'pending'
        && request.resource.data.slotLockId is string
        && existsAfter(/databases/$(database)/documents/slotLocks/$(request.resource.data.slotLockId))
        && getAfter(/databases/$(database)/documents/slotLocks/$(request.resource.data.slotLockId)).data.appointmentId == id;

      // Patient may only cancel their own appointment; doctor may change status.
      // Any cancellation/rejection must delete the matching lock in the same transaction.
      allow update: if signedIn() && (
        (resource.data.patientId == uid()
           && request.resource.data.status == 'cancelled'
           && request.resource.data.doctorId == resource.data.doctorId
           && request.resource.data.slotLockId == resource.data.slotLockId
           && !existsAfter(/databases/$(database)/documents/slotLocks/$(resource.data.slotLockId)))
        ||
        (resource.data.doctorId == uid() && isDoctor()
           && (request.resource.data.status != 'cancelled'
               || !existsAfter(/databases/$(database)/documents/slotLocks/$(resource.data.slotLockId))))
      );
      allow delete: if false;
    }

    match /slotLocks/{lockId} {
      allow read: if signedIn();

      // The lock is valid only when the same transaction also creates a pending
      // appointment owned by the requesting patient. This prevents fake locks.
      allow create: if signedIn()
        && request.resource.data.appointmentId is string
        && request.resource.data.patientId == uid()
        && request.resource.data.doctorId is string
        && request.resource.data.date is string
        && request.resource.data.startTime is string
        && getAfter(/databases/$(database)/documents/appointments/$(request.resource.data.appointmentId)).data.status == 'pending'
        && getAfter(/databases/$(database)/documents/appointments/$(request.resource.data.appointmentId)).data.patientId == uid()
        && getAfter(/databases/$(database)/documents/appointments/$(request.resource.data.appointmentId)).data.doctorId == request.resource.data.doctorId
        && getAfter(/databases/$(database)/documents/appointments/$(request.resource.data.appointmentId)).data.date == request.resource.data.date
        && getAfter(/databases/$(database)/documents/appointments/$(request.resource.data.appointmentId)).data.startTime == request.resource.data.startTime
        && lockId == getAfter(/databases/$(database)/documents/appointments/$(request.resource.data.appointmentId)).data.slotLockId;

      // Patient can release their own lock; doctor can release the lock for their appointment.
      allow delete: if signedIn() && (
        resource.data.patientId == uid()
        || (isDoctor()
            && get(/databases/$(database)/documents/appointments/$(resource.data.appointmentId)).data.doctorId == uid())
      );
    }

    match /reviews/{reviewId} {
      allow read: if signedIn();

      // reviewId == appointmentId guarantees one review per appointment.
      // Create is allowed only after a COMPLETED appointment owned by this patient.
      allow create: if signedIn()
        && reviewId == request.resource.data.appointmentId
        && request.resource.data.patientId == uid()
        && request.resource.data.doctorId == get(/databases/$(database)/documents/appointments/$(request.resource.data.appointmentId)).data.doctorId
        && request.resource.data.rating is int
        && request.resource.data.rating >= 1
        && request.resource.data.rating <= 5
        && get(/databases/$(database)/documents/appointments/$(request.resource.data.appointmentId)).data.status == 'completed'
        && get(/databases/$(database)/documents/appointments/$(request.resource.data.appointmentId)).data.patientId == uid();

      // Reviews are editable by the patient for 7 days only. Identity and the
      // appointment link are immutable.
      allow update: if signedIn()
        && resource.data.patientId == uid()
        && request.resource.data.appointmentId == resource.data.appointmentId
        && request.resource.data.doctorId == resource.data.doctorId
        && request.resource.data.patientId == resource.data.patientId
        && request.resource.data.createdAt == resource.data.createdAt
        && request.resource.data.rating is int
        && request.resource.data.rating >= 1
        && request.resource.data.rating <= 5
        && request.time < resource.data.createdAt + duration.value(7, 'd');

      allow delete: if false;
    }
  }
}
```

> `get()` calls inside rules cost a read and count against the 10-lookup limit.
> If rule latency becomes an issue, that's the signal to migrate `role` to Custom Claims.

---

## 7. Collection & Field Name Constants

No string literals for Firestore paths anywhere in the codebase:

```dart
// core/constants/firebase_constants.dart
abstract final class FbC {
  static const users        = 'users';
  static const doctors      = 'doctors';
  static const availability = 'availability';
  static const exceptions   = 'exceptions';
  static const appointments = 'appointments';
  static const slotLocks    = 'slotLocks';
  static const reviews      = 'reviews';

  // fields
  static const role       = 'role';
  static const doctorId   = 'doctorId';
  static const patientId  = 'patientId';
  static const status     = 'status';
  static const startAt    = 'startAt';
  static const date       = 'date';
  static const slotLockId = 'slotLockId';
}
```

---

## 8. Auth Implementation Notes

- **Google Sign-In:** `google_sign_in` ^6.x. On Android you must add the SHA-1 **and**
  SHA-256 fingerprints to the Firebase project and re-download `google-services.json`,
  otherwise sign-in fails silently with `ApiException: 10`.
- **First Google sign-in has no Firestore doc yet.** After `signInWithCredential`, check
  `additionalUserInfo.isNewUser` → if true, **do not** automatically assign `role: 'patient'`.
  Instead, redirect to the **role selection screen**. The user picks their role there,
  and only then is the `users/{uid}` doc created with the chosen role. This keeps the
  flow consistent with email registration.
- **Email verification:** send on sign-up, but don't hard-block login in v1 — show a banner.
- **Account deletion (Spark v1):** use **Deactivate account** instead of a server-side
  purge. After recent re-authentication, the client updates the current profile
  (`isActive: false`, `updatedAt: serverTimestamp`) and signs the user out. The
  appointment/review history remains intact for data integrity. Do not add
  `cloud_functions` or attempt a server-side cascade on Spark. A true purge is deferred
  to a future Blaze implementation.
- Store `google-services.json` / `GoogleService-Info.plist` out of git; use
  `flutterfire configure` and gitignore `firebase_options.dart`? **No — commit
  `firebase_options.dart`** (it contains no secrets) but gitignore the platform files
  if the repo is public.
- **Offline:** enable `FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true)`
  so appointment lists render from cache.

### Spark account deactivation contract

The v1 flow is deliberately client-only and Spark-compatible:

```text
Settings → confirm deactivation → recent re-authentication
→ update users/{uid}.isActive = false → sign out
```

The patient/doctor documents are retained so past appointments and reviews do not lose
their foreign-key context. The UI must clearly say that this is an account **deactivation**,
not an immediate irreversible backend purge. Full deletion can be introduced later on
Blaze with a server-side callable/administrative workflow.

---

## 9. Seeding

Write `tool/seed_firestore.dart` that creates ~8 doctors across 5 specializations with
weekly availability, clinic addresses, optional remote `photoUrl` values, clinic phones,
and 3-10 reviews each (so ratings look plausible), plus 2 test patients and a few
completed appointments to exercise the review flow. Location coordinates may remain
optional/seeded as plain numbers; interactive map/geolocation UI is deferred to v1.1.
Needed for the UI to look real during development and for comparing the three branches on
identical data.
