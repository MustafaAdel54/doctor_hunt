# 12 — Firebase Spark Plan Constraints

## Status

**LOCKED:** Doctor Hunt v1 must run on the **Firebase Spark (no-cost) plan**.
No billing account should be required for the baseline project.

## 1. What we can use

| Firebase capability | v1 status | Notes |
|---|---|---|
| Firebase Authentication | ✅ | Email/Password + Google Sign-In |
| Cloud Firestore | ✅ | Stay within Spark quotas |
| Firestore Security Rules | ✅ | Core authorization boundary |
| Firestore transactions | ✅ | Booking and rating aggregate updates |
| Cloud Messaging | ⏭️ | Out of scope for v1 |
| Cloud Storage for Firebase | ❌ | Requires Blaze |
| Cloud Functions for Firebase | ❌ | Requires Blaze |
| Firebase Extensions | ❌ | Avoid extensions that depend on Cloud Functions |

## 2. Quotas that shape the design

The current Firestore Spark free quota is:

- 1 GiB stored data
- 50,000 document reads / day
- 20,000 document writes / day
- 20,000 document deletes / day
- 10 GiB outbound data / month

These limits are appropriate for a small portfolio/demo application, but the code must
avoid wasteful reads and writes. Use pagination, bounded queries, targeted listeners,
and deterministic documents for uniqueness where possible.

## 3. Account lifecycle in Spark v1

### UI terminology
Use **Deactivate account**, not “Delete account”, for the v1 Settings action.

Flow:

```text
Settings
  ↓
Confirm deactivation
  ↓
Recent re-authentication
  ↓
users/{uid}.isActive = false
  ↓
signOut()
```

Past appointments and reviews remain stored because v1 has no trusted server-side
cascade. A future Blaze version may introduce a callable/administrative purge.

## 4. Profile images

Do not implement Firebase Storage uploads in Spark v1. The `photoUrl` field remains
optional so seeded doctors can use pre-existing remote image URLs. Otherwise render a
local initials/placeholder avatar. `image_picker` and `firebase_storage` are therefore
not part of the v1 dependency set.

## 5. Booking without Cloud Functions

Booking remains client-side but must be atomic:

1. Build a deterministic `slotLockId`.
2. Run a Firestore transaction.
3. Read the lock.
4. Abort if it exists.
5. Create the pending appointment and lock together.
6. Let Firestore Security Rules validate the matching `getAfter()` state.

This prevents two clients from successfully claiming the same deterministic slot.

## 6. Ratings without Cloud Functions

The v1 branch implementation uses a client-side Firestore transaction to update
`ratingSum` / `ratingCount`. Security rules must enforce the review's appointment,
patient identity, doctor identity, 1–5 rating range, and seven-day edit window.

This is acceptable for the portfolio demo but is intentionally documented as client-trusted.
The production hardening path is a future Blaze server-side function.

## 7. Maps and billing

Interactive Google Maps and geolocation are deferred to v1.1. v1 only stores an address
and optionally coordinates and uses `url_launcher` to open an external maps app/browser.
Do not introduce a Maps SDK or billing-dependent location stack into the Spark baseline.

## 8. CI / local development rule

CI and local commands must not require:

- `firebase deploy --only functions`
- `firebase storage:*`
- Cloud Billing credentials
- A Google Cloud project with enabled billing APIs

The baseline should be testable with the Firebase Local Emulator Suite and the Spark
project configuration alone.

## Official Firebase references

- https://firebase.google.com/docs/projects/billing/firebase-pricing-plans
- https://firebase.google.com/docs/firestore/quotas
- https://firebase.google.com/docs/functions/quotas
- https://firebase.google.com/docs/storage/faqs-storage-changes-announced-sept-2024
