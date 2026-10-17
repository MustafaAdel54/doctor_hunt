import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/availability/models/availability_model.dart';

abstract interface class AvailabilityRepo {
  Future<Either<Failure, AvailabilityModel>> getDoctorAvailability(
    String doctorId,
  );
  Future<Either<Failure, void>> updateDoctorAvailability(
    AvailabilityModel availability,
  );

  /// Pure local calculation using the SlotCalculator
  List<TimeSlot> calculateAvailableSlots(
    DateTime date,
    AvailabilityModel availability,
    List<AppointmentModel> existingAppointments,
  );
}
