# 05 — Localization with slang (EN / AR + RTL)

**Chosen package:** [`slang`](https://pub.dev/packages/slang) (v4.19.x at time of writing).

**Why slang over the alternatives:**

| | slang | easy_localization | intl / ARB |
|---|---|---|---|
| Type-safe keys | ✅ `t.auth.login` | ❌ strings | ✅ |
| Source format | JSON / YAML / CSV | JSON | ARB (verbose) |
| Codegen speed | fast (`dart run slang`, no build_runner needed) | n/a | slow |
| Nested keys | ✅ native | ⚠️ dot strings | ❌ flat |
| Plurals / genders / context | ✅ rich | basic | ✅ |
| Missing-key detection | ✅ `slang analyze` | ❌ runtime | ✅ compile |
| Runtime locale switch | ✅ | ✅ | ⚠️ manual |

slang gives us ARB's safety with easy_localization's ergonomics. Good call.

---

## 1. Setup

```yaml
# pubspec.yaml
dependencies:
  slang: ^4.19.1
  slang_flutter: ^4.19.0
  flutter_localizations:
    sdk: flutter

dev_dependencies:
  build_runner: ^2.4.13
  slang_build_runner: ^4.19.0
```

```yaml
# build.yaml  (also read by `dart run slang`)
targets:
  $default:
    builders:
      slang_build_runner:
        options:
          base_locale: en
          fallback_strategy: base_locale
          input_directory: lib/i18n
          input_file_pattern: .i18n.json
          output_directory: lib/i18n
          output_file_name: strings.g.dart
          translate_var: t
          enum_name: AppLocale
          class_name: Translations
          key_case: camel
          string_interpolation: double_braces
          flat_map: false
          timestamp: false          # keeps git diffs clean
          statistics: true
```

> `fallback_strategy: base_locale` means a missing Arabic key silently falls back to
> English instead of crashing. Combined with `dart run slang analyze` in CI, that's
> the right trade-off.

Generate:
```bash
dart run slang                     # day-to-day
dart run build_runner build -d     # CI / fresh checkout
dart run slang analyze             # find missing + unused keys
```

`lib/i18n/strings.g.dart` **is committed** to git (so a fresh clone builds without codegen).

---

## 2. File Structure & Key Organisation

```
lib/i18n/
├── en.i18n.json     # base locale
├── ar.i18n.json
└── strings.g.dart   # generated
```

Top-level namespaces mirror the features:

```jsonc
// lib/i18n/en.i18n.json
{
  "common": {
    "appName": "Doctor Hunt",
    "ok": "OK",
    "cancel": "Cancel",
    "save": "Save",
    "retry": "Retry",
    "confirm": "Confirm",
    "loading": "Loading...",
    "noData": "Nothing here yet",
    "search": "Search"
  },
  "auth": {
    "login": "Log in",
    "register": "Create account",
    "email": "Email",
    "password": "Password",
    "confirmPassword": "Confirm password",
    "forgotPassword": "Forgot password?",
    "continueWithGoogle": "Continue with Google",
    "noAccount": "Don't have an account?",
    "haveAccount": "Already have an account?",
    "iAmA": "I am a",
    "rolePatient": "Patient",
    "roleDoctor": "Doctor",
    "rolePatientDesc": "Find doctors and book appointments",
    "roleDoctorDesc": "Manage your clinic and appointments",
    "chooseRole": "How will you use the app?",
    "welcomeBack": "Welcome back, {{name}}"
  },
  "onboarding": {
    "stepProfessional": "Professional info",
    "stepAvailability": "Working hours",
    "stepLocation": "Clinic location",
    "stepContact": "Contact details",
    "next": "Next",
    "back": "Back",
    "finish": "Finish setup",
    "stepOf": "Step {current} of {total}",
    "treats": "What do you treat?",
    "yearsExperience": "Years of experience",
    "clinicPhone": "Clinic phone number",
    "whatsapp": "WhatsApp (optional)",
    "pickOnMap": "Pick location on map",
    "useMyLocation": "Use my current location"
  },
  "doctors": {
    "title": "Find a doctor",
    "specialization": "Specialization",
    "experience": "{n} years of experience",
    "fee": "Consultation fee",
    "about": "About",
    "bookNow": "Book now",
    "noDoctors": "No doctors match your search",
    "searchHint": "Search by name or specialization",
    "nearby": "Nearby doctors",
    "mapView": "Map",
    "listView": "List",
    "distanceKm": "{km} km away",
    "callClinic": "Call clinic",
    "openInMaps": "Open in Maps",
    "treats": "Treats",
    "withinRadius": "Within {km} km",
    "recentSearches": "Recent searches"
  },
  "reviews": {
    "title": "Reviews",
    "rateVisit": "Rate your visit",
    "rateDoctor": "Rate {{name}}",
    "yourRating": "Your rating",
    "commentHint": "Share your experience (optional)",
    "submit": "Submit review",
    "noReviews": "No reviews yet",
    "seeAll": "See all reviews",
    "thanks": "Thanks for your feedback!",
    "count": {
      "zero": "No reviews",
      "one": "1 review",
      "other": "{n} reviews"
    }
  },
  "location": {
    "permissionTitle": "Enable location",
    "permissionBody": "We use your location only to show the nearest doctors.",
    "enable": "Enable location",
    "denied": "Location is off. Showing all doctors instead.",
    "openSettings": "Open settings",
    "servicesDisabled": "Turn on location services to see nearby doctors"
  },
  "appointments": {
    "title": "My appointments",
    "upcoming": "Upcoming",
    "past": "Past",
    "pickDate": "Pick a date",
    "pickSlot": "Available times",
    "noSlots": "No free slots on this day",
    "confirmBooking": "Confirm booking",
    "bookedFor": "Booked for {{date}} at {{time}}",
    "cancelBooking": "Cancel booking",
    "cancelConfirm": "Are you sure you want to cancel this appointment?",
    "count": {
      "zero": "No appointments",
      "one": "1 appointment",
      "other": "{n} appointments"
    },
    "status": {
      "pending": "Pending",
      "confirmed": "Confirmed",
      "cancelled": "Cancelled",
      "completed": "Completed"
    }
  },
  "doctor": {
    "dashboard": "Dashboard",
    "todayAppointments": "Today's appointments",
    "totalPatients": "Total patients",
    "pendingRequests": "Pending requests",
    "availability": "My availability",
    "addSlot": "Add slot",
    "workingHours": "Working hours",
    "accept": "Accept",
    "reject": "Reject"
  },
  "specializations": {
    "general": "General Practice",
    "cardiology": "Cardiology",
    "dermatology": "Dermatology",
    "orthopedics": "Orthopedics",
    "pediatrics": "Pediatrics",
    "neurology": "Neurology",
    "dentistry": "Dentistry",
    "ophthalmology": "Ophthalmology"
  },
  "settings": {
    "title": "Settings",
    "language": "Language",
    "theme": "Theme",
    "themeLight": "Light",
    "themeDark": "Dark",
    "themeSystem": "System",
    "signOut": "Sign out"
  },
  "validation": {
    "required": "This field is required",
    "invalidEmail": "Enter a valid email address",
    "shortPassword": "Password must be at least {n} characters",
    "passwordsMismatch": "Passwords do not match"
  },
  "errors": {
    "server": "Something went wrong. Please try again.",
    "network": "No internet connection",
    "cache": "Could not read local data",
    "slotTaken": "This slot was just booked by someone else",
    "locationUnavailable": "Could not determine your location",
    "alreadyReviewed": "You have already reviewed this visit",
    "callFailed": "Could not start the call",
    "auth": {
      "invalidCredential": "Wrong email or password",
      "emailAlreadyInUse": "This email is already registered",
      "weakPassword": "Password is too weak",
      "userDisabled": "This account has been disabled",
      "tooManyRequests": "Too many attempts. Try again later.",
      "unknown": "Authentication failed",
      "emailNotVerified": "Please verify your email address. Check your inbox."
    }
  }
}
```

`ar.i18n.json` mirrors the **exact same key tree**. CI fails if `slang analyze` reports
missing keys.

> Auth errors are mapped from `AuthFailure.message` to the generated `t.errors.auth.*`
> keys with an exhaustive `switch`; there is no generic message-key contract.

---

## 3. Bootstrap

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: 'YOUR_SUPABASE_URL', anonKey: 'YOUR_ANON_KEY');
  await initCore();

  final saved = await sl<LocaleStorage>().read();       // 'en' | 'ar' | null
  if (saved != null) {
    LocaleSettings.setLocaleRaw(saved);
  } else {
    LocaleSettings.useDeviceLocale();
  }

  runApp(TranslationProvider(child: const MyApp()));
}
```

```dart
// app.dart
MaterialApp.router(
  title: t.common.appName,
  locale: TranslationProvider.of(context).flutterLocale,
  supportedLocales: AppLocaleUtils.supportedLocales,
  localizationsDelegates: GlobalMaterialLocalizations.delegates,
  routerConfig: router,
  ...
);
```

Switching at runtime:
```dart
LocaleSettings.setLocale(AppLocale.ar);
await sl<LocaleStorage>().save('ar');
```
`TranslationProvider` rebuilds the subtree automatically — no restart needed.

> **Branch note:** `LocaleSettings` is global and static, so the locale controller is
> trivially the same in all three branches. Wrap it in a `LocaleController` per branch
> only to expose the current value reactively to the settings UI.

---

## 4. Usage Patterns

```dart
// resolving a Failure — preferred approach (type-safe, exhaustive)
String failureMessage(Failure f) => switch (f) {
  NetworkFailure()   => t.errors.network,
  SlotTakenFailure() => t.errors.slotTaken,
  AuthFailure(:final message) => switch (message) {
      'invalid-credential' => t.errors.auth.invalidCredential,
      'email-already-in-use' => t.errors.auth.emailAlreadyInUse,
      _ => t.errors.auth.unknown,
    },
  _ => t.errors.server,
};
```

> ⚠️ If you want dynamic `t['some.key']` string lookup, you'd need `flat_map: true`
> in `build.yaml`. **Don't do this** — the
> `switch` approach above is preferred because it keeps full type safety and the
> sealed `Failure` class makes it exhaustive.

---

## 5. RTL — Arabic Is a First-Class Citizen

Flutter flips layout automatically once `locale` is `ar`, **but only if you follow
these rules**:

1. **Never use `left` / `right`.** Use `start` / `end`:
   - `EdgeInsetsDirectional.only(start: 16.w)` not `EdgeInsets.only(left: 16.w)`
   - `AlignmentDirectional.centerStart` not `Alignment.centerLeft`
   - `BorderRadiusDirectional.horizontal(start: ...)`
   - `PositionedDirectional`
2. **Directional icons must flip.** Back arrows, chevrons, "next" arrows:
   `Icon(context.isRtl ? Icons.arrow_forward : Icons.arrow_back)` or wrap in
   `Transform.flip(flipX: context.isRtl)`. Add `context.isRtl` to `context_ext.dart`.
3. **Numbers and dates.** Use `intl`'s `NumberFormat` / `DateFormat` with the active
   locale. Decide and document: do we show Arabic-Indic numerals (٣:٣٠) or Western
   (3:30)? **Recommendation: Western numerals for times/dates** — far more readable for
   Egyptian users in a medical context.
4. **Fonts.** Cairo / IBM Plex Sans Arabic / Tajawal render Arabic properly; Roboto
   does not. Either ship one font that covers both scripts, or swap `fontFamily`
   inside `generateStyle` based on the active locale.
5. **Test both.** Every PR screenshot must show the screen in AR as well as EN.

```dart
// core/extensions/context_ext.dart
extension ContextX on BuildContext {
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;
  AppLocale get locale => TranslationProvider.of(this).locale;
}
```

---

## 6. Non-Translatable Content

Doctor names, specializations, and clinic addresses come from PostgreSQL, not slang.
For bilingual doctor data, store both in the document:

```jsonc
{ "name": { "en": "Dr. Ahmed Hassan", "ar": "د. أحمد حسن" } }
```
and resolve with a helper `localizedField(map, context.locale)`. Document this in
`06-supabase-and-data-model.md`.
