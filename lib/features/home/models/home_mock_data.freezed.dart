// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_mock_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HomeDoctor {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get imageAsset => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  bool get isLive => throw _privateConstructorUsedError;
  String? get specialization => throw _privateConstructorUsedError;
  String? get hourlyRate => throw _privateConstructorUsedError;

  /// Create a copy of HomeDoctor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeDoctorCopyWith<HomeDoctor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeDoctorCopyWith<$Res> {
  factory $HomeDoctorCopyWith(
    HomeDoctor value,
    $Res Function(HomeDoctor) then,
  ) = _$HomeDoctorCopyWithImpl<$Res, HomeDoctor>;
  @useResult
  $Res call({
    String id,
    String name,
    String imageAsset,
    double rating,
    bool isLive,
    String? specialization,
    String? hourlyRate,
  });
}

/// @nodoc
class _$HomeDoctorCopyWithImpl<$Res, $Val extends HomeDoctor>
    implements $HomeDoctorCopyWith<$Res> {
  _$HomeDoctorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeDoctor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageAsset = null,
    Object? rating = null,
    Object? isLive = null,
    Object? specialization = freezed,
    Object? hourlyRate = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            imageAsset: null == imageAsset
                ? _value.imageAsset
                : imageAsset // ignore: cast_nullable_to_non_nullable
                      as String,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            isLive: null == isLive
                ? _value.isLive
                : isLive // ignore: cast_nullable_to_non_nullable
                      as bool,
            specialization: freezed == specialization
                ? _value.specialization
                : specialization // ignore: cast_nullable_to_non_nullable
                      as String?,
            hourlyRate: freezed == hourlyRate
                ? _value.hourlyRate
                : hourlyRate // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HomeDoctorImplCopyWith<$Res>
    implements $HomeDoctorCopyWith<$Res> {
  factory _$$HomeDoctorImplCopyWith(
    _$HomeDoctorImpl value,
    $Res Function(_$HomeDoctorImpl) then,
  ) = __$$HomeDoctorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String imageAsset,
    double rating,
    bool isLive,
    String? specialization,
    String? hourlyRate,
  });
}

/// @nodoc
class __$$HomeDoctorImplCopyWithImpl<$Res>
    extends _$HomeDoctorCopyWithImpl<$Res, _$HomeDoctorImpl>
    implements _$$HomeDoctorImplCopyWith<$Res> {
  __$$HomeDoctorImplCopyWithImpl(
    _$HomeDoctorImpl _value,
    $Res Function(_$HomeDoctorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeDoctor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageAsset = null,
    Object? rating = null,
    Object? isLive = null,
    Object? specialization = freezed,
    Object? hourlyRate = freezed,
  }) {
    return _then(
      _$HomeDoctorImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        imageAsset: null == imageAsset
            ? _value.imageAsset
            : imageAsset // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        isLive: null == isLive
            ? _value.isLive
            : isLive // ignore: cast_nullable_to_non_nullable
                  as bool,
        specialization: freezed == specialization
            ? _value.specialization
            : specialization // ignore: cast_nullable_to_non_nullable
                  as String?,
        hourlyRate: freezed == hourlyRate
            ? _value.hourlyRate
            : hourlyRate // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$HomeDoctorImpl implements _HomeDoctor {
  const _$HomeDoctorImpl({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.rating,
    this.isLive = false,
    this.specialization,
    this.hourlyRate,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final String imageAsset;
  @override
  final double rating;
  @override
  @JsonKey()
  final bool isLive;
  @override
  final String? specialization;
  @override
  final String? hourlyRate;

  @override
  String toString() {
    return 'HomeDoctor(id: $id, name: $name, imageAsset: $imageAsset, rating: $rating, isLive: $isLive, specialization: $specialization, hourlyRate: $hourlyRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeDoctorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageAsset, imageAsset) ||
                other.imageAsset == imageAsset) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.isLive, isLive) || other.isLive == isLive) &&
            (identical(other.specialization, specialization) ||
                other.specialization == specialization) &&
            (identical(other.hourlyRate, hourlyRate) ||
                other.hourlyRate == hourlyRate));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    imageAsset,
    rating,
    isLive,
    specialization,
    hourlyRate,
  );

  /// Create a copy of HomeDoctor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeDoctorImplCopyWith<_$HomeDoctorImpl> get copyWith =>
      __$$HomeDoctorImplCopyWithImpl<_$HomeDoctorImpl>(this, _$identity);
}

abstract class _HomeDoctor implements HomeDoctor {
  const factory _HomeDoctor({
    required final String id,
    required final String name,
    required final String imageAsset,
    required final double rating,
    final bool isLive,
    final String? specialization,
    final String? hourlyRate,
  }) = _$HomeDoctorImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get imageAsset;
  @override
  double get rating;
  @override
  bool get isLive;
  @override
  String? get specialization;
  @override
  String? get hourlyRate;

  /// Create a copy of HomeDoctor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeDoctorImplCopyWith<_$HomeDoctorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
