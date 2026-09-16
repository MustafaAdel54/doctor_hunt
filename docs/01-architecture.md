# 01 — Architecture

> ✅ **UPDATED** to match the product owner's folder structure: there is **no `domain/`
> layer**. This is a deliberate two-layer design.

---

## 1. Layering

```
presentation/                        data/
├── controller/   ──────────────►    ├── repo/      (abstract + impl)
├── screens/                         ├── service/   (Firebase-facing)
└── widgets/                         └── models/
```

### `data/service/`
Thin wrappers over Firebase. **Throws** exceptions, returns raw models.
Knows about `FirebaseAuth` and `FirebaseFirestore`. Nothing else does.
Spark v1 intentionally does not include `FirebaseStorage` or Cloud Functions.

```dart
class AuthService {
  AuthService(this._auth, this._db, this._google);
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final GoogleSignIn _google;

  Future<UserModel> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final doc = await _db.collection(FbC.users).doc(cred.user!.uid).get();
    return UserModel.fromJson(doc.data()!);
  }
}
```

### `data/repo/`
Abstract contract + implementation. **Catches** exceptions, returns `Either<Failure, T>`.
This is the boundary the presentation layer talks to.

```dart
// auth_repo.dart
abstract class AuthRepo {
  Future<Either<Failure, UserModel>> signIn(String email, String password);
  Future<Either<Failure, UserModel>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
  Stream<UserModel?> watchUser();
}

// auth_repo_impl.dart
class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl(this._service);
  final AuthService _service;

  @override
  Future<Either<Failure, UserModel>> signIn(String email, String password) async {
    try {
      return Right(await _service.signIn(email, password));
    } on FirebaseAuthException catch (e) {
      return Left(mapAuthException(e));
    } on SocketException {
      return const Left(NetworkFailure());
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
```

### `data/models/`
`freezed` + `json_serializable`. These are used **all the way up** to the widgets —
there are no separate domain entities. One class, one job, less ceremony.

### `presentation/controller/`
The only branch-specific folder. Calls repos, folds the `Either`, emits state.

### `presentation/screens/` + `widgets/`
Render state, dispatch callbacks. No Firebase imports, no business logic.

---

## 2. Dependency Rule

```
screens ──► controller ──► repo (abstract) ──► repo_impl ──► service ──► Firebase
```

- Screens **never** import `service/` or `cloud_firestore`.
- Controllers depend on the **abstract** `AuthRepo`, injected via `get_it`.
- `service/` never imports anything from `presentation/`.

> **Trade-off, stated honestly:** dropping `domain/` means models are shared between
> the wire format and the UI. If Firestore's shape changes, it ripples upward. For a
> portfolio project focused on state management comparison, that's an acceptable and
> defensible choice — and worth mentioning in the README as a conscious decision, not
> an oversight.

### Spark-plan boundary
Account deletion is **not** implemented as a server-side callable in v1. Firebase Cloud
Functions are unavailable on Spark, so the Flutter app must not import or depend on
`cloud_functions`. The Settings action is therefore **Deactivate account**: after
recent authentication, the client marks the profile inactive and signs the user out.
A true server-side purge/cascade can be added later on Blaze without changing the core
feature contracts.

## 3. The One Piece of Real Business Logic

Slot availability is the only genuine algorithm in the app. It must be a **pure
function** with zero Firebase dependency so it can be unit-tested identically on all
three branches.

```dart
// features/availability/data/repo/slot_calculator.dart
List<TimeSlot> calculateAvailableSlots({
  required DayAvailability availability,     // weekly ranges, possibly overridden
  required List<AppointmentModel> booked,    // pending + confirmed for that date
  required int slotDurationMinutes,
  required DateTime date,
  required DateTime now,
}) {
  // 1. expand ranges into slots of slotDurationMinutes
  // 2. drop slots that collide with `booked`
  // 3. drop slots in the past when date == today
}
```

No `async`, no `Firestore`, no `BuildContext`. Highest-value test in the codebase.

---

## 4. Error Handling

**Package: `dartz`** (`Either`, `Left`, `Right`). Import it only in `data/repo/` and
in controllers — never in widgets.

```dart
// core/error/failures.dart
sealed class Failure {
  const Failure();
}

class ServerFailure    extends Failure { const ServerFailure(); }
class NetworkFailure   extends Failure { const NetworkFailure(); }
class SlotTakenFailure extends Failure { const SlotTakenFailure(); }
class AuthFailure      extends Failure {
  const AuthFailure(this.code);
  final String code;     // raw FirebaseAuthException.code
}
```

Failures carry **no user-facing message strings** — the UI maps them to slang
translations via an exhaustive `switch` (see `05-localization-slang.md §4`). This
keeps the data layer completely localization-agnostic. Machine-readable codes
(like `AuthFailure.code`) are allowed — they're the input to the mapping function,
not the output.

---

## 5. UI State Contract

Four states everywhere: `initial`, `loading`, `success`, `error`.

| Branch | Representation |
|---|---|
| Bloc | `sealed class XState` (freezed union) |
| Riverpod | `AsyncValue<T>` |
| GetX | `Rx<RequestState>` + `Rxn<T>` + `Rxn<Failure>` |

Shared rendering widget (lives in `core/widgets/`, branch-agnostic):

```dart
class StateHandler<T> extends StatelessWidget {
  const StateHandler({
    required this.isLoading,
    required this.data,
    required this.failure,
    required this.onSuccess,
    this.onRetry,
    this.loadingWidget,
    super.key,
  });

  final bool isLoading;
  final T? data;
  final Failure? failure;
  final Widget Function(T data) onSuccess;
  final VoidCallback? onRetry;
  final Widget? loadingWidget;
}
```

Each branch adapts its own state type into these four plain parameters. That's the
adapter seam that keeps screens nearly identical across branches.

---

## 6. Dependency Injection

`get_it` on all three branches.

```dart
// core/di/injector.dart   — SHARED, byte-identical across branches
final sl = GetIt.instance;

Future<void> initCore() async {
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn());

  sl.registerLazySingleton(() => AuthService(sl(), sl(), sl()));
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()));

  sl.registerLazySingleton(() => SessionService(sl<AuthRepo>()));
}
```

```dart
// core/di/state_injector.dart — PER-BRANCH, the only DI file that differs
// bloc:     sl.registerFactory(() => AuthCubit(sl()));
// riverpod: final authRepoProvider = Provider((_) => sl<AuthRepo>());
// getx:     Get.lazyPut(() => AuthController(sl()));
```

---

## 7. Navigation Boundary

Controllers expose state; screens navigate. The one centralized exception is
`go_router`'s global `redirect`, driven by `SessionService` — see `04`.

```dart
// good
BlocListener<AuthCubit, AuthState>(
  listener: (ctx, s) {
    if (s is AuthError) AppDialogs.error(ctx, failureMessage(s.failure));
    // success needs no navigation — SessionService updates and redirect fires
  },
)
```
