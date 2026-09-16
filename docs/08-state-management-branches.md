# 08 — The Three State Management Branches

## 1. Git Strategy

```bash
# 1. build the shared core on main FIRST — do not start branches early
git checkout -b main
# ... core/, i18n/, data/, shared widgets, router, theme ...
git commit -m "feat(core): shared foundation"
git tag core-v1

# 2. fork the three branches from the SAME commit
git checkout -b feature/bloc     main
git checkout -b feature/riverpod main
git checkout -b feature/getx     main
```

### Merge policy
- Changes to `core/`, `data/`, `i18n/` → **commit on `main`**, then:
  ```bash
  git checkout feature/bloc     && git merge main
  git checkout feature/riverpod && git merge main
  git checkout feature/getx     && git merge main
  ```
- Changes to `presentation/controller/`, `state_injector.dart`, `main.dart`
  → stay on their branch, **never** merged back to `main`.
- Protect `main`. Branch PRs merge *from* main, not *into* it.
- Tag milestones identically on all three (`v1.0-bloc`, `v1.0-riverpod`, `v1.0-getx`)
  so benchmarks compare the same feature set.

### Comparison artifacts (the actual deliverable)
For each branch record, on the same device and same seeded data:

| Metric | How |
|---|---|
| Release APK size | `flutter build apk --release --analyze-size` |
| Cold start time | `flutter run --profile --trace-startup` |
| Rebuild count on booking screen | `debugPrintRebuildDirtyWidgets` / DevTools |
| LOC in presentation layer | `cloc lib/features/*/presentation` |
| Boilerplate per feature | files + lines to add one new screen |
| Testability | lines of test setup per controller |
| DevTools support | subjective 1–5 |

Put the results table in `docs/13-comparison-results.md` at the end.

---

## 2. `feature/bloc` — flutter_bloc (Cubit-first)

```yaml
flutter_bloc: ^8.1.6
bloc: ^8.1.4
equatable: ^2.0.5     # or freezed unions
dev: bloc_test: ^9.1.7
```

**Use Cubit by default.** Only use full `Bloc` where event traceability genuinely
matters (the booking flow is a decent candidate — document why if you do).

```dart
// features/auth/presentation/cubit/auth_state.dart
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.success(UserModel user) = AuthSuccess;
  const factory AuthState.error(Failure failure) = AuthError;
}

// cubit
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repo) : super(const AuthState.initial());
  final AuthRepo _repo;

  Future<void> signIn(String email, String password) async {
    emit(const AuthState.loading());
    final res = await _repo.signIn(email, password);
    emit(res.fold(AuthState.error, AuthState.success));
  }
}
```

Wiring: `BlocProvider(create: (_) => sl<AuthCubit>(), child: ...)` at the page level,
`BlocBuilder` for rendering, `BlocListener` for navigation/snackbars, `BlocConsumer`
when you need both. `buildWhen` on hot lists.

**Pros to note:** best-in-class DevTools + `bloc_test`, explicit and boring (good),
easy onboarding for teams.
**Cons:** most boilerplate; one class + one state file per feature minimum.

---

## 3. `feature/riverpod` — flutter_riverpod + codegen

```yaml
flutter_riverpod: ^2.5.1
riverpod_annotation: ^2.3.5
dev: riverpod_generator: ^2.4.3, riverpod_lint, custom_lint
```

Wrap the app in `ProviderScope`. Use `@riverpod` codegen — hand-written providers are
the old way.

```dart
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<UserModel?> build() => null;          // initial

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    final res = await ref.read(authRepoProvider).signIn(email, password);
    state = res.fold(
      (f) => AsyncError(f, StackTrace.current),
      (u) => AsyncData(u),
    );
  }
}

// streams become one-liners
@riverpod
Stream<List<Appointment>> myAppointments(MyAppointmentsRef ref) =>
    ref.watch(appointmentRepoProvider).watchForPatient(ref.watch(currentUidProvider));
```

