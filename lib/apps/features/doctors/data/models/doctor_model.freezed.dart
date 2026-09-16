// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doctor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) {
  return _DoctorModel.fromJson(json);
}

/// @nodoc
mixin _$DoctorModel {
  String get uid => throw _privateConstructorUsedError;
  Map<String, String> get name => throw _privateConstructorUsedError;
  String get specialization => throw _privateConstructorUsedError;
  Map<String, String> get bio => throw _privateConstructorUsedError;
  Map<String, String> get address => throw _privateConstructorUsedError;
  int get fee => throw _privateConstructorUsedError;
  double get ratingSum => throw _privateConstructorUsedError;
  int get ratingCount => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get clinicPhone => throw _privateConstructorUsedError;
  List<String> get treats => throw _privateConstructorUsedError;
  int get yearsExperience => throw _privateConstructorUsedError;

  /// Serializes this DoctorModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DoctorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DoctorModelCopyWith<DoctorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DoctorModelCopyWith<$Res> {
  factory $DoctorModelCopyWith(
    DoctorModel value,
    $Res Function(DoctorModel) then,
  ) = _$DoctorModelCopyWithImpl<$Res, DoctorModel>;
  @useResult
  $Res call({
    String uid,
    Map<String, String> name,
    String specialization,
    Map<String, String> bio,
    Map<String, String> address,
    int fee,
    double ratingSum,
    int ratingCount,
    String? photoUrl,
    String? clinicPhone,
    List<String> treats,
    int yearsExperience,
  });
}

