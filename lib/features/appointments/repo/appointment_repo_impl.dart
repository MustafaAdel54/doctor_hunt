import 'package:dartz/dartz.dart';
import 'package:doctor_hunt/core/error/exceptions.dart';
import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/network/network_info.dart';
import 'package:doctor_hunt/core/network/supabase_error_mapper.dart';
import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/appointments/service/appointment_service.dart';

import 'appointment_repo.dart';

class AppointmentRepoImpl implements AppointmentRepo {
  const AppointmentRepoImpl({required this.service, required this.networkInfo});

  final AppointmentService service;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<AppointmentModel>>> getPatientAppointments(
    String patientId,
  ) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final appointments = await service.getPatientAppointments(patientId);
      return Right(appointments);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentModel>>> getDoctorAppointments(
    String doctorId,
  ) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final appointments = await service.getDoctorAppointments(doctorId);
      return Right(appointments);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, AppointmentModel>> bookAppointment(
    AppointmentModel appointment,
  ) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final booked = await service.bookAppointment(appointment);
      return Right(booked);
    } on SlotTakenException {
      return const Left(SlotTakenFailure());
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateStatus(
    String appointmentId,
    String status,
  ) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await service.updateStatus(appointmentId, status);
      return const Right(null);
    } catch (e) {
      return Left(SupabaseErrorMapper.map(e));
    }
  }
}
