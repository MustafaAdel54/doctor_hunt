import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/features/doctors/repo/doctor_repo.dart';
import 'package:doctor_hunt/features/home/models/home_mock_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  final DoctorRepo doctorRepo;

  DoctorsCubit({required this.doctorRepo}) : super(DoctorsState.initial()) {
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await doctorRepo.getDoctors(limit: 50);

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: failure is NetworkFailure
                ? 'Network connection error'
                : 'Failed to load doctors from server',
          ));
        }
      },
      (onlineDoctors) {
        if (!isClosed) {
          if (onlineDoctors.isEmpty) {
            emit(state.copyWith(isLoading: false));
            return;
          }

          final featureIds = {
            HomeMockData.doctorCrickId,
            HomeMockData.doctorStrainId,
            HomeMockData.doctorLachinetId,
          };

          final popular = <HomeDoctor>[];
          final feature = <HomeDoctor>[];

          for (final doc in onlineDoctors) {
            final homeDoc = doc.toHomeDoctor();
            if (featureIds.contains(doc.id)) {
              feature.add(homeDoc);
            } else {
              popular.add(homeDoc);
            }
          }

          // If no doctors categorized as feature, split evenly
          if (feature.isEmpty && onlineDoctors.length > 4) {
            feature.addAll(popular.sublist(4));
            popular.removeRange(4, popular.length);
          }

          emit(state.copyWith(
            doctors: onlineDoctors,
            popularDoctors: popular.isNotEmpty ? popular : state.popularDoctors,
            featureDoctors: feature.isNotEmpty ? feature : state.featureDoctors,
            isLoading: false,
            clearError: true,
          ));
        }
      },
    );
  }

  DoctorModel? getDoctorById(String id) {
    return state.findDoctorById(id);
  }

  Future<void> refresh() => loadDoctors();
}
