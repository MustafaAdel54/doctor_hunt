import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/appointment_model.dart';

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
