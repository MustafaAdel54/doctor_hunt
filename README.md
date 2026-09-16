# Doctor Hunt — Build Specification

Reference documentation for building a Flutter doctor-appointment app three times
over, once per state management approach, on a shared core.

**Read in order.** Every file assumes the ones before it.

---

## Documents

| # | File | What's in it |
|---|---|---|
| 00 | `00-overview.md` | Product, roles, locked technical decisions, the 8 hard coding rules |
| 01 | `01-architecture.md` | Two-layer data/presentation design, `Either<Failure,T>`, DI |
| 02 | `02-folder-structure.md` | Exact directory tree (from the owner's screenshot) + naming |
| 03 | `03-theming-and-styles.md` | The atomic style system, ScreenUtil, ThemeData |
| 04 | `04-routing-gorouter.md` | Routes, `SessionService`, role redirects, 7 gotchas |
| 05 | `05-localization-slang.md` | slang setup, full EN/AR key tree, RTL rules |
| 06 | `06-firebase-and-data-model.md` | Firestore schema, booking transaction, security rules |
| 07 | `07-features-and-screens.md` | Screen-by-screen spec, appointment lifecycle, widget inventory |
| 08 | `08-state-management-branches.md` | Git strategy + Bloc / Riverpod / GetX patterns |
| 09 | `09-conventions-and-setup.md` | pubspec, lint, CI, testing, build order |
| 10 | `10-generator-fixes-changelog.md` | Every fix applied to `generate_style.dart` and why |
| 11 | `11-color-system.md` | Figma palette → 19 semantic tokens, dark derivation, contrast audit |

## Code files (`../tools/`)

| File | Goes to | Notes |
|---|---|---|
| `generate_style.dart` | `tool/generate_style.dart` | **Not** in `lib/` — it imports `dart:io` |
| `app_colors.dart` | `lib/generated/app_colors.dart` | Hand-written; the generator imports it |

Run: `dart run tool/generate_style.dart` → writes `lib/generated/style_atoms.dart`
(1,425 getters, verified zero name collisions).

---

## Locked Decisions

| Area | Decision |
|---|---|
| Architecture | Feature-first, two layers (`data` / `presentation`) — no `domain/` |
| State management | 3 branches: `feature/bloc`, `feature/riverpod`, `feature/getx` from a shared `main` |
| Routing | `go_router` with `SessionService` driving redirects |
| Localization | `slang` (type-safe keys), EN + AR, full RTL |
| Responsive | `flutter_screenutil`, design size 375×812, `.sp` applied inside the generator |
| Backend | Firebase Auth (Email + Google) + Firestore + Storage |
| Roles | `users/{uid}.role` = `patient` \| `doctor`, immutable after create |
| Theming | Atomic generated styles, light + dark via `ThemeExtension` |
| Font | Cairo (200–900) |
| Errors | `dartz` `Either<Failure, T>`, failures carry no strings |
| Brand | Green `#0EBE7F`, secondary blue `#2E6FF2`, warning amber `#F59E0B` |

---

## Build Order

1. `flutter create`, then `flutterfire configure`
2. Copy `app_colors.dart` → `lib/generated/`, run the style generator
3. Mirror the folder structure from `02`
4. `core/` — constants, extensions, error, themes
5. slang setup with the key tree from `05`
6. Shared widgets from `07 §G`
7. Data layer: models → services → repos
8. `SessionService` + router
9. Firestore rules, indexes, seed script
10. **Commit, tag `core-v1`, then fork the three branches**
11. Implement features one branch at a time

---

## Things That Will Bite You

Each is documented in detail where it's listed.

1. **Double booking** — two patients can take the same slot. Requires a Firestore
   transaction + `slotLocks` doc. `06 §4`
2. **`.sp` double-application** — the generator applies it; never write `.sp` at a
   call site. `03 §7`
3. **Forgetting `extensions: [AppColorsTheme.light]`** in `ThemeData` — every colour
   silently falls back to the light palette. `03 §6`
4. **GetX + go_router** — never call `Get.to()` / `Get.offAll()`. GetX is state + DI
   only on that branch. `08 §4`
5. **Redirect loops** — every `redirect` branch must be able to return `null`. `04 §5`
6. **Google sign-in with no Firestore doc** — first-time Google users need a `users/`
   doc created before `SessionService` resolves, or they hit a redirect loop. `06 §8`
7. **Only the doctor can mark `completed`** — if they forget, no reviews ever appear.
   Dashboard nudges are mandatory. `07 §C2`
8. **No notifications in v1** — patients aren't told when a booking is accepted. This
   is why the clinic phone number is prominent everywhere. `07 §F2`
9. **Firestore can't do substring search** — client-side filtering for v1. `07 §B2`
10. **Amber is a fill colour** — `#F59E0B` is 2.15:1 on white. Dark label on an amber
    chip, never amber text. `11 §3`

---

## Known Limitations (state these in the repo README)

- **Anyone can self-register as a doctor.** No verification. Production needs an
  approval queue or licence check. `06 §2`
- **Rating aggregates are updated client-side.** Race-safe via transaction, but
  spoofable. Production needs a Cloud Function. `07 §F`
- **Maps deferred to v1.1** — no Maps API key. Schema fields are reserved so it's
  additive later. `07 §B3`
- **Models are shared between wire format and UI** — a deliberate consequence of
  dropping `domain/`.
- **Dark palette is derived, not designed** — contrast-audited but not designer-approved.

---

## Still Open

**Numerals in Arabic:** Western (`3:30`) or Arabic-Indic (`٣:٣٠`) for times and
dates? Recommendation: Western. One-line change in `core/utils/date_utils.dart`.
