import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/network/network_info.dart';
import 'package:doctor_hunt/core/network/supabase_error_mapper.dart';
import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/availability/models/availability_model.dart';
import 'package:doctor_hunt/features/availability/service/availability_service.dart';

import 'availability_repo.dart';
import 'slot_calculator.dart';

class AvailabilityRepoImpl implements AvailabilityRepo {
  const AvailabilityRepoImpl({
    required this.service,
    required this.networkInfo,
  });

  final AvailabilityService service;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, AvailabilityModel>> getDoctorAvailability(
    String doctorId,
  ) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final availability = await service.getDoctorAvailability(doctorId);
      return Right(availability);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateDoctorAvailability(
    AvailabilityModel availability,
  ) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await service.updateDoctorAvailability(availability);
      return const Right(null);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }

  @override
  List<TimeSlot> calculateAvailableSlots(
    DateTime date,
    AvailabilityModel availability,
    List<AppointmentModel> existingAppointments,
  ) {
    return SlotCalculator.calculate(date, availability, existingAppointments);
  }
}
