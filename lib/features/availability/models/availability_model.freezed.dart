// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'availability_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TimeRange _$TimeRangeFromJson(Map<String, dynamic> json) {
  return _TimeRange.fromJson(json);
}

/// @nodoc
mixin _$TimeRange {
  String get start => throw _privateConstructorUsedError; // HH:mm
  String get end => throw _privateConstructorUsedError;

  /// Serializes this TimeRange to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeRangeCopyWith<TimeRange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeRangeCopyWith<$Res> {
  factory $TimeRangeCopyWith(TimeRange value, $Res Function(TimeRange) then) =
      _$TimeRangeCopyWithImpl<$Res, TimeRange>;
  @useResult
  $Res call({String start, String end});
}

/// @nodoc
class _$TimeRangeCopyWithImpl<$Res, $Val extends TimeRange>
    implements $TimeRangeCopyWith<$Res> {
  _$TimeRangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeRange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? start = null, Object? end = null}) {
    return _then(
      _value.copyWith(
            start: null == start
                ? _value.start
                : start // ignore: cast_nullable_to_non_nullable
                      as String,
            end: null == end
                ? _value.end
                : end // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimeRangeImplCopyWith<$Res>
    implements $TimeRangeCopyWith<$Res> {
  factory _$$TimeRangeImplCopyWith(
    _$TimeRangeImpl value,
    $Res Function(_$TimeRangeImpl) then,
  ) = __$$TimeRangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String start, String end});
}

/// @nodoc
class __$$TimeRangeImplCopyWithImpl<$Res>
    extends _$TimeRangeCopyWithImpl<$Res, _$TimeRangeImpl>
    implements _$$TimeRangeImplCopyWith<$Res> {
  __$$TimeRangeImplCopyWithImpl(
    _$TimeRangeImpl _value,
    $Res Function(_$TimeRangeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimeRange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? start = null, Object? end = null}) {
    return _then(
      _$TimeRangeImpl(
        start: null == start
            ? _value.start
            : start // ignore: cast_nullable_to_non_nullable
                  as String,
        end: null == end
            ? _value.end
            : end // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeRangeImpl implements _TimeRange {
  const _$TimeRangeImpl({required this.start, required this.end});

  factory _$TimeRangeImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeRangeImplFromJson(json);

  @override
  final String start;
  // HH:mm
  @override
  final String end;

  @override
  String toString() {
    return 'TimeRange(start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeRangeImpl &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, start, end);

  /// Create a copy of TimeRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeRangeImplCopyWith<_$TimeRangeImpl> get copyWith =>
      __$$TimeRangeImplCopyWithImpl<_$TimeRangeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeRangeImplToJson(this);
  }
}

abstract class _TimeRange implements TimeRange {
  const factory _TimeRange({
    required final String start,
    required final String end,
  }) = _$TimeRangeImpl;

  factory _TimeRange.fromJson(Map<String, dynamic> json) =
      _$TimeRangeImpl.fromJson;

  @override
  String get start; // HH:mm
  @override
  String get end;

  /// Create a copy of TimeRange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeRangeImplCopyWith<_$TimeRangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DayAvailability _$DayAvailabilityFromJson(Map<String, dynamic> json) {
  return _DayAvailability.fromJson(json);
}

/// @nodoc
mixin _$DayAvailability {
  int get weekday =>
      throw _privateConstructorUsedError; // 1 = Monday, 7 = Sunday
  List<TimeRange> get ranges => throw _privateConstructorUsedError;

  /// Serializes this DayAvailability to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DayAvailability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DayAvailabilityCopyWith<DayAvailability> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DayAvailabilityCopyWith<$Res> {
  factory $DayAvailabilityCopyWith(
    DayAvailability value,
    $Res Function(DayAvailability) then,
  ) = _$DayAvailabilityCopyWithImpl<$Res, DayAvailability>;
  @useResult
  $Res call({int weekday, List<TimeRange> ranges});
}

/// @nodoc
class _$DayAvailabilityCopyWithImpl<$Res, $Val extends DayAvailability>
    implements $DayAvailabilityCopyWith<$Res> {
  _$DayAvailabilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DayAvailability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? weekday = null, Object? ranges = null}) {
    return _then(
      _value.copyWith(
            weekday: null == weekday
                ? _value.weekday
                : weekday // ignore: cast_nullable_to_non_nullable
                      as int,
            ranges: null == ranges
                ? _value.ranges
                : ranges // ignore: cast_nullable_to_non_nullable
                      as List<TimeRange>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DayAvailabilityImplCopyWith<$Res>
    implements $DayAvailabilityCopyWith<$Res> {
  factory _$$DayAvailabilityImplCopyWith(
    _$DayAvailabilityImpl value,
    $Res Function(_$DayAvailabilityImpl) then,
  ) = __$$DayAvailabilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int weekday, List<TimeRange> ranges});
}

/// @nodoc
class __$$DayAvailabilityImplCopyWithImpl<$Res>
    extends _$DayAvailabilityCopyWithImpl<$Res, _$DayAvailabilityImpl>
    implements _$$DayAvailabilityImplCopyWith<$Res> {
  __$$DayAvailabilityImplCopyWithImpl(
    _$DayAvailabilityImpl _value,
    $Res Function(_$DayAvailabilityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DayAvailability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? weekday = null, Object? ranges = null}) {
    return _then(
      _$DayAvailabilityImpl(
        weekday: null == weekday
            ? _value.weekday
            : weekday // ignore: cast_nullable_to_non_nullable
                  as int,
        ranges: null == ranges
            ? _value._ranges
            : ranges // ignore: cast_nullable_to_non_nullable
                  as List<TimeRange>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DayAvailabilityImpl implements _DayAvailability {
  const _$DayAvailabilityImpl({
    required this.weekday,
    final List<TimeRange> ranges = const [],
  }) : _ranges = ranges;

  factory _$DayAvailabilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$DayAvailabilityImplFromJson(json);

  @override
  final int weekday;
  // 1 = Monday, 7 = Sunday
  final List<TimeRange> _ranges;
  // 1 = Monday, 7 = Sunday
  @override
  @JsonKey()
  List<TimeRange> get ranges {
    if (_ranges is EqualUnmodifiableListView) return _ranges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ranges);
  }

  @override
  String toString() {
    return 'DayAvailability(weekday: $weekday, ranges: $ranges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DayAvailabilityImpl &&
            (identical(other.weekday, weekday) || other.weekday == weekday) &&
            const DeepCollectionEquality().equals(other._ranges, _ranges));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    weekday,
    const DeepCollectionEquality().hash(_ranges),
  );

  /// Create a copy of DayAvailability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DayAvailabilityImplCopyWith<_$DayAvailabilityImpl> get copyWith =>
      __$$DayAvailabilityImplCopyWithImpl<_$DayAvailabilityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DayAvailabilityImplToJson(this);
  }
}

abstract class _DayAvailability implements DayAvailability {
  const factory _DayAvailability({
    required final int weekday,
    final List<TimeRange> ranges,
  }) = _$DayAvailabilityImpl;

  factory _DayAvailability.fromJson(Map<String, dynamic> json) =
      _$DayAvailabilityImpl.fromJson;

  @override
  int get weekday; // 1 = Monday, 7 = Sunday
  @override
  List<TimeRange> get ranges;

  /// Create a copy of DayAvailability
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DayAvailabilityImplCopyWith<_$DayAvailabilityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AvailabilityModel _$AvailabilityModelFromJson(Map<String, dynamic> json) {
  return _AvailabilityModel.fromJson(json);
}

/// @nodoc
mixin _$AvailabilityModel {
  @JsonKey(name: 'doctor_id')
  String get doctorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'slot_duration_minutes')
  int get slotDurationMinutes => throw _privateConstructorUsedError;
  List<DayAvailability> get days => throw _privateConstructorUsedError;

  /// Serializes this AvailabilityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvailabilityModelCopyWith<AvailabilityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailabilityModelCopyWith<$Res> {
  factory $AvailabilityModelCopyWith(
    AvailabilityModel value,
    $Res Function(AvailabilityModel) then,
  ) = _$AvailabilityModelCopyWithImpl<$Res, AvailabilityModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'doctor_id') String doctorId,
    @JsonKey(name: 'slot_duration_minutes') int slotDurationMinutes,
    List<DayAvailability> days,
  });
}

/// @nodoc
class _$AvailabilityModelCopyWithImpl<$Res, $Val extends AvailabilityModel>
    implements $AvailabilityModelCopyWith<$Res> {
  _$AvailabilityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? doctorId = null,
    Object? slotDurationMinutes = null,
    Object? days = null,
  }) {
    return _then(
      _value.copyWith(
            doctorId: null == doctorId
                ? _value.doctorId
                : doctorId // ignore: cast_nullable_to_non_nullable
                      as String,
            slotDurationMinutes: null == slotDurationMinutes
                ? _value.slotDurationMinutes
                : slotDurationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            days: null == days
                ? _value.days
                : days // ignore: cast_nullable_to_non_nullable
                      as List<DayAvailability>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AvailabilityModelImplCopyWith<$Res>
    implements $AvailabilityModelCopyWith<$Res> {
  factory _$$AvailabilityModelImplCopyWith(
    _$AvailabilityModelImpl value,
    $Res Function(_$AvailabilityModelImpl) then,
  ) = __$$AvailabilityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'doctor_id') String doctorId,
    @JsonKey(name: 'slot_duration_minutes') int slotDurationMinutes,
    List<DayAvailability> days,
  });
}

/// @nodoc
class __$$AvailabilityModelImplCopyWithImpl<$Res>
    extends _$AvailabilityModelCopyWithImpl<$Res, _$AvailabilityModelImpl>
    implements _$$AvailabilityModelImplCopyWith<$Res> {
  __$$AvailabilityModelImplCopyWithImpl(
    _$AvailabilityModelImpl _value,
    $Res Function(_$AvailabilityModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? doctorId = null,
    Object? slotDurationMinutes = null,
    Object? days = null,
  }) {
    return _then(
      _$AvailabilityModelImpl(
        doctorId: null == doctorId
            ? _value.doctorId
            : doctorId // ignore: cast_nullable_to_non_nullable
                  as String,
        slotDurationMinutes: null == slotDurationMinutes
            ? _value.slotDurationMinutes
            : slotDurationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        days: null == days
            ? _value._days
            : days // ignore: cast_nullable_to_non_nullable
                  as List<DayAvailability>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailabilityModelImpl implements _AvailabilityModel {
  const _$AvailabilityModelImpl({
    @JsonKey(name: 'doctor_id') required this.doctorId,
    @JsonKey(name: 'slot_duration_minutes') required this.slotDurationMinutes,
    final List<DayAvailability> days = const [],
  }) : _days = days;

  factory _$AvailabilityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailabilityModelImplFromJson(json);

  @override
  @JsonKey(name: 'doctor_id')
  final String doctorId;
  @override
  @JsonKey(name: 'slot_duration_minutes')
  final int slotDurationMinutes;
  final List<DayAvailability> _days;
  @override
  @JsonKey()
  List<DayAvailability> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  @override
  String toString() {
    return 'AvailabilityModel(doctorId: $doctorId, slotDurationMinutes: $slotDurationMinutes, days: $days)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailabilityModelImpl &&
            (identical(other.doctorId, doctorId) ||
                other.doctorId == doctorId) &&
            (identical(other.slotDurationMinutes, slotDurationMinutes) ||
                other.slotDurationMinutes == slotDurationMinutes) &&
            const DeepCollectionEquality().equals(other._days, _days));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    doctorId,
    slotDurationMinutes,
    const DeepCollectionEquality().hash(_days),
  );

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailabilityModelImplCopyWith<_$AvailabilityModelImpl> get copyWith =>
      __$$AvailabilityModelImplCopyWithImpl<_$AvailabilityModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailabilityModelImplToJson(this);
  }
}

abstract class _AvailabilityModel implements AvailabilityModel {
  const factory _AvailabilityModel({
    @JsonKey(name: 'doctor_id') required final String doctorId,
    @JsonKey(name: 'slot_duration_minutes')
    required final int slotDurationMinutes,
    final List<DayAvailability> days,
  }) = _$AvailabilityModelImpl;

  factory _AvailabilityModel.fromJson(Map<String, dynamic> json) =
      _$AvailabilityModelImpl.fromJson;

  @override
  @JsonKey(name: 'doctor_id')
  String get doctorId;
  @override
  @JsonKey(name: 'slot_duration_minutes')
  int get slotDurationMinutes;
  @override
  List<DayAvailability> get days;

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvailabilityModelImplCopyWith<_$AvailabilityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
