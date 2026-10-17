// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['id'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      isVerified: json['is_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      photoUrl: json['photo_url'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.uid,
      'email': instance.email,
      'role': instance.role,
      'is_verified': instance.isVerified,
      'is_active': instance.isActive,
      'photo_url': instance.photoUrl,
      'name': instance.name,
      'phone': instance.phone,
    };
