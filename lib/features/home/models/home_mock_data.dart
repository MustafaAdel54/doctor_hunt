import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';

/// A presentation model specific to the Patient Home and Popular Doctors screens' visual needs.
class HomeDoctor {
  final String id;
  final String name;
  final String imageAsset;
  final double rating;
  final String? specialization;
  final String? hourlyRate; // e.g., "\$ 25.00/ hours"
  final int? viewsCount;
  final bool isFavorite;

  const HomeDoctor({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.rating,
    this.specialization,
    this.hourlyRate,
    this.viewsCount,
    this.isFavorite = false,
  });

  factory HomeDoctor.fromJson(Map<String, dynamic> json) {
    return HomeDoctor(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageAsset: (json['image_asset'] ?? json['imageAsset']) as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      specialization: json['specialization'] as String?,
      hourlyRate: (json['hourly_rate'] ?? json['hourlyRate']) as String?,
      viewsCount: (json['views_count'] ?? json['viewsCount']) as int?,
      isFavorite: (json['is_favorite'] ?? json['isFavorite']) as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_asset': imageAsset,
      'rating': rating,
      'specialization': specialization,
      'hourly_rate': hourlyRate,
      'views_count': viewsCount,
      'is_favorite': isFavorite,
    };
  }

  HomeDoctor copyWith({
    String? id,
    String? name,
    String? imageAsset,
    double? rating,
    String? specialization,
    String? hourlyRate,
    int? viewsCount,
    bool? isFavorite,
  }) {
    return HomeDoctor(
      id: id ?? this.id,
      name: name ?? this.name,
      imageAsset: imageAsset ?? this.imageAsset,
      rating: rating ?? this.rating,
      specialization: specialization ?? this.specialization,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      viewsCount: viewsCount ?? this.viewsCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

abstract final class HomeMockData {
  static const List<HomeDoctor> popularDoctors = [
    HomeDoctor(
      id: 'pop1',
      name: 'Dr. Pediatrician',
      specialization: 'Specialist Cardiologist',
      imageAsset: ImageAssets.popDoctor1,
      rating: 2.4,
      viewsCount: 2475,
      isFavorite: true,
    ),
    HomeDoctor(
      id: 'pop2',
      name: 'Dr. Mistry Brick',
      specialization: 'Specialist Dentist',
      imageAsset: ImageAssets.popDoctor2,
      rating: 2.8,
      viewsCount: 2893,
      isFavorite: false,
    ),
    HomeDoctor(
      id: 'pop3',
      name: 'Dr. Ether Wall',
      specialization: 'Specialist Cancer',
      imageAsset: ImageAssets.popDoctor3,
      rating: 2.7,
      viewsCount: 2754,
      isFavorite: true,
    ),
    HomeDoctor(
      id: 'pop4',
      name: 'Dr. Johan smith',
      specialization: 'Specialist cardiologist',
      imageAsset: ImageAssets.popDoctor4,
      rating: 2.8,
      viewsCount: 2821,
      isFavorite: false,
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

extension HomeDoctorX on HomeDoctor {
  DoctorModel toDoctorModel() {
    double rate = 28.0;
    if (hourlyRate != null) {
      final match = RegExp(r'\d+(\.\d+)?').firstMatch(hourlyRate!);
      if (match != null) {
        rate = double.tryParse(match.group(0) ?? '') ?? 28.0;
      }
    }

    return DoctorModel(
      name: {'en': name},
      image: imageAsset,
      phone: '+1 234 567 8900',
      ratingSum: rating * 50,
      ratingCount: rating > 0 ? 50 : 0,
      specialization: specialization ?? 'Specialist',
      yearsExperience: 7,
      patientsCount: viewsCount ?? 700,
      runningCount: 100,
      ongoingCount: 500,
      hourlyRate: rate,
      services: const [
        'Patient care should be the number one priority.',
        'If you run your practice you know how frustrating.',
        "That's why some of appointment reminder system.",
      ],
    );
  }
}
