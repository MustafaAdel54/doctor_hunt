import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/features/doctors/repo/doctor_repo.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  final DoctorRepo doctorRepo;

  DoctorsCubit({required this.doctorRepo}) : super(DoctorsState.initial()) {
    loadDoctors();
  }

  /// Loads live doctors from Supabase repository.
  /// Note on Schema Constraints: The public.doctors table currently has no
  /// is_featured or is_popular column. In strict compliance with Phase 3 instructions,
  /// all active online doctors are made available in popularDoctors without inventing
  /// UUID-based rules or assigning business meaning to unrelated fields.
  /// Featured doctor classification remains cleanly deferred until a dedicated
  /// schema column is approved.
  Future<void> loadDoctors() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await doctorRepo.getDoctors(limit: 50);

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: failure is NetworkFailure
                ? t.errors.network
                : t.errors.server,
          ));
        }
      },
      (onlineDoctors) {
        if (!isClosed) {
          emit(state.copyWith(
            doctors: onlineDoctors,
            popularDoctors: onlineDoctors,
            featureDoctors: const [],
            isLoading: false,
            clearError: true,
          ));
        }
      },
    );
  }

  /// Searches doctors in Supabase by name or specialization.
  Future<void> searchDoctors(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      emit(state.copyWith(
        searchResults: const [],
        isSearching: false,
        clearError: true,
      ));
      return;
    }

    emit(state.copyWith(isSearching: true, clearError: true));

    final result = await doctorRepo.searchDoctors(trimmed);

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(state.copyWith(
          isSearching: false,
          errorMessage: failure is NetworkFailure
              ? t.errors.network
              : t.errors.server,
        ));
      },
      (results) {
        emit(state.copyWith(
          searchResults: results,
          isSearching: false,
          clearError: true,
        ));
      },
    );
  }

  DoctorModel? getDoctorById(String id) {
    return state.findDoctorById(id);
  }

  Future<void> refresh() => loadDoctors();
}
