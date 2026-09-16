// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimeRangeImpl _$$TimeRangeImplFromJson(Map<String, dynamic> json) =>
    _$TimeRangeImpl(start: json['start'] as String, end: json['end'] as String);

Map<String, dynamic> _$$TimeRangeImplToJson(_$TimeRangeImpl instance) =>
    <String, dynamic>{'start': instance.start, 'end': instance.end};

_$DayAvailabilityImpl _$$DayAvailabilityImplFromJson(
  Map<String, dynamic> json,
) => _$DayAvailabilityImpl(
  weekday: (json['weekday'] as num).toInt(),
  ranges:
      (json['ranges'] as List<dynamic>?)
          ?.map((e) => TimeRange.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$DayAvailabilityImplToJson(
  _$DayAvailabilityImpl instance,
) => <String, dynamic>{'weekday': instance.weekday, 'ranges': instance.ranges};

_$AvailabilityModelImpl _$$AvailabilityModelImplFromJson(
  Map<String, dynamic> json,
) => _$AvailabilityModelImpl(
  doctorId: json['doctorId'] as String,
  slotDurationMinutes: (json['slotDurationMinutes'] as num).toInt(),
  days:
      (json['days'] as List<dynamic>?)
          ?.map((e) => DayAvailability.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$AvailabilityModelImplToJson(
  _$AvailabilityModelImpl instance,
) => <String, dynamic>{
  'doctorId': instance.doctorId,
  'slotDurationMinutes': instance.slotDurationMinutes,
  'days': instance.days,
};
