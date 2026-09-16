import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_mock_data.freezed.dart';

/// A presentation model specific to the Patient Home screen's visual needs.
/// This prevents us from polluting the core DoctorModel with UI-specific properties
/// like "isLive" or specific string formatting for rates.
@freezed
class HomeDoctor with _$HomeDoctor {
  const factory HomeDoctor({
    required String id,
    required String name,
    required String imageAsset,
    required double rating,
    @Default(false) bool isLive,
    String? specialization,
    String? hourlyRate, // e.g., "\$ 25.00/ hours"
  }) = _HomeDoctor;
}

abstract final class HomeMockData {
  static const List<HomeDoctor> liveDoctors = [
    HomeDoctor(
      id: 'live1',
      name:
          'Dr. Handwerker', // Note: using default names or the name from the image isn't clear, just providing mock
      imageAsset: 'assets/images/home/live_doctor_1.png',
      rating: 0,
      isLive: true,
    ),
    HomeDoctor(
      id: 'live2',
      name: 'Dr. Smith',
      imageAsset: 'assets/images/home/live_doctor_2.png',
      rating: 0,
      isLive: true,
    ),
    HomeDoctor(
      id: 'live3',
      name: 'Dr. Doe',
      imageAsset: 'assets/images/home/live_doctor_3.png',
      rating: 0,
      isLive: true,
    ),
  ];

  static const List<HomeDoctor> popularDoctors = [
    HomeDoctor(
      id: 'pop1',
      name: 'Dr. Fillerup Grab',
      specialization: 'Medicine Specialist',
      imageAsset: 'assets/images/home/pop_doctor_1.png',
      rating: 5.0, // Or whatever the Figma showed, assuming full stars for now
    ),
    HomeDoctor(
      id: 'pop2',
      name: 'Dr. Blessing',
      specialization: 'Dentist Specialist',
      imageAsset: 'assets/images/home/pop_doctor_2.png',
      rating: 5.0,
    ),
  ];

  static const List<HomeDoctor> featureDoctors = [
    HomeDoctor(
      id: 'feat1',
      name: 'Dr. Crick',
      hourlyRate: r'$ 25.00/ hours',
      imageAsset: 'assets/images/home/feat_doctor_1.png',
      rating: 3.7,
    ),
    HomeDoctor(
      id: 'feat2',
      name: 'Dr. Strain',
      hourlyRate: r'$ 22.00/ hours',
      imageAsset: 'assets/images/home/feat_doctor_2.png',
      rating: 3.0,
    ),
    HomeDoctor(
      id: 'feat3',
      name: 'Dr. Lachinet',
      hourlyRate: r'$ 29.00/ hours',
      imageAsset: 'assets/images/home/feat_doctor_3.png',
      rating: 2.9,
    ),
  ];
}
