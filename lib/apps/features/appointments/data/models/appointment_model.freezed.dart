// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) {
  return _AppointmentModel.fromJson(json);
}

/// @nodoc
mixin _$AppointmentModel {
  String get id => throw _privateConstructorUsedError;
  String get patientId => throw _privateConstructorUsedError;
  String get doctorId => throw _privateConstructorUsedError;
  Map<String, String> get doctorName => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'confirmed', 'cancelled', 'completed'
  DateTime get startTime => throw _privateConstructorUsedError;
  String get slotLockId => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  String? get patientName => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this AppointmentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentModelCopyWith<AppointmentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentModelCopyWith<$Res> {
  factory $AppointmentModelCopyWith(
    AppointmentModel value,
    $Res Function(AppointmentModel) then,
  ) = _$AppointmentModelCopyWithImpl<$Res, AppointmentModel>;
  @useResult
  $Res call({
    String id,
    String patientId,
    String doctorId,
    Map<String, String> doctorName,
    String status,
    DateTime startTime,
    String slotLockId,
    DateTime? endTime,
    String? patientName,
    String? notes,
  });
}

/// @nodoc
class _$AppointmentModelCopyWithImpl<$Res, $Val extends AppointmentModel>
    implements $AppointmentModelCopyWith<$Res> {
  _$AppointmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientId = null,
    Object? doctorId = null,
    Object? doctorName = null,
    Object? status = null,
    Object? startTime = null,
    Object? slotLockId = null,
    Object? endTime = freezed,
    Object? patientName = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            patientId: null == patientId
                ? _value.patientId
                : patientId // ignore: cast_nullable_to_non_nullable
                      as String,
            doctorId: null == doctorId
                ? _value.doctorId
                : doctorId // ignore: cast_nullable_to_non_nullable
                      as String,
            doctorName: null == doctorName
                ? _value.doctorName
                : doctorName // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            slotLockId: null == slotLockId
                ? _value.slotLockId
                : slotLockId // ignore: cast_nullable_to_non_nullable
                      as String,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            patientName: freezed == patientName
                ? _value.patientName
                : patientName // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppointmentModelImplCopyWith<$Res>
    implements $AppointmentModelCopyWith<$Res> {
  factory _$$AppointmentModelImplCopyWith(
    _$AppointmentModelImpl value,
    $Res Function(_$AppointmentModelImpl) then,
  ) = __$$AppointmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String patientId,
    String doctorId,
    Map<String, String> doctorName,
    String status,
    DateTime startTime,
    String slotLockId,
    DateTime? endTime,
    String? patientName,
    String? notes,
  });
}

/// @nodoc
class __$$AppointmentModelImplCopyWithImpl<$Res>
    extends _$AppointmentModelCopyWithImpl<$Res, _$AppointmentModelImpl>
    implements _$$AppointmentModelImplCopyWith<$Res> {
  __$$AppointmentModelImplCopyWithImpl(
    _$AppointmentModelImpl _value,
    $Res Function(_$AppointmentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientId = null,
    Object? doctorId = null,
    Object? doctorName = null,
    Object? status = null,
    Object? startTime = null,
    Object? slotLockId = null,
    Object? endTime = freezed,
    Object? patientName = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$AppointmentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        patientId: null == patientId
            ? _value.patientId
            : patientId // ignore: cast_nullable_to_non_nullable
                  as String,
        doctorId: null == doctorId
            ? _value.doctorId
            : doctorId // ignore: cast_nullable_to_non_nullable
                  as String,
        doctorName: null == doctorName
            ? _value._doctorName
            : doctorName // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        slotLockId: null == slotLockId
            ? _value.slotLockId
            : slotLockId // ignore: cast_nullable_to_non_nullable
                  as String,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        patientName: freezed == patientName
            ? _value.patientName
            : patientName // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentModelImpl implements _AppointmentModel {
  const _$AppointmentModelImpl({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required final Map<String, String> doctorName,
    required this.status,
    required this.startTime,
    required this.slotLockId,
    this.endTime,
    this.patientName,
    this.notes,
  }) : _doctorName = doctorName;

  factory _$AppointmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String patientId;
  @override
  final String doctorId;
  final Map<String, String> _doctorName;
  @override
  Map<String, String> get doctorName {
    if (_doctorName is EqualUnmodifiableMapView) return _doctorName;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_doctorName);
  }

  @override
  final String status;
  // 'pending', 'confirmed', 'cancelled', 'completed'
  @override
  final DateTime startTime;
  @override
  final String slotLockId;
  @override
  final DateTime? endTime;
  @override
  final String? patientName;
  @override
  final String? notes;

  @override
  String toString() {
    return 'AppointmentModel(id: $id, patientId: $patientId, doctorId: $doctorId, doctorName: $doctorName, status: $status, startTime: $startTime, slotLockId: $slotLockId, endTime: $endTime, patientName: $patientName, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.doctorId, doctorId) ||
                other.doctorId == doctorId) &&
            const DeepCollectionEquality().equals(
              other._doctorName,
              _doctorName,
            ) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.slotLockId, slotLockId) ||
                other.slotLockId == slotLockId) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.patientName, patientName) ||
                other.patientName == patientName) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    patientId,
    doctorId,
    const DeepCollectionEquality().hash(_doctorName),
    status,
    startTime,
    slotLockId,
    endTime,
    patientName,
    notes,
  );

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentModelImplCopyWith<_$AppointmentModelImpl> get copyWith =>
      __$$AppointmentModelImplCopyWithImpl<_$AppointmentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentModelImplToJson(this);
  }
}

abstract class _AppointmentModel implements AppointmentModel {
  const factory _AppointmentModel({
    required final String id,
    required final String patientId,
    required final String doctorId,
    required final Map<String, String> doctorName,
    required final String status,
    required final DateTime startTime,
    required final String slotLockId,
    final DateTime? endTime,
    final String? patientName,
    final String? notes,
  }) = _$AppointmentModelImpl;

  factory _AppointmentModel.fromJson(Map<String, dynamic> json) =
      _$AppointmentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get patientId;
  @override
  String get doctorId;
  @override
  Map<String, String> get doctorName;
  @override
  String get status; // 'pending', 'confirmed', 'cancelled', 'completed'
  @override
  DateTime get startTime;
  @override
  String get slotLockId;
  @override
  DateTime? get endTime;
  @override
  String? get patientName;
  @override
  String? get notes;

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentModelImplCopyWith<_$AppointmentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
