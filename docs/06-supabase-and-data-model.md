# 06 — Supabase, Data Model & Security

> ✅ **FINAL.** The database architecture is locked. This document is the one canonical security and data model overview.
> **DO NOT** duplicate schema, RLS, or grants content into other documentation files; always link here.

## 1. Services Used

| Service | Purpose |
|---|---|
| **Supabase Auth** | Email/Password + Google Sign-In (ID token) |
| **PostgreSQL Database** | Core application data, constraints, and logic (RPCs) |
| *(Excluded in v1)* | Supabase Storage (no uploads), Edge Functions |

---

## 2. Source of Truth: Canonical Schema & Tests

The complete, live database structure is defined entirely in SQL. Do not rely on Dart models or this document as the ground truth for database constraints.

- **Schema Definition**: `supabase/schema.sql` is the sole source of truth for all tables, columns, constraints, unique indexes, RLS policies, RPC functions, and table/column grants. If it is not in this file, it does not exist.
- **Security Verification**: `supabase/tests/database/01_rls_and_rpc.sql` contains the executable behavior reference (a 70-assertion pgTAP suite) proving the security model works.
  - *Testing Note:* The pgTAP suite uses a `tests.authenticate_as(uuid)` helper to reliably set both `request.jwt.claim.sub` and `request.jwt.claims` for authenticated user assertions.

---

## 3. Role Resolution

Roles are stored in the PostgreSQL `profiles` table.

Flow:
1. User signs in via Supabase Auth (or Google Sign-In) → returns a session with a `user.id`.
2. `SessionService` queries the `profiles` table for this ID.
3. If the profile exists, the `role` enum (`'doctor'` \| `'patient'`) is read.
4. `go_router` redirect uses it to route the user.
5. If the user exists in auth but no profile row exists, the router exposes `SessionStatus.authenticatedWithoutProfile` and routes the user to the **role selection screen**.

**Registration**: The user selects their role on the first screen. The `profiles` row is created with that role.

> **Security Position:** Users self-select their roles. A `role` is immutable after creation. Anyone can register as a doctor for demo purposes.

---

## 4. Timestamps & Timezones

All timestamps and date/time fields in the database must follow this contract:
- **Database**: Stored as `timestamptz` (Timestamp with Time Zone) in **UTC** (canonical).
- **Client (Flutter)**: Timezones are converted to the local time for display in the UI.

---

## 5. Security Model & Architecture

The backend employs a two-schema architecture to securely handle business logic (like booking and rating) without exposing internal mechanisms:

### The `public` Schema (Security Invoker)
Contains all tables and views directly accessible by the Flutter client. RPCs in the public schema are marked `SECURITY INVOKER`, running with the privileges of the calling user.

### The `private` Schema (Security Definer)
Contains internal helper functions (e.g., `is_slot_valid`, `is_slot_available`) that must read from tables bypassing normal RLS rules to compute availability safely.
- Functions are marked `SECURITY DEFINER` and `SET search_path = ''`.
- **CRITICAL:** `EXECUTE` privileges on private functions are explicitly **REVOKED** from `public`, `authenticated`, `anon`, and `service_role`. They can only be called by public wrapper functions.

### Table & Column Grants
We use strict column-level grants. For example, users can `UPDATE` specific fields like `name` or `phone` on their profile, but cannot update their `role`.

### Concurrency
Instead of client-side locks, concurrency is handled directly by PostgreSQL using a **Unique Partial Index** (`idx_appointments_concurrent_lock`). This guarantees that no two pending/confirmed appointments can overlap for the same doctor at the same time.

---

## 6. Constants (Supabase)

No string literals for table or RPC names in the presentation or controller layers. Use constants:

```dart
// core/constants/supabase_constants.dart
abstract final class SupaC {
  static const profiles = 'profiles';
  static const doctors = 'doctors';
  static const appointments = 'appointments';
  static const reviews = 'reviews';
  // ...
}
```

---

## 7. Account Deactivation (v1 Scope)

Because Edge Functions are excluded in v1, true server-side account deletion/cascade is not implemented.
- **Flow**: The client updates `profiles.is_active = false` via an RPC and signs the user out.
- **Router**: The router detects `is_active == false` and traps the user in an `/account-inactive` screen.
- This preserves data integrity for appointments and reviews.
