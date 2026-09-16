// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentModelImpl _$$AppointmentModelImplFromJson(
  Map<String, dynamic> json,
) => _$AppointmentModelImpl(
  id: json['id'] as String,
  patientId: json['patientId'] as String,
  doctorId: json['doctorId'] as String,
  doctorName: Map<String, String>.from(json['doctorName'] as Map),
  status: json['status'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  slotLockId: json['slotLockId'] as String,
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
  patientName: json['patientName'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$AppointmentModelImplToJson(
  _$AppointmentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'patientId': instance.patientId,
  'doctorId': instance.doctorId,
  'doctorName': instance.doctorName,
  'status': instance.status,
  'startTime': instance.startTime.toIso8601String(),
  'slotLockId': instance.slotLockId,
  'endTime': instance.endTime?.toIso8601String(),
  'patientName': instance.patientName,
  'notes': instance.notes,
};