UI: `ConsumerWidget` / `Consumer`, `ref.watch(...)`, `.when(data:, loading:, error:)`,
`ref.listen` for side effects.

**Notes:**
- `AsyncValue` maps perfectly onto the 4-state contract in `01 §4` — least friction.
- `autoDispose` (default with codegen) is great for the booking screen; add
  `keepAlive: true` for the doctors list cache.
- `ref.invalidate(availableSlotsProvider)` after a booking is much nicer than manual refresh.
- **Interop note:** we still use `get_it` for the data layer so branches stay comparable.
  Purists would use Riverpod providers for everything — mention this as a deviation in
  the comparison doc.

**Pros:** compile-safe, no BuildContext dependency, best async/caching story, least code.
**Cons:** steepest learning curve, codegen required for the good DX, DevTools weaker than Bloc.

---

## 4. `feature/getx` — GetX (state management only)

```yaml
get: ^4.6.6
```

> 🔴 **Hard rule for this branch: GetX is used for state + DI only.**
> Routing stays on `go_router`. **Never call `Get.to`, `Get.off`, `Get.offAll`,
> `Get.back`.** They maintain a parallel navigation stack and will desync the router.
> `Get.snackbar` / `Get.dialog` are allowed but prefer the shared `AppDialogs`.
>
> Use `GetMaterialApp.router(routerConfig: router)` — it gives you the Get overlay
> context without hijacking navigation.

```dart
class AuthController extends GetxController {
  AuthController(this._repo);
  final AuthRepo _repo;

  final state = RequestState.initial.obs;
  final Rxn<UserModel> user = Rxn<UserModel>();
  final Rxn<Failure> failure = Rxn<Failure>();

  Future<void> signIn(String email, String password) async {
    state.value = RequestState.loading;
    final res = await _repo.signIn(email, password);
    res.fold(
      (f) { failure.value = f; state.value = RequestState.error; },
      (u) { user.value = u;   state.value = RequestState.success; },
    );
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(() => AuthController(sl()));
}
```

UI: `Obx(() => ...)` — keep `Obx` as **narrow as possible**, wrapping only the reactive
subtree, not the whole page. `GetBuilder` for non-reactive manual `update()` cases.

Because go_router owns navigation, `Bindings` aren't auto-invoked by routes. Either:
- call `AuthBinding().dependencies()` in the route's `builder`, or
- use `GetBuilder(init: AuthController(sl()), builder: ...)` at page level.
Document whichever you pick and stay consistent.

**Pros:** least boilerplate, fastest to write, tiny reactive syntax.
**Cons:** global service locator hides dependencies, easy to abuse, `Obx` scope mistakes
cause silent over-rebuilding, weak testing story, community concerns about maintenance —
all fair points to record honestly in the comparison.

---

## 5. What Must Stay Identical

| Area | Identical? |
|---|---|
| `core/themes`, `core/constants`, `core/widgets`, `core/extensions` | ✅ byte-identical |
| `core/router/*` (incl. `SessionService`) | ✅ byte-identical |
| `i18n/*` | ✅ byte-identical |
| `features/*/data/*` | ✅ byte-identical |
| `core/di/injector.dart` | ✅ byte-identical |
| `features/*/presentation/screens/*` | ⚠️ same layout, different state plumbing |
| `features/*/presentation/widgets/*` | ✅ should be identical (dumb widgets) |
| `features/*/presentation/controller/*` | ❌ fully branch-specific |
| `core/di/state_injector.dart`, `main.dart`, `app.dart` | ❌ branch-specific |

A good sanity check: `git diff main..feature/riverpod --stat` should touch **only**
controllers, screens, `state_injector.dart`, `main.dart`, `app.dart`, and the branch-specific
`pubspec.yaml` dependencies. Shared data/core files should not diverge. Firebase backend configuration stays Spark-compatible and is shared across all three branches.
If it touches a non-branch-specific shared core/data file, something leaked.
