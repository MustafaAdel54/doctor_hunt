// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewModelImpl _$$ReviewModelImplFromJson(Map<String, dynamic> json) =>
    _$ReviewModelImpl(
      id: json['id'] as String,
      appointmentId: json['appointment_id'] as String,
      patientId: json['patient_id'] as String,
      doctorId: json['doctor_id'] as String,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      patientName: json['patient_name'] as String?,
    );

Map<String, dynamic> _$$ReviewModelImplToJson(_$ReviewModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appointment_id': instance.appointmentId,
      'patient_id': instance.patientId,
      'doctor_id': instance.doctorId,
      'rating': instance.rating,
      'comment': instance.comment,
      'created_at': instance.createdAt.toIso8601String(),
      'patient_name': instance.patientName,
    };
