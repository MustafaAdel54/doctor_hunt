import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/availability_model.dart';
import '../../../appointments/data/models/appointment_model.dart';

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
