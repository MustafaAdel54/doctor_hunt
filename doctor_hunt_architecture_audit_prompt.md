# PROMPT — Doctor Hunt: Documentation & Data-Architecture Audit (READ-ONLY, NO CODE YET)

> Paste everything below this line into Antigravity, and attach / @-reference **all** the project files (all `.md` docs, `app_colors`, the `generated` text-style file, `pubspec.yaml`, and any existing `lib/` code).

---

## 0. Your role

You are a **senior Flutter architect + technical documentation auditor**.

Your job in this task is **NOT to write the app**. Your job is to **read every file I attached**, reconstruct the project's currently-documented **data architecture**, compare it against the **authoritative spec in Section 2 below**, and report **exactly** what is wrong, missing, contradictory, or unused — so we can fix the docs **before** a single line of implementation is written.

## 1. Hard operating rules

1. **READ-ONLY in this turn.** Do not create, rename, delete, or edit any file. Do not scaffold folders. Do not run `flutter create`, `flutter pub add`, or any write/install command.
2. **No implementation.** No feature code, no models, no widgets, no Firestore rules — not even "example" snippets longer than the 2–3 lines needed to prove a point in a finding.
3. **Evidence over assumption.** Every finding must cite the **file name + section/heading (and line numbers if available)** it came from. If something is not stated anywhere in the docs, say *"not documented anywhere"* — never silently assume it and never invent a requirement.
4. **Read 100% of what I gave you before writing anything.** Open every attached file end-to-end, including the ones that look boring (`app_colors`, the `generated` styles file, `pubspec.yaml`, README, any `.md` in `docs/`). Do not sample, do not skim, do not stop early.
5. **Stop at the gate.** Produce the audit report, then **STOP and wait for my explicit approval**. Do not touch the `.md` files until I reply `APPROVED` (see Section 6).
6. If you find genuine ambiguity that blocks the audit, list it in the *Open Questions* section — do not guess and move on.

## 2. Authoritative project spec (this is the source of truth — the docs must match THIS)

**App name:** Doctor Hunt — a doctor appointment booking application (Flutter).

**Roles — exactly TWO:**
- **Doctor**
- **Patient**

There is **no admin role** in the current scope. If any document mentions an admin, a super-admin, a moderator, a clinic-owner dashboard, or an approval/verification workflow that requires a third actor, **flag it** as out-of-scope (tell me whether to delete it or park it in a "Future / Out of scope" section).

