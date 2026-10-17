class TimeRange {
  final String start; // HH:mm
  final String end; // HH:mm

  const TimeRange({
    required this.start,
    required this.end,
  });

  TimeRange copyWith({
    String? start,
    String? end,
  }) {
    return TimeRange(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  factory TimeRange.fromJson(Map<String, dynamic> json) {
    return TimeRange(
      start: json['start'] as String,
      end: json['end'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'start': start,
    'end': end,
  };
}

class DayAvailability {
  final int weekday; // 1 = Monday, 7 = Sunday
  final List<TimeRange> ranges;

  const DayAvailability({
    required this.weekday,
    this.ranges = const [],
  });

  DayAvailability copyWith({
    int? weekday,
    List<TimeRange>? ranges,
  }) {
    return DayAvailability(
      weekday: weekday ?? this.weekday,
      ranges: ranges ?? this.ranges,
    );
  }

  factory DayAvailability.fromJson(Map<String, dynamic> json) {
    return DayAvailability(
      weekday: json['weekday'] as int,
      ranges: (json['ranges'] as List<dynamic>?)
              ?.map((e) => TimeRange.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'weekday': weekday,
    'ranges': ranges.map((e) => e.toJson()).toList(),
  };
}

class AvailabilityModel {
  final String doctorId;
  final int slotDurationMinutes;
  final List<DayAvailability> days;

  const AvailabilityModel({
    required this.doctorId,
    required this.slotDurationMinutes,
    this.days = const [],
  });

  AvailabilityModel copyWith({
    String? doctorId,
    int? slotDurationMinutes,
    List<DayAvailability>? days,
  }) {
    return AvailabilityModel(
      doctorId: doctorId ?? this.doctorId,
      slotDurationMinutes: slotDurationMinutes ?? this.slotDurationMinutes,
      days: days ?? this.days,
    );
  }

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      doctorId: (json['doctor_id'] ?? '') as String,
      slotDurationMinutes:
          (json['slot_duration_minutes'] as num?)?.toInt() ?? 30,
      days: (json['days'] as List<dynamic>?)
              ?.map((e) => DayAvailability.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'doctor_id': doctorId,
    'slot_duration_minutes': slotDurationMinutes,
    'days': days.map((e) => e.toJson()).toList(),
  };
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
