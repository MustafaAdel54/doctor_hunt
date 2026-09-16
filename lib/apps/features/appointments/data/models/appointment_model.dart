import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment_model.freezed.dart';
part 'appointment_model.g.dart';

@freezed
class AppointmentModel with _$AppointmentModel {
  const factory AppointmentModel({
    required String id,
    required String patientId,
    required String doctorId,
    required Map<String, String> doctorName,
    required String status, // 'pending', 'confirmed', 'cancelled', 'completed'
    required DateTime startTime,
    required String slotLockId,
    DateTime? endTime,
    String? patientName,
    String? notes,
  }) = _AppointmentModel;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);
}
