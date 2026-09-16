// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DoctorModelImpl _$$DoctorModelImplFromJson(Map<String, dynamic> json) =>
    _$DoctorModelImpl(
      uid: json['uid'] as String,
      name: Map<String, String>.from(json['name'] as Map),
      specialization: json['specialization'] as String,
      bio: Map<String, String>.from(json['bio'] as Map),
      address: Map<String, String>.from(json['address'] as Map),
      fee: (json['fee'] as num).toInt(),
      ratingSum: (json['ratingSum'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      photoUrl: json['photoUrl'] as String?,
      clinicPhone: json['clinicPhone'] as String?,
      treats:
          (json['treats'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      yearsExperience: (json['yearsExperience'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DoctorModelImplToJson(_$DoctorModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'specialization': instance.specialization,
      'bio': instance.bio,
      'address': instance.address,
      'fee': instance.fee,
      'ratingSum': instance.ratingSum,
      'ratingCount': instance.ratingCount,
      'photoUrl': instance.photoUrl,
      'clinicPhone': instance.clinicPhone,
      'treats': instance.treats,
      'yearsExperience': instance.yearsExperience,
    };
