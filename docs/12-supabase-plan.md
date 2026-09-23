# 12 — Supabase Plan Constraints

## Status

**LOCKED:** Doctor Hunt v1 must run on the **Supabase free tier**.
No paid billing account should be required for the baseline project.

## 1. What we can use

| Supabase capability | v1 status | Notes |
|---|---|---|
| Supabase Auth | ✅ | Email/Password + Google Sign-In |
| PostgreSQL Database | ✅ | Stay within free tier quotas |
| RLS Policies | ✅ | Core authorization boundary |
| PostgreSQL RPCs | ✅ | Booking and rating aggregate updates |
| Push Notifications | ⏭️ | Out of scope for v1 |
| Supabase Storage | ❌ | Excluded from v1 scope |
| Edge Functions | ❌ | Excluded from v1 scope |
| Database Webhooks | ❌ | Avoid webhooks that depend on external billing |

## 2. Quotas that shape the design

The current Supabase free tier quota includes:
- 500 MB database size
- 5 GB bandwidth / month
- 50,000 monthly active users

These limits are appropriate for a small portfolio/demo application. The code must
avoid wasteful queries. Use pagination, targeted queries, and deterministic RPCs.

## 3. Account lifecycle in v1

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
profiles.is_active = false (via RPC)
  ↓
supabase.auth.signOut()
```

Past appointments and reviews remain stored because v1 has no trusted server-side cascade (Edge Functions are excluded). A future implementation may introduce a callable administrative purge.

## 4. Profile images

Do not implement Supabase Storage uploads in v1. The `photo_url` field remains
optional so seeded doctors can use pre-existing remote image URLs. Otherwise render a
local initials/placeholder avatar. `image_picker` is therefore not part of the v1 dependency set.

## 5. Booking without Edge Functions

Booking remains client-driven but uses an RPC (e.g. `book_appointment`) instead of a raw insert to handle:
1. Concurrency locks via the unique partial index `idx_appointments_concurrent_lock`.
2. Ensuring no overlapping pending/confirmed appointments exist for that doctor at that time.

This replaces the Firestore client-side transaction approach, placing the atomicity safely within PostgreSQL.

## 6. Ratings without Edge Functions

The v1 branch implementation uses an RPC (`add_review`) to update the review and the doctor's aggregate `rating` / `rating_count` safely in a single database transaction. RLS rules must enforce the review's appointment, patient identity, doctor identity, 1–5 rating range, and seven-day edit window.

## 7. Maps and billing

Interactive Google Maps and geolocation are deferred to v1.1. v1 only stores an address
and optionally coordinates and uses `url_launcher` to open an external maps app/browser.
Do not introduce a Maps SDK or billing-dependent location stack into the baseline.

## 8. CI / local development rule

CI and local commands must not require:
- Deploying Edge Functions
- Supabase Storage configured
- A paid billing plan on Supabase

The baseline should be fully operational against a fresh local Supabase instance (`supabase start`) or a free-tier remote instance.

## Official Supabase references
- https://supabase.com/pricing
