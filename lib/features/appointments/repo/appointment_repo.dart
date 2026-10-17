import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';

abstract interface class AppointmentRepo {
  Future<Either<Failure, List<AppointmentModel>>> getPatientAppointments(
    String patientId,
  );
  Future<Either<Failure, List<AppointmentModel>>> getDoctorAppointments(
    String doctorId,
  );
  Future<Either<Failure, AppointmentModel>> bookAppointment(
    AppointmentModel appointment,
  );
  Future<Either<Failure, void>> updateStatus(
    String appointmentId,
    String status,
  );
}
