///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsAr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsAr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ar,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <ar>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	late final TranslationsAr _root = this; // ignore: unused_field

	@override 
	TranslationsAr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsAr(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$common$ar common = _Translations$common$ar._(_root);
	@override late final _Translations$home$ar home = _Translations$home$ar._(_root);
	@override late final _Translations$nav$ar nav = _Translations$nav$ar._(_root);
	@override late final _Translations$auth$ar auth = _Translations$auth$ar._(_root);
	@override late final _Translations$onboarding$ar onboarding = _Translations$onboarding$ar._(_root);
	@override late final _Translations$doctorOnboarding$ar doctorOnboarding = _Translations$doctorOnboarding$ar._(_root);
	@override late final _Translations$doctors$ar doctors = _Translations$doctors$ar._(_root);
	@override late final _Translations$reviews$ar reviews = _Translations$reviews$ar._(_root);
	@override late final _Translations$location$ar location = _Translations$location$ar._(_root);
	@override late final _Translations$appointments$ar appointments = _Translations$appointments$ar._(_root);
	@override late final _Translations$doctor$ar doctor = _Translations$doctor$ar._(_root);
	@override late final _Translations$specializations$ar specializations = _Translations$specializations$ar._(_root);
	@override late final _Translations$settings$ar settings = _Translations$settings$ar._(_root);
	@override late final _Translations$validation$ar validation = _Translations$validation$ar._(_root);
	@override late final _Translations$errors$ar errors = _Translations$errors$ar._(_root);
}

// Path: common
class _Translations$common$ar extends Translations$common$en {
	_Translations$common$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get appName => 'دكتور هانت';
	@override String get ok => 'حسناً';
	@override String get cancel => 'إلغاء';
	@override String get save => 'حفظ';
	@override String get retry => 'إعادة المحاولة';
	@override String get confirm => 'تأكيد';
	@override String get loading => 'جاري التحميل...';
	@override String get noData => 'لا يوجد شيء هنا بعد';
	@override String get search => 'بحث';
}

// Path: home
class _Translations$home$ar extends Translations$home$en {
	_Translations$home$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String greeting({required Object name}) => 'أهلاً ${name}!';
	@override String get defaultUser => 'مستخدم';
	@override String get liveDoctors => 'أطباء متاحون الآن';
	@override String get popularDoctors => 'أطباء مشهورون';
	@override String get featuredDoctors => 'أطباء مميزون';
	@override String get seeAll => 'عرض الكل';
	@override String get live => 'مباشر';
}

// Path: nav
class _Translations$nav$ar extends Translations$nav$en {
	_Translations$nav$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get home => 'الرئيسية';
	@override String get profile => 'الملف الشخصي';
	@override String get requests => 'الطلبات';
}

// Path: auth
class _Translations$auth$ar extends Translations$auth$en {
	_Translations$auth$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get login => 'تسجيل الدخول';
	@override String get register => 'إنشاء حساب';
	@override String get email => 'البريد الإلكتروني';
	@override String get password => 'كلمة المرور';
	@override String get confirmPassword => 'تأكيد كلمة المرور';
	@override String get forgotPassword => 'هل نسيت كلمة المرور؟';
	@override String get continueWithGoogle => 'المتابعة باستخدام جوجل';
	@override String get noAccount => 'ليس لديك حساب؟';
	@override String get haveAccount => 'لديك حساب بالفعل؟';
	@override String get iAmA => 'أنا';
	@override String get rolePatient => 'مريض';
	@override String get roleDoctor => 'طبيب';
	@override String get rolePatientDesc => 'ابحث عن الأطباء واحجز المواعيد';
	@override String get roleDoctorDesc => 'إدارة عيادتك ومواعيدك';
	@override String get chooseRole => 'كيف ستستخدم التطبيق؟';
	@override String get roleSubtitle => 'يحدد الدور المختار تجربتك والميزات المتاحة لك.';
	@override String welcomeBack({required Object name}) => 'مرحباً بك، ${name}';
	@override String get welcomeBackTitle => 'مرحباً بعودتك';
	@override String get loginSubtitle => 'يمكنك البحث عن الأطباء وحجز المواعيد بكل سهولة';
	@override String get joinUsTitle => 'انضم إلينا لتبدأ البحث';
	@override String get joinUs => 'انضم إلينا';
	@override String get termsRequired => 'يجب عليك الموافقة على شروط الخدمة';
	@override String get forgotPasswordTitle => 'نسيت كلمة المرور';
	@override String get forgotPasswordSubtitle => 'أدخل بريدك الإلكتروني لعملية التحقق، سنرسل رمز التحقق إلى بريدك الإلكتروني.';
	@override String get enterCodeTitle => 'أدخل رمز التحقق';
	@override String get enterCodeSubtitle => 'أدخل الرمز المكون من 6 أرقام الذي استلمته على بريدك الإلكتروني.';
	@override String get resetPasswordTitle => 'تعيين كلمة المرور';
	@override String get resetPasswordSubtitle => 'قم بتعيين كلمة المرور الجديدة لحسابك لتتمكن من تسجيل الدخول والوصول إلى جميع الميزات.';
	@override String get newPassword => 'كلمة المرور الجديدة';
	@override String get reenterPassword => 'إعادة إدخال كلمة المرور';
	@override String get updatePassword => 'تحديث كلمة المرور';
	@override String get continueText => 'متابعة';
	@override String get resendCode => 'إعادة إرسال الرمز';
	@override String resendCodeIn({required Object time}) => 'إعادة إرسال الرمز خلال ${time}';
	@override String get passwordResetSuccess => 'تم تحديث كلمة المرور بنجاح! يرجى تسجيل الدخول.';
}

