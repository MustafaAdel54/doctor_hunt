import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/features/home/models/home_mock_data.dart';
import 'package:equatable/equatable.dart';

class DoctorsState extends Equatable {
  final List<DoctorModel> doctors;
  final List<HomeDoctor> popularDoctors;
  final List<HomeDoctor> featureDoctors;
  final bool isLoading;
  final String? errorMessage;

  const DoctorsState({
    this.doctors = const [],
    this.popularDoctors = const [],
    this.featureDoctors = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  factory DoctorsState.initial() {
    return const DoctorsState(
      doctors: [],
      popularDoctors: HomeMockData.popularDoctors,
      featureDoctors: HomeMockData.featureDoctors,
      isLoading: false,
    );
  }

  List<HomeDoctor> get allDoctors {
    final seen = <String>{};
    final combined = <HomeDoctor>[];
    for (final doc in [...popularDoctors, ...featureDoctors]) {
      if (seen.add(doc.id)) {
        combined.add(doc);
      }
    }
    return combined;
  }

  DoctorModel? findDoctorById(String id) {
    final realId = HomeMockData.getRealDoctorId(id);
    for (final doc in doctors) {
      if (doc.id == realId || doc.id == id) {
        return doc;
      }
    }
    return null;
  }

  DoctorsState copyWith({
    List<DoctorModel>? doctors,
    List<HomeDoctor>? popularDoctors,
    List<HomeDoctor>? featureDoctors,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DoctorsState(
      doctors: doctors ?? this.doctors,
      popularDoctors: popularDoctors ?? this.popularDoctors,
      featureDoctors: featureDoctors ?? this.featureDoctors,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        doctors,
        popularDoctors,
        featureDoctors,
        isLoading,
        errorMessage,
      ];
}
