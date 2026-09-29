import 'package:doctor_hunt/generated/image_assets.dart';
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
      imageAsset: ImageAssets.liveDoctor1,
      rating: 0,
      isLive: true,
    ),
    HomeDoctor(
      id: 'live2',
      name: 'Dr. Smith',
      imageAsset: ImageAssets.liveDoctor2,
      rating: 0,
      isLive: true,
    ),
    HomeDoctor(
      id: 'live3',
      name: 'Dr. Doe',
      imageAsset: ImageAssets.liveDoctor3,
      rating: 0,
      isLive: true,
    ),
  ];

  static const List<HomeDoctor> popularDoctors = [
    HomeDoctor(
      id: 'pop1',
      name: 'Dr. Fillerup Grab',
      specialization: 'Medicine Specialist',
      imageAsset: ImageAssets.popDoctor1,
      rating: 5.0, // Or whatever the Figma showed, assuming full stars for now
    ),
    HomeDoctor(
      id: 'pop2',
      name: 'Dr. Blessing',
      specialization: 'Dentist Specialist',
      imageAsset: ImageAssets.popDoctor2,
      rating: 5.0,
    ),
  ];

  static const List<HomeDoctor> featureDoctors = [
    HomeDoctor(
      id: 'feat1',
      name: 'Dr. Crick',
      hourlyRate: r'$ 25.00/ hours',
      imageAsset: ImageAssets.featDoctor1,
      rating: 3.7,
    ),
    HomeDoctor(
      id: 'feat2',
      name: 'Dr. Strain',
      hourlyRate: r'$ 22.00/ hours',
      imageAsset: ImageAssets.featDoctor2,
      rating: 3.0,
    ),
    HomeDoctor(
      id: 'feat3',
      name: 'Dr. Lachinet',
      hourlyRate: r'$ 29.00/ hours',
      imageAsset: ImageAssets.featDoctor3,
      rating: 2.9,
    ),
  ];
}
