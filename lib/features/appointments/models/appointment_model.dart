class AppointmentModel {
  final String id;
  final String patientId;
  final String doctorId;
  final Map<String, String> doctorName;
  final String status; // 'pending', 'confirmed', 'cancelled', 'completed'
  final DateTime startTime;
  final DateTime? endTime;
  final String? patientName;
  final String? notes;
  final int? rating;
  final String? reviewComment;
  final DateTime? cancelledAt;
  final DateTime? createdAt;

  const AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    required this.status,
    required this.startTime,
    this.endTime,
    this.patientName,
    this.notes,
    this.rating,
    this.reviewComment,
    this.cancelledAt,
    this.createdAt,
  });

  AppointmentModel copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    Map<String, String>? doctorName,
    String? status,
    DateTime? startTime,
    DateTime? endTime,
    String? patientName,
    String? notes,
    int? rating,
    String? reviewComment,
    DateTime? cancelledAt,
    DateTime? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      patientName: patientName ?? this.patientName,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
      reviewComment: reviewComment ?? this.reviewComment,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      doctorId: json['doctor_id'] as String,
      doctorName: json['doctor_name'] is Map
          ? Map<String, String>.from(json['doctor_name'] as Map)
          : {'en': json['doctor_name']?.toString() ?? ''},
      status: json['status'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      patientName: json['patient_name'] as String?,
      notes: json['notes'] as String?,
      rating: json['rating'] as int?,
      reviewComment: json['review_comment'] as String?,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'status': status,
      'start_time': startTime.toIso8601String(),
      if (endTime != null) 'end_time': endTime!.toIso8601String(),
      if (patientName != null) 'patient_name': patientName,
      if (notes != null) 'notes': notes,
      if (rating != null) 'rating': rating,
      if (reviewComment != null) 'review_comment': reviewComment,
      if (cancelledAt != null) 'cancelled_at': cancelledAt!.toIso8601String(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
