// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentModelImpl _$$AppointmentModelImplFromJson(
  Map<String, dynamic> json,
) => _$AppointmentModelImpl(
  id: json['id'] as String,
  patientId: json['patient_id'] as String,
  doctorId: json['doctor_id'] as String,
  doctorName: Map<String, String>.from(json['doctor_name'] as Map),
  status: json['status'] as String,
  startTime: DateTime.parse(json['start_time'] as String),
  slotLockId: json['slot_lock_id'] as String? ?? '',
  endTime: json['end_time'] == null
      ? null
      : DateTime.parse(json['end_time'] as String),
  patientName: json['patient_name'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$AppointmentModelImplToJson(
  _$AppointmentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'patient_id': instance.patientId,
  'doctor_id': instance.doctorId,
  'doctor_name': instance.doctorName,
  'status': instance.status,
  'start_time': instance.startTime.toIso8601String(),
  'slot_lock_id': instance.slotLockId,
  'end_time': instance.endTime?.toIso8601String(),
  'patient_name': instance.patientName,
  'notes': instance.notes,
};
