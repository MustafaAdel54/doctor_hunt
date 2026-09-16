///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  );

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$common$en common = Translations$common$en.internal(_root);
	late final Translations$auth$en auth = Translations$auth$en.internal(_root);
	late final Translations$onboarding$en onboarding = Translations$onboarding$en.internal(_root);
	late final Translations$doctorOnboarding$en doctorOnboarding = Translations$doctorOnboarding$en.internal(_root);
	late final Translations$doctors$en doctors = Translations$doctors$en.internal(_root);
	late final Translations$reviews$en reviews = Translations$reviews$en.internal(_root);
	late final Translations$location$en location = Translations$location$en.internal(_root);
	late final Translations$appointments$en appointments = Translations$appointments$en.internal(_root);
	late final Translations$doctor$en doctor = Translations$doctor$en.internal(_root);
	late final Translations$specializations$en specializations = Translations$specializations$en.internal(_root);
	late final Translations$settings$en settings = Translations$settings$en.internal(_root);
	late final Translations$validation$en validation = Translations$validation$en.internal(_root);
	late final Translations$errors$en errors = Translations$errors$en.internal(_root);
}

// Path: common
class Translations$common$en {
	Translations$common$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Doctor Hunt'
	String get appName => 'Doctor Hunt';

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'Nothing here yet'
	String get noData => 'Nothing here yet';

	/// en: 'Search'
	String get search => 'Search';
}

// Path: auth
class Translations$auth$en {
	Translations$auth$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Log in'
	String get login => 'Log in';

	/// en: 'Create account'
	String get register => 'Create account';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Confirm password'
	String get confirmPassword => 'Confirm password';

	/// en: 'Forgot password?'
	String get forgotPassword => 'Forgot password?';

	/// en: 'Continue with Google'
	String get continueWithGoogle => 'Continue with Google';

	/// en: 'Don't have an account?'
	String get noAccount => 'Don\'t have an account?';

	/// en: 'Already have an account?'
	String get haveAccount => 'Already have an account?';

	/// en: 'I am a'
	String get iAmA => 'I am a';

	/// en: 'Patient'
	String get rolePatient => 'Patient';

	/// en: 'Doctor'
	String get roleDoctor => 'Doctor';

	/// en: 'Find doctors, book appointments, and manage your medical records.'
	String get rolePatientDesc => 'Find doctors, book appointments, and manage your medical records.';

	/// en: 'Manage your clinic and appointments'
	String get roleDoctorDesc => 'Manage your clinic and appointments';

	/// en: 'Choose your role'
	String get chooseRole => 'Choose your role';

	/// en: 'The selected role determines the experience and available features.'
	String get roleSubtitle => 'The selected role determines the experience and available features.';

	/// en: 'Welcome back, {{name}}'
	String welcomeBack({required Object name}) => 'Welcome back, ${name}';

	/// en: 'Welcome back'
	String get welcomeBackTitle => 'Welcome back';

	/// en: 'You can search course, apply course and find scholarship for abroad studies'
	String get loginSubtitle => 'You can search course, apply course and find scholarship for abroad studies';

	/// en: 'Join us to start searching'
	String get joinUsTitle => 'Join us to start searching';

	/// en: 'I agree with the Terms of Service & Privacy Policy'
	String get agreeTerms => 'I agree with the Terms of Service & Privacy Policy';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Google'
	String get google => 'Google';

	/// en: 'Facebook'
	String get facebook => 'Facebook';
}

// Path: onboarding
class Translations$onboarding$en {
	Translations$onboarding$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Find Trusted Doctors'
	String get page1Title => 'Find Trusted Doctors';

	/// en: 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.'
	String get page1Subtitle => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.';

	/// en: 'Choose Best Doctors'
	String get page2Title => 'Choose Best Doctors';

	/// en: 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.'
	String get page2Subtitle => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.';

	/// en: 'Easy Appointments'
	String get page3Title => 'Easy Appointments';

	/// en: 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.'
	String get page3Subtitle => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.';

	/// en: 'Skip'
	String get skip => 'Skip';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Get Started'
	String get getStarted => 'Get Started';
}

// Path: doctorOnboarding
class Translations$doctorOnboarding$en {
	Translations$doctorOnboarding$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Professional info'
	String get stepProfessional => 'Professional info';

	/// en: 'Working hours'
	String get stepAvailability => 'Working hours';

	/// en: 'Clinic location'
	String get stepLocation => 'Clinic location';

	/// en: 'Contact details'
	String get stepContact => 'Contact details';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Finish setup'
	String get finish => 'Finish setup';

