import 'package:freezed_annotation/freezed_annotation.dart';

part 'availability_model.freezed.dart';
part 'availability_model.g.dart';

@freezed
class TimeRange with _$TimeRange {
  const factory TimeRange({
    required String start, // HH:mm
    required String end, // HH:mm
  }) = _TimeRange;

  factory TimeRange.fromJson(Map<String, dynamic> json) =>
      _$TimeRangeFromJson(json);
}

@freezed
class DayAvailability with _$DayAvailability {
  const factory DayAvailability({
    required int weekday, // 1 = Monday, 7 = Sunday
    @Default([]) List<TimeRange> ranges,
  }) = _DayAvailability;

  factory DayAvailability.fromJson(Map<String, dynamic> json) =>
      _$DayAvailabilityFromJson(json);
}

@freezed
class AvailabilityModel with _$AvailabilityModel {
  const factory AvailabilityModel({
    @JsonKey(name: 'doctor_id') required String doctorId,
    @JsonKey(name: 'slot_duration_minutes') required int slotDurationMinutes,
    @Default([]) List<DayAvailability> days,
  }) = _AvailabilityModel;

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityModelFromJson(json);
}

class TimeSlot {
  const TimeSlot({
    required this.start,
    required this.end,
    this.isAvailable = true,
  });

  final DateTime start;
  final DateTime end;
  final bool isAvailable;
}