// Path: onboarding
class _Translations$onboarding$ar extends Translations$onboarding$en {
	_Translations$onboarding$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get page1Title => 'ابحث عن أطباء موثوقين';
	@override String get page1Subtitle => 'خلافاً للاعتقاد السائد، لوريم إيبسوم ليس نصاً عشوائياً. بل له جذور في قطعة منه تعود لأكثر من 2000 عام.';
	@override String get page2Title => 'احصل على استشارة الخبراء';
	@override String get page2Subtitle => 'خلافاً للاعتقاد السائد، لوريم إيبسوم ليس نصاً عشوائياً. بل له جذور في قطعة منه تعود لأكثر من 2000 عام.';
	@override String get page3Title => 'احجز المواعيد';
	@override String get page3Subtitle => 'خلافاً للاعتقاد السائد، لوريم إيبسوم ليس نصاً عشوائياً. بل له جذور في قطعة منه تعود لأكثر من 2000 عام.';
	@override String get skip => 'تخطي';
	@override String get next => 'التالي';
	@override String get getStarted => 'ابدأ الآن';
}

// Path: doctorOnboarding
class _Translations$doctorOnboarding$ar extends Translations$doctorOnboarding$en {
	_Translations$doctorOnboarding$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get stepProfessional => 'المعلومات المهنية';
	@override String get stepAvailability => 'ساعات العمل';
	@override String get stepLocation => 'موقع العيادة';
	@override String get stepContact => 'تفاصيل الاتصال';
	@override String get next => 'التالي';
	@override String get back => 'رجوع';
	@override String get finish => 'إنهاء الإعداد';
	@override String stepOf({required Object current, required Object total}) => 'الخطوة ${current} من ${total}';
	@override String get treats => 'بماذا تعالج؟';
	@override String get yearsExperience => 'سنوات الخبرة';
	@override String get clinicPhone => 'رقم هاتف العيادة';
	@override String get whatsapp => 'واتساب (اختياري)';
	@override String get pickOnMap => 'اختر الموقع على الخريطة';
	@override String get useMyLocation => 'استخدام موقعي الحالي';
}

