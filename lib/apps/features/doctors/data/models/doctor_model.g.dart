// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
  name: Map<String, String>.from(json['name'] as Map),
  image: json['image'] as String?,
  phone: json['phone'] as String,
  ratingSum: (json['ratingSum'] as num).toDouble(),
  ratingCount: (json['ratingCount'] as num).toInt(),
  specialization: json['specialization'] as String,
  yearsExperience: (json['yearsExperience'] as num).toInt(),
  patientsCount: (json['patientsCount'] as num?)?.toInt() ?? 700,
  runningCount: (json['runningCount'] as num?)?.toInt() ?? 100,
  ongoingCount: (json['ongoingCount'] as num?)?.toInt() ?? 500,
  hourlyRate: (json['hourlyRate'] as num?)?.toDouble() ?? 28.0,
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
      'name': instance.name,
      'image': instance.image,
      'phone': instance.phone,
      'ratingSum': instance.ratingSum,
      'ratingCount': instance.ratingCount,
      'specialization': instance.specialization,
      'yearsExperience': instance.yearsExperience,
      'patientsCount': instance.patientsCount,
      'runningCount': instance.runningCount,
      'ongoingCount': instance.ongoingCount,
      'hourlyRate': instance.hourlyRate,
      'services': instance.services,
    };
