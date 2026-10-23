import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:equatable/equatable.dart';

class DoctorsState extends Equatable {
  final List<DoctorModel> doctors;
  final List<DoctorModel> popularDoctors;
  final List<DoctorModel> featureDoctors;
  final List<DoctorModel> searchResults;
  final bool isLoading;
  final bool isSearching;
  final String? errorMessage;

  const DoctorsState({
    this.doctors = const [],
    this.popularDoctors = const [],
    this.featureDoctors = const [],
    this.searchResults = const [],
    this.isLoading = false,
    this.isSearching = false,
    this.errorMessage,
  });

  factory DoctorsState.initial() {
    return const DoctorsState(
      doctors: [],
      popularDoctors: [],
      featureDoctors: [],
      searchResults: [],
      isLoading: false,
      isSearching: false,
    );
  }

  List<DoctorModel> get allDoctors => doctors;

  DoctorModel? findDoctorById(String id) {
    for (final doc in doctors) {
      if (doc.id == id) {
        return doc;
      }
    }
    return null;
  }

  DoctorsState copyWith({
    List<DoctorModel>? doctors,
    List<DoctorModel>? popularDoctors,
    List<DoctorModel>? featureDoctors,
    List<DoctorModel>? searchResults,
    bool? isLoading,
    bool? isSearching,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DoctorsState(
      doctors: doctors ?? this.doctors,
      popularDoctors: popularDoctors ?? this.popularDoctors,
      featureDoctors: featureDoctors ?? this.featureDoctors,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        doctors,
        popularDoctors,
        featureDoctors,
        searchResults,
        isLoading,
        isSearching,
        errorMessage,
      ];
}