	/// en: 'Step {{current}} of {{total}}'
	String stepOf({required Object current, required Object total}) => 'Step ${current} of ${total}';

	/// en: 'What do you treat?'
	String get treats => 'What do you treat?';

	/// en: 'Years of experience'
	String get yearsExperience => 'Years of experience';

	/// en: 'Clinic phone number'
	String get clinicPhone => 'Clinic phone number';

	/// en: 'WhatsApp (optional)'
	String get whatsapp => 'WhatsApp (optional)';

	/// en: 'Pick location on map'
	String get pickOnMap => 'Pick location on map';

	/// en: 'Use my current location'
	String get useMyLocation => 'Use my current location';
}

// Path: doctors
class Translations$doctors$en {
	Translations$doctors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Find a doctor'
	String get title => 'Find a doctor';

	/// en: 'Specialization'
	String get specialization => 'Specialization';

	/// en: '{{n}} years of experience'
	String experience({required Object n}) => '${n} years of experience';

	/// en: 'Consultation fee'
	String get fee => 'Consultation fee';

	/// en: 'About'
	String get about => 'About';

	/// en: 'Book now'
	String get bookNow => 'Book now';

	/// en: 'No doctors match your search'
	String get noDoctors => 'No doctors match your search';

	/// en: 'Search by name or specialization'
	String get searchHint => 'Search by name or specialization';

	/// en: 'Nearby doctors'
	String get nearby => 'Nearby doctors';

	/// en: 'Map'
	String get mapView => 'Map';

	/// en: 'List'
	String get listView => 'List';

	/// en: '{{km}} km away'
	String distanceKm({required Object km}) => '${km} km away';

	/// en: 'Call clinic'
	String get callClinic => 'Call clinic';

	/// en: 'Open in Maps'
	String get openInMaps => 'Open in Maps';

	/// en: 'Treats'
	String get treats => 'Treats';

	/// en: 'Within {{km}} km'
	String withinRadius({required Object km}) => 'Within ${km} km';

	/// en: 'Recent searches'
	String get recentSearches => 'Recent searches';
}

// Path: reviews
class Translations$reviews$en {
	Translations$reviews$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Reviews'
	String get title => 'Reviews';

	/// en: 'Rate your visit'
	String get rateVisit => 'Rate your visit';

	/// en: 'Rate {{name}}'
	String rateDoctor({required Object name}) => 'Rate ${name}';

	/// en: 'Your rating'
	String get yourRating => 'Your rating';

	/// en: 'Share your experience (optional)'
	String get commentHint => 'Share your experience (optional)';

	/// en: 'Submit review'
	String get submit => 'Submit review';

	/// en: 'No reviews yet'
	String get noReviews => 'No reviews yet';

	/// en: 'See all reviews'
	String get seeAll => 'See all reviews';

	/// en: 'Thanks for your feedback!'
	String get thanks => 'Thanks for your feedback!';

	/// en: '(zero) {No reviews} (one) {1 review} (other) {{{n}} reviews}'
	String count({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		zero: 'No reviews',
		one: '1 review',
		other: '${n} reviews',
	);
}

// Path: location
class Translations$location$en {
	Translations$location$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Enable location'
	String get permissionTitle => 'Enable location';

	/// en: 'We use your location only to show the nearest doctors.'
	String get permissionBody => 'We use your location only to show the nearest doctors.';

	/// en: 'Enable location'
	String get enable => 'Enable location';

	/// en: 'Location is off. Showing all doctors instead.'
	String get denied => 'Location is off. Showing all doctors instead.';

	/// en: 'Open settings'
	String get openSettings => 'Open settings';

	/// en: 'Turn on location services to see nearby doctors'
	String get servicesDisabled => 'Turn on location services to see nearby doctors';
}

// Path: appointments
class Translations$appointments$en {
	Translations$appointments$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'My appointments'
	String get title => 'My appointments';

	/// en: 'Upcoming'
	String get upcoming => 'Upcoming';

	/// en: 'Past'
	String get past => 'Past';

	/// en: 'Pick a date'
	String get pickDate => 'Pick a date';

	/// en: 'Available times'
	String get pickSlot => 'Available times';

	/// en: 'No free slots on this day'
	String get noSlots => 'No free slots on this day';

	/// en: 'Confirm booking'
	String get confirmBooking => 'Confirm booking';

	/// en: 'Booked for {{date}} at {{time}}'
	String bookedFor({required Object date, required Object time}) => 'Booked for ${date} at ${time}';

	/// en: 'Cancel booking'
	String get cancelBooking => 'Cancel booking';

