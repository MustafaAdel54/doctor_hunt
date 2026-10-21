// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
  id: json['id'] as String? ?? '',
  name: Map<String, String>.from(json['name'] as Map),
  image: json['image'] as String?,
  phone: json['phone'] as String,
  ratingSum: (json['rating_sum'] as num).toDouble(),
  ratingCount: (json['rating_count'] as num).toInt(),
  specialization: json['specialization'] as String,
  yearsExperience: (json['years_experience'] as num).toInt(),
  patientsCount: (json['patients_count'] as num?)?.toInt() ?? 700,
  runningCount: (json['running_count'] as num?)?.toInt() ?? 100,
  ongoingCount: (json['ongoing_count'] as num?)?.toInt() ?? 500,
  hourlyRate: (json['hourly_rate'] as num?)?.toDouble() ?? 28.0,
  services:
      (json['services'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [
        'Patient care should be the number one priority.',
        'If you run your practice you know how frustrating.',
        "That's why some of appointment reminder system.",
      ],
);

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'phone': instance.phone,
      'rating_sum': instance.ratingSum,
      'rating_count': instance.ratingCount,
      'specialization': instance.specialization,
      'years_experience': instance.yearsExperience,
      'patients_count': instance.patientsCount,
      'running_count': instance.runningCount,
      'ongoing_count': instance.ongoingCount,
      'hourly_rate': instance.hourlyRate,
      'services': instance.services,
    };