// Path: doctors
class _Translations$doctors$ar extends Translations$doctors$en {
	_Translations$doctors$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'ابحث عن طبيب';
	@override String get specialization => 'التخصص';
	@override String experience({required Object n}) => '${n} سنوات من الخبرة';
	@override String get fee => 'رسوم الاستشارة';
	@override String get about => 'حول';
	@override String get bookNow => 'احجز الآن';
	@override String get noDoctors => 'لا يوجد أطباء يطابقون بحثك';
	@override String get searchHint => 'ابحث بالاسم أو التخصص';
	@override String get nearby => 'الأطباء القريبون';
	@override String get mapView => 'خريطة';
	@override String get listView => 'قائمة';
	@override String distanceKm({required Object km}) => 'على بعد ${km} كم';
	@override String get callClinic => 'اتصل بالعيادة';
	@override String get openInMaps => 'فتح في الخرائط';
	@override String get treats => 'يعالج';
	@override String withinRadius({required Object km}) => 'ضمن ${km} كم';
	@override String get recentSearches => 'عمليات البحث الأخيرة';
	@override String get detailsTitle => 'تفاصيل الطبيب';
	@override String get statRunning => 'قيد التشغيل';
	@override String get statOngoing => 'مستمر';
	@override String get statPatients => 'المرضى';
	@override String get services => 'الخدمات';
	@override String perHour({required Object price}) => '${price} \$/ساعة';
	@override String viewsCount({required Object count}) => '(${count} مشاهدة)';
	@override String get favouriteDoctors => 'الأطباء المفضلون';
	@override String get noFavourites => 'لا يوجد أطباء مفضلون بعد';
	@override String get noFavouritesDesc => 'اضغط على أيقونة القلب على أي طبيب لإضافته إلى المفضلة.';
	@override String get searchFavouritesHint => 'ابحث عن طبيب أو تخصص';
	@override String get addedToFavourites => 'تمت الإضافة إلى المفضلة';
	@override String get removedFromFavourites => 'تمت الإزالة من المفضلة';
}

