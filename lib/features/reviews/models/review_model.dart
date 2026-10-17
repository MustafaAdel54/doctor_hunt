class ReviewModel {
  final String id;
  final String appointmentId;
  final String patientId;
  final String doctorId;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final String? patientName;

  const ReviewModel({
    required this.id,
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.patientName,
  });

  ReviewModel copyWith({
    String? id,
    String? appointmentId,
    String? patientId,
    String? doctorId,
    int? rating,
    String? comment,
    DateTime? createdAt,
    String? patientName,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      appointmentId: appointmentId ?? this.appointmentId,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      patientName: patientName ?? this.patientName,
    );
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      appointmentId: json['appointment_id'] as String,
      patientId: json['patient_id'] as String,
      doctorId: json['doctor_id'] as String,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      patientName: json['patient_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointment_id': appointmentId,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'rating': rating,
      if (comment != null) 'comment': comment,
      'created_at': createdAt.toIso8601String(),
      if (patientName != null) 'patient_name': patientName,
    };
  }
}
