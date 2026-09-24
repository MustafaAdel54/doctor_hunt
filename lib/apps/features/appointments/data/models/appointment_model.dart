import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment_model.freezed.dart';
part 'appointment_model.g.dart';

@freezed
class AppointmentModel with _$AppointmentModel {
  const factory AppointmentModel({
    required String id,
    @JsonKey(name: 'patient_id') required String patientId,
    @JsonKey(name: 'doctor_id') required String doctorId,
    @JsonKey(name: 'doctor_name') required Map<String, String> doctorName,
    required String status, // 'pending', 'confirmed', 'cancelled', 'completed'
    @JsonKey(name: 'start_time') required DateTime startTime,
    @JsonKey(name: 'slot_lock_id', defaultValue: '') required String slotLockId,
    @JsonKey(name: 'end_time') DateTime? endTime,
    @JsonKey(name: 'patient_name') String? patientName,
    String? notes,
  }) = _AppointmentModel;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);
}