// Path: reviews
class _Translations$reviews$ar extends Translations$reviews$en {
	_Translations$reviews$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'التقييمات';
	@override String get rateVisit => 'قيم زيارتك';
	@override String rateDoctor({required Object name}) => 'تقييم ${name}';
	@override String get yourRating => 'تقييمك';
	@override String get commentHint => 'شارك تجربتك (اختياري)';
	@override String get submit => 'إرسال التقييم';
	@override String get noReviews => 'لا توجد تقييمات بعد';
	@override String get seeAll => 'عرض كل التقييمات';
	@override String get thanks => 'شكراً لملاحظاتك!';
	@override String count({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n,
		zero: 'لا توجد تقييمات',
		one: 'تقييم واحد',
		other: '${n} تقييمات',
	);
}

// Path: location
class _Translations$location$ar extends Translations$location$en {
	_Translations$location$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get permissionTitle => 'تمكين الموقع';
	@override String get permissionBody => 'نستخدم موقعك فقط لإظهار أقرب الأطباء.';
	@override String get enable => 'تمكين الموقع';
	@override String get denied => 'الموقع متوقف. عرض جميع الأطباء بدلاً من ذلك.';
	@override String get openSettings => 'فتح الإعدادات';
	@override String get servicesDisabled => 'قم بتشغيل خدمات الموقع لرؤية الأطباء القريبين';
}

// Path: appointments
class _Translations$appointments$ar extends Translations$appointments$en {
	_Translations$appointments$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'مواعيدي';
	@override String get upcoming => 'القادمة';
	@override String get past => 'السابقة';
	@override String get pickDate => 'اختر تاريخاً';
	@override String get pickSlot => 'الأوقات المتاحة';
	@override String get noSlots => 'لا توجد أوقات متاحة في هذا اليوم';
	@override String get confirmBooking => 'تأكيد الحجز';
	@override String bookedFor({required Object date, required Object time}) => 'تم الحجز لـ ${date} الساعة ${time}';
	@override String get cancelBooking => 'إلغاء الحجز';
	@override String get cancelConfirm => 'هل أنت متأكد أنك تريد إلغاء هذا الموعد؟';
	@override String get selectTime => 'اختر الوقت';
	@override String get noSlotsAvailable => 'لا توجد مواعيد متاحة';
	@override String slotsAvailable({required Object count}) => '${count} مواعيد متاحة';
	@override String afternoonSlots({required Object count}) => 'فترة الظهيرة (${count} مواعيد)';
	@override String eveningSlots({required Object count}) => 'فترة المساء (${count} مواعيد)';
	@override String get confirm => 'تأكيد';
	@override String get thankYou => 'شكراً لك !';
	@override String get appointmentSuccessful => 'تم حجز موعدك بنجاح';
	@override String bookingSuccessDesc({required Object doctor, required Object date, required Object time}) => 'لقد قمت بحجز موعد مع ${doctor} في تاريخ ${date}، الساعة ${time}';
	@override String get done => 'تم';
	@override String get today => 'اليوم';
	@override String get tomorrow => 'غداً';
	@override String count({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n,
		zero: 'لا توجد مواعيد',
		one: 'موعد واحد',
		other: '${n} مواعيد',
	);
	@override late final _Translations$appointments$status$ar status = _Translations$appointments$status$ar._(_root);
}

// Path: doctor
class _Translations$doctor$ar extends Translations$doctor$en {
	_Translations$doctor$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get dashboard => 'لوحة القيادة';
	@override String get todayAppointments => 'مواعيد اليوم';
	@override String get totalPatients => 'إجمالي المرضى';
	@override String get pendingRequests => 'الطلبات المعلقة';
	@override String get availability => 'أوقات العمل';
	@override String get addSlot => 'إضافة وقت';
	@override String get workingHours => 'ساعات العمل';
	@override String get accept => 'قبول';
	@override String get reject => 'رفض';
}

// Path: specializations
class _Translations$specializations$ar extends Translations$specializations$en {
	_Translations$specializations$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get general => 'طب عام';
	@override String get cardiology => 'طب القلب';
	@override String get dermatology => 'طب الأمراض الجلدية';
	@override String get orthopedics => 'طب العظام';
	@override String get pediatrics => 'طب الأطفال';
	@override String get neurology => 'طب الأعصاب';
	@override String get dentistry => 'طب الأسنان';
	@override String get ophthalmology => 'طب العيون';
}

// Path: settings
class _Translations$settings$ar extends Translations$settings$en {
	_Translations$settings$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الإعدادات';
	@override String get language => 'اللغة';
	@override String get theme => 'المظهر';
	@override String get themeLight => 'فاتح';
	@override String get themeDark => 'داكن';
	@override String get themeSystem => 'النظام';
	@override String get signOut => 'تسجيل الخروج';
}

// Path: validation
class _Translations$validation$ar extends Translations$validation$en {
	_Translations$validation$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get required => 'هذا الحقل مطلوب';
	@override String get invalidEmail => 'أدخل عنوان بريد إلكتروني صالح';
	@override String shortPassword({required Object n}) => 'يجب أن تتكون كلمة المرور من ${n} أحرف على الأقل';
	@override String get passwordsMismatch => 'كلمات المرور غير متطابقة';
}

// Path: errors
class _Translations$errors$ar extends Translations$errors$en {
	_Translations$errors$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get server => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';
	@override String get network => 'لا يوجد اتصال بالإنترنت';
	@override String get cache => 'لا يمكن قراءة البيانات المحلية';
	@override String get slotTaken => 'تم حجز هذا الوقت للتو من قبل شخص آخر';
	@override String get locationUnavailable => 'لا يمكن تحديد موقعك';
	@override String get alreadyReviewed => 'لقد قمت بتقييم هذه الزيارة بالفعل';
	@override String get callFailed => 'تعذر بدء المكالمة';
	@override String get loadDoctor => 'خطأ في تحميل تفاصيل الطبيب';
	@override String get accountAlreadySetup => 'هذا الحساب تم إعداده مسبقاً';
	@override late final _Translations$errors$auth$ar auth = _Translations$errors$auth$ar._(_root);
}

// Path: appointments.status
class _Translations$appointments$status$ar extends Translations$appointments$status$en {
	_Translations$appointments$status$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get pending => 'قيد الانتظار';
	@override String get confirmed => 'مؤكد';
	@override String get cancelled => 'ملغى';
	@override String get completed => 'مكتمل';
}

// Path: errors.auth
class _Translations$errors$auth$ar extends Translations$errors$auth$en {
	_Translations$errors$auth$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get invalidCredential => 'البريد الإلكتروني أو كلمة المرور خاطئة';
	@override String get invalidOtp => 'رمز التحقق غير صحيح. يرجى التحقق والمحاولة مرة أخرى.';
	@override String get otpExpired => 'رمز التحقق غير صحيح. يرجى التحقق والمحاولة مرة أخرى.';
	@override String get emailAlreadyInUse => 'هذا البريد الإلكتروني مسجل بالفعل';
	@override String get weakPassword => 'كلمة المرور ضعيفة جداً';
	@override String get userDisabled => 'تم تعطيل هذا الحساب';
	@override String get tooManyRequests => 'محاولات كثيرة جداً. حاول مرة أخرى لاحقاً.';
	@override String get unknown => 'فشلت المصادقة';
	@override String get emailNotVerified => 'يرجى التحقق من عنوان بريدك الإلكتروني. تفقد صندوق الوارد الخاص بك.';
}