	/// en: 'Are you sure you want to cancel this appointment?'
	String get cancelConfirm => 'Are you sure you want to cancel this appointment?';

	/// en: '(zero) {No appointments} (one) {1 appointment} (other) {{{n}} appointments}'
	String count({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		zero: 'No appointments',
		one: '1 appointment',
		other: '${n} appointments',
	);

	late final Translations$appointments$status$en status = Translations$appointments$status$en.internal(_root);
}

// Path: doctor
class Translations$doctor$en {
	Translations$doctor$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Dashboard'
	String get dashboard => 'Dashboard';

	/// en: 'Today's appointments'
	String get todayAppointments => 'Today\'s appointments';

	/// en: 'Total patients'
	String get totalPatients => 'Total patients';

	/// en: 'Pending requests'
	String get pendingRequests => 'Pending requests';

	/// en: 'My availability'
	String get availability => 'My availability';

	/// en: 'Add slot'
	String get addSlot => 'Add slot';

	/// en: 'Working hours'
	String get workingHours => 'Working hours';

	/// en: 'Accept'
	String get accept => 'Accept';

	/// en: 'Reject'
	String get reject => 'Reject';
}

// Path: specializations
class Translations$specializations$en {
	Translations$specializations$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'General Practice'
	String get general => 'General Practice';

	/// en: 'Cardiology'
	String get cardiology => 'Cardiology';

	/// en: 'Dermatology'
	String get dermatology => 'Dermatology';

	/// en: 'Orthopedics'
	String get orthopedics => 'Orthopedics';

	/// en: 'Pediatrics'
	String get pediatrics => 'Pediatrics';

	/// en: 'Neurology'
	String get neurology => 'Neurology';

	/// en: 'Dentistry'
	String get dentistry => 'Dentistry';

	/// en: 'Ophthalmology'
	String get ophthalmology => 'Ophthalmology';
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'Light'
	String get themeLight => 'Light';

	/// en: 'Dark'
	String get themeDark => 'Dark';

	/// en: 'System'
	String get themeSystem => 'System';

	/// en: 'Sign out'
	String get signOut => 'Sign out';
}

// Path: validation
class Translations$validation$en {
	Translations$validation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'This field is required'
	String get required => 'This field is required';

	/// en: 'Enter a valid email address'
	String get invalidEmail => 'Enter a valid email address';

	/// en: 'Password must be at least {{n}} characters'
	String shortPassword({required Object n}) => 'Password must be at least ${n} characters';

	/// en: 'Passwords do not match'
	String get passwordsMismatch => 'Passwords do not match';
}

// Path: errors
class Translations$errors$en {
	Translations$errors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Something went wrong. Please try again.'
	String get server => 'Something went wrong. Please try again.';

	/// en: 'No internet connection'
	String get network => 'No internet connection';

	/// en: 'Could not read local data'
	String get cache => 'Could not read local data';

	/// en: 'This slot was just booked by someone else'
	String get slotTaken => 'This slot was just booked by someone else';

	/// en: 'Could not determine your location'
	String get locationUnavailable => 'Could not determine your location';

	/// en: 'You have already reviewed this visit'
	String get alreadyReviewed => 'You have already reviewed this visit';

	/// en: 'Could not start the call'
	String get callFailed => 'Could not start the call';

	late final Translations$errors$auth$en auth = Translations$errors$auth$en.internal(_root);
}

// Path: appointments.status
class Translations$appointments$status$en {
	Translations$appointments$status$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Pending'
	String get pending => 'Pending';

	/// en: 'Confirmed'
	String get confirmed => 'Confirmed';

	/// en: 'Cancelled'
	String get cancelled => 'Cancelled';

	/// en: 'Completed'
	String get completed => 'Completed';
}

// Path: errors.auth
class Translations$errors$auth$en {
	Translations$errors$auth$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Wrong email or password'
	String get invalidCredential => 'Wrong email or password';

	/// en: 'This email is already registered'
	String get emailAlreadyInUse => 'This email is already registered';

	/// en: 'Password is too weak'
	String get weakPassword => 'Password is too weak';

	/// en: 'This account has been disabled'
	String get userDisabled => 'This account has been disabled';

	/// en: 'Too many attempts. Try again later.'
	String get tooManyRequests => 'Too many attempts. Try again later.';

	/// en: 'Authentication failed'
	String get unknown => 'Authentication failed';

	/// en: 'Please verify your email address. Check your inbox.'
	String get emailNotVerified => 'Please verify your email address. Check your inbox.';
}