**Doctor capabilities:**
- Creates and manages their professional profile (name, specialty, bio, photo, fees, experience, etc. — report exactly which fields the docs define).
- Defines their **location / clinic** (address, city, geo-coordinates, room — report what the docs actually define).
- Publishes their **available appointment slots** (working days, working hours, slot duration, breaks, exceptions/days off).
- Sees incoming bookings and can confirm / reject / cancel them (verify whether the docs actually define this — if not, it's a gap).

**Patient capabilities:**
- Signs up / signs in, manages their own profile.
- Browses / searches / filters doctors (by specialty, location, rating, availability — report what's documented).
- Views a doctor's profile and their **available** slots only.
- **Books a specific time slot** at a specific doctor's location.
- Views their upcoming and past appointments, and cancels / reschedules (verify this is documented).

**Mandatory technical constraints — every one of these must be reflected in the docs:**

| # | Constraint | What to verify in the docs |
|---|-----------|----------------------------|
| T1 | **Responsive sizing via `flutter_screenutil`** (`ScreenUtil`) — the "sizing utils" layer | Package is in `pubspec.yaml`; `ScreenUtilInit` is documented at app root with a stated design size; docs mandate `.w` / `.h` / `.r` / `.sp` and **forbid raw hardcoded pixel values** |
| T2 | **`AppColors` only** — the colors file I attached is the single source of truth | Docs forbid `Color(0xFF…)`, `Colors.*`, or any ad-hoc color literal outside `AppColors`; verify theming (light/dark?) is defined against it |
| T3 | **The attached `generated` text-style file only** (generated text styles) | Docs forbid raw `TextStyle(...)` / `GoogleFonts…` inline in widgets; every text must come from the generated styles (optionally `.copyWith` for color only) |
| T4 | **`go_router` for all navigation** | Docs define a central router file, named routes + path constants, **role-based redirect/guard logic** (doctor vs patient vs unauthenticated), deep-link paths, and **forbid `Navigator.push` / `Navigator.pushNamed`** |
| T5 | **Firebase as the backend** | Docs define which Firebase products are used (Auth, Firestore, Storage, Messaging/FCM, Functions?) and how each is used |

## 3. What to actually audit (checklists)

### 3.1 Data architecture (deepest pass — this is the priority)

For the data model as documented, verify and report on:

- **Entities & collections:** the full list (e.g. `users`, `doctors`, `patients`, `availability`/`slots`, `appointments`, `specialties`, `reviews`, `notifications`). For each: purpose, document ID strategy, and every field with its type and nullability.
- **Relationships:** how doctor ↔ slot ↔ appointment ↔ patient are linked. Are references IDs, paths, or subcollections? Is it consistent across all documents?
- **Role modeling:** is `role` a field on one `users` collection, or two separate collections, or both? **Is it consistent everywhere in the docs?** Contradictions here are Blockers.
- **Availability model:** recurring weekly schedule vs. explicitly generated slot documents vs. free-range intervals. Is the chosen model stated **once and unambiguously**? Can a patient's query actually fetch "available slots for doctor X on date D" efficiently with it?
- **Booking integrity (critical):** is **double-booking** prevented? Is a Firestore **transaction / atomic write** documented for the booking operation? What is the uniqueness key (doctorId + startTime)?
- **Status lifecycles:** appointment status enum (e.g. `pending / confirmed / cancelled / completed / noShow`) — are all values listed, and is every legal transition and who can trigger it documented?
- **Time handling:** UTC vs local, `Timestamp` vs `String` vs epoch millis, timezone/DST handling, and how "past slots" are excluded. Flag any inconsistency in how time is stored across collections.
- **Query patterns → indexes:** for each documented screen, name the query it needs, then check whether the data shape supports it and whether required **composite indexes** are mentioned. Flag any query that Firestore cannot serve (e.g. multiple range filters, OR-ing across fields, unsupported `array-contains` combos).
- **Denormalization:** are doctor name/photo/specialty duplicated onto the appointment doc to avoid N+1 reads? If duplicated, is the update/consistency strategy documented?
- **Security rules:** are Firestore/Storage rules described per collection per role? Specifically: can a patient read another patient's appointments? Can a patient write to a doctor's availability? Can a user escalate their own `role` field? Flag every hole.
- **Storage:** where profile images / documents live, path convention, size/type limits.
- **Scalability & cost:** any documented pattern that causes an unbounded read fan-out, a full-collection scan, or a hot document.

### 3.2 Cross-cutting consistency

- **Naming consistency:** same concept named differently across files (`slot` vs `timeSlot` vs `availability`; `patientId` vs `userId`; `doctor_id` vs `doctorId`). Also check field naming convention (camelCase vs snake_case) is uniform.
- **Docs vs. attached code:** does the documented color/text-style/route naming actually match the identifiers that exist in the attached `app_colors` and `generated` styles files? Name every color or style the docs reference that **does not exist** in the real file, and vice versa.
- **Docs vs. `pubspec.yaml`:** every package the docs rely on is declared, and every declared package is actually used somewhere in the docs.
- **State management:** which solution do the docs mandate (Bloc/Cubit, Riverpod, Provider, GetX)? Is it stated **once** and used consistently, or do different documents contradict each other? Flag any file that assumes a different one.
- **Folder / layer architecture:** is it clean-architecture, feature-first, or layer-first? Is the stated structure internally consistent, and does it match any existing `lib/` folders I attached?
- **Screen inventory ↔ data model:** for every screen in the docs, confirm the data it needs exists in the model. For every model field, confirm some screen/feature actually uses it — anything unused goes in the "Unused / dead" bucket.
- **Auth flows:** sign-up, sign-in, role selection at registration, password reset, email verification, session persistence, sign-out, account deletion. Report which are missing.

### 3.3 Unused / dead / over-engineered

Explicitly hunt for and list:
- Collections, fields, enums, screens, or packages that **nothing else in the docs ever references**.
- Features documented but outside the spec in Section 2 (chat, video calls, payments, insurance, prescriptions, ratings, an admin panel…). Do **not** delete them on your own — list them and ask me: keep, defer, or remove.
- Duplicated or conflicting documentation — the same topic specified twice with different content, or leftovers from a template/another project (wrong app name, placeholder text, copy-pasted sections).

## 4. Required output format

Write the report as a **single Markdown answer in the chat** (do **not** create a file yet), in this exact structure:

1. **Files Read** — a table of every file you opened: file → what it defines → 1-line verdict (`OK` / `Needs work` / `Conflicts`). Confirm explicitly that you read all of them.
2. **Reconstructed Data Architecture** — your neutral summary of what the docs *currently* describe: entity list, an ASCII/Mermaid relationship diagram, and the collection→fields table **exactly as documented** (not as you'd fix it).
3. **Spec Conformance Matrix** — one row per requirement from Section 2 (2 roles, doctor slot management, doctor location, patient booking, T1 ScreenUtil, T2 AppColors, T3 generated styles, T4 go_router, T5 Firebase), with columns: `Requirement | Status (✅ Covered / ⚠️ Partial / ❌ Missing / ⛔ Contradicted) | Evidence (file + section) | Note`.
4. **Findings** — numbered, each formatted as:
   - `ID` (F-01…), `Severity` (**Blocker / High / Medium / Low**), `Category` (Missing / Wrong / Contradiction / Unused / Ambiguous / Risk)
   - `Where`: file + section (+ lines)
   - `What the docs say now`: short quote
   - `Why it's a problem`: concrete consequence at implementation time (e.g. "this query will throw `FAILED_PRECONDITION`", "two patients can book the same slot")
   - `Proposed fix`: the exact replacement wording/structure you'd write
   Sort by severity, Blockers first.
5. **Unused / Out-of-scope Inventory** — table: `Item | Where | Referenced by | Recommendation (Delete / Defer to v2 / Keep — needs justification)`.
6. **MD File Change Plan** — per `.md` file: the precise list of edits you'd make (add section X, rewrite table Y, delete section Z), each mapped to the finding IDs it resolves. **Plan only — no edits yet.**
7. **Open Questions for me** — max 10, ranked by how much they block implementation, each with your recommended default answer so I can just say "go with your defaults".
8. **Go / No-Go** — a one-paragraph verdict: is this documentation set ready for implementation, and what is the minimum set of fixes required before we start?

Keep it dense and specific. No filler, no praise, no "as an AI". If something is already correct, one line in the conformance matrix is enough — spend the words on the problems.

## 5. Severity definitions

- **Blocker** — implementation cannot start or will require a rewrite later (e.g. contradictory role model, no booking-atomicity strategy, undefined availability model).
- **High** — will cause rework, a security hole, or a broken core user flow.
- **Medium** — inconsistency or gap that costs time but is locally fixable.
- **Low** — naming, wording, formatting, polish.

## 6. The gate (do not skip)

After you output the report, **STOP**. Do not modify anything.

I will reply with either:
- `APPROVED` → then, and only then, apply the Section 6 change plan to the `.md` files, and afterwards give me a diff summary (file → what changed → finding IDs resolved) plus write the full audit report to `docs/audit/ARCHITECTURE_AUDIT.md`.
- Specific instructions → apply only those.

Begin now with Step 1: read every attached file completely.