/// @nodoc
class _$DoctorModelCopyWithImpl<$Res, $Val extends DoctorModel>
    implements $DoctorModelCopyWith<$Res> {
  _$DoctorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DoctorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? specialization = null,
    Object? bio = null,
    Object? address = null,
    Object? fee = null,
    Object? ratingSum = null,
    Object? ratingCount = null,
    Object? photoUrl = freezed,
    Object? clinicPhone = freezed,
    Object? treats = null,
    Object? yearsExperience = null,
  }) {
    return _then(
      _value.copyWith(
            uid: null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            specialization: null == specialization
                ? _value.specialization
                : specialization // ignore: cast_nullable_to_non_nullable
                      as String,
            bio: null == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            fee: null == fee
                ? _value.fee
                : fee // ignore: cast_nullable_to_non_nullable
                      as int,
            ratingSum: null == ratingSum
                ? _value.ratingSum
                : ratingSum // ignore: cast_nullable_to_non_nullable
                      as double,
            ratingCount: null == ratingCount
                ? _value.ratingCount
                : ratingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            clinicPhone: freezed == clinicPhone
                ? _value.clinicPhone
                : clinicPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            treats: null == treats
                ? _value.treats
                : treats // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            yearsExperience: null == yearsExperience
                ? _value.yearsExperience
                : yearsExperience // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DoctorModelImplCopyWith<$Res>
    implements $DoctorModelCopyWith<$Res> {
  factory _$$DoctorModelImplCopyWith(
    _$DoctorModelImpl value,
    $Res Function(_$DoctorModelImpl) then,
  ) = __$$DoctorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String uid,
    Map<String, String> name,
    String specialization,
    Map<String, String> bio,
    Map<String, String> address,
    int fee,
    double ratingSum,
    int ratingCount,
    String? photoUrl,
    String? clinicPhone,
    List<String> treats,
    int yearsExperience,
  });
}

/// @nodoc
class __$$DoctorModelImplCopyWithImpl<$Res>
    extends _$DoctorModelCopyWithImpl<$Res, _$DoctorModelImpl>
    implements _$$DoctorModelImplCopyWith<$Res> {
  __$$DoctorModelImplCopyWithImpl(
    _$DoctorModelImpl _value,
    $Res Function(_$DoctorModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DoctorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? specialization = null,
    Object? bio = null,
    Object? address = null,
    Object? fee = null,
    Object? ratingSum = null,
    Object? ratingCount = null,
    Object? photoUrl = freezed,
    Object? clinicPhone = freezed,
    Object? treats = null,
    Object? yearsExperience = null,
  }) {
    return _then(
      _$DoctorModelImpl(
        uid: null == uid
            ? _value.uid
            : uid // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value._name
            : name // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        specialization: null == specialization
            ? _value.specialization
            : specialization // ignore: cast_nullable_to_non_nullable
                  as String,
        bio: null == bio
            ? _value._bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        address: null == address
            ? _value._address
            : address // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        fee: null == fee
            ? _value.fee
            : fee // ignore: cast_nullable_to_non_nullable
                  as int,
        ratingSum: null == ratingSum
            ? _value.ratingSum
            : ratingSum // ignore: cast_nullable_to_non_nullable
                  as double,
        ratingCount: null == ratingCount
            ? _value.ratingCount
            : ratingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        clinicPhone: freezed == clinicPhone
            ? _value.clinicPhone
            : clinicPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        treats: null == treats
            ? _value._treats
            : treats // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        yearsExperience: null == yearsExperience
            ? _value.yearsExperience
            : yearsExperience // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DoctorModelImpl implements _DoctorModel {
  const _$DoctorModelImpl({
    required this.uid,
    required final Map<String, String> name,
    required this.specialization,
    required final Map<String, String> bio,
    required final Map<String, String> address,
    required this.fee,
    this.ratingSum = 0.0,
    this.ratingCount = 0,
    this.photoUrl,
    this.clinicPhone,
    final List<String> treats = const [],
    this.yearsExperience = 0,
  }) : _name = name,
       _bio = bio,
       _address = address,
       _treats = treats;

  factory _$DoctorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DoctorModelImplFromJson(json);

  @override
  final String uid;
  final Map<String, String> _name;
  @override
  Map<String, String> get name {
    if (_name is EqualUnmodifiableMapView) return _name;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_name);
  }

  @override
  final String specialization;
  final Map<String, String> _bio;
  @override
  Map<String, String> get bio {
    if (_bio is EqualUnmodifiableMapView) return _bio;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_bio);
  }

  final Map<String, String> _address;
  @override
  Map<String, String> get address {
    if (_address is EqualUnmodifiableMapView) return _address;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_address);
  }

  @override
  final int fee;
  @override
  @JsonKey()
  final double ratingSum;
  @override
  @JsonKey()
  final int ratingCount;
  @override
  final String? photoUrl;
  @override
  final String? clinicPhone;
  final List<String> _treats;
  @override
  @JsonKey()
  List<String> get treats {
    if (_treats is EqualUnmodifiableListView) return _treats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_treats);
  }

  @override
  @JsonKey()
  final int yearsExperience;

  @override
  String toString() {
    return 'DoctorModel(uid: $uid, name: $name, specialization: $specialization, bio: $bio, address: $address, fee: $fee, ratingSum: $ratingSum, ratingCount: $ratingCount, photoUrl: $photoUrl, clinicPhone: $clinicPhone, treats: $treats, yearsExperience: $yearsExperience)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoctorModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            const DeepCollectionEquality().equals(other._name, _name) &&
            (identical(other.specialization, specialization) ||
                other.specialization == specialization) &&
            const DeepCollectionEquality().equals(other._bio, _bio) &&
            const DeepCollectionEquality().equals(other._address, _address) &&
            (identical(other.fee, fee) || other.fee == fee) &&
            (identical(other.ratingSum, ratingSum) ||
                other.ratingSum == ratingSum) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.clinicPhone, clinicPhone) ||
                other.clinicPhone == clinicPhone) &&
            const DeepCollectionEquality().equals(other._treats, _treats) &&
            (identical(other.yearsExperience, yearsExperience) ||
                other.yearsExperience == yearsExperience));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    uid,
    const DeepCollectionEquality().hash(_name),
    specialization,
    const DeepCollectionEquality().hash(_bio),
    const DeepCollectionEquality().hash(_address),
    fee,
    ratingSum,
    ratingCount,
    photoUrl,
    clinicPhone,
    const DeepCollectionEquality().hash(_treats),
    yearsExperience,
  );

  /// Create a copy of DoctorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DoctorModelImplCopyWith<_$DoctorModelImpl> get copyWith =>
      __$$DoctorModelImplCopyWithImpl<_$DoctorModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DoctorModelImplToJson(this);
  }
}

abstract class _DoctorModel implements DoctorModel {
  const factory _DoctorModel({
    required final String uid,
    required final Map<String, String> name,
    required final String specialization,
    required final Map<String, String> bio,
    required final Map<String, String> address,
    required final int fee,
    final double ratingSum,
    final int ratingCount,
    final String? photoUrl,
    final String? clinicPhone,
    final List<String> treats,
    final int yearsExperience,
  }) = _$DoctorModelImpl;

  factory _DoctorModel.fromJson(Map<String, dynamic> json) =
      _$DoctorModelImpl.fromJson;

  @override
  String get uid;
  @override
  Map<String, String> get name;
  @override
  String get specialization;
  @override
  Map<String, String> get bio;
  @override
  Map<String, String> get address;
  @override
  int get fee;
  @override
  double get ratingSum;
  @override
  int get ratingCount;
  @override
  String? get photoUrl;
  @override
  String? get clinicPhone;
  @override
  List<String> get treats;
  @override
  int get yearsExperience;

  /// Create a copy of DoctorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DoctorModelImplCopyWith<_$DoctorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
