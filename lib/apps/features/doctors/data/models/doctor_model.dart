import 'package:json_annotation/json_annotation.dart';

part 'doctor_model.g.dart';

@JsonSerializable()
class DoctorModel {
  final Map<String, String> name;
  final String? image;
  final String phone;
  final double ratingSum;
  final int ratingCount;
  final String specialization;
  final int yearsExperience;

  @JsonKey(defaultValue: 700)
  final int patientsCount;

  @JsonKey(defaultValue: 100)
  final int runningCount;

  @JsonKey(defaultValue: 500)
  final int ongoingCount;

  @JsonKey(defaultValue: 28.0)
  final double hourlyRate;

  @JsonKey(
    defaultValue: [
      'Patient care should be the number one priority.',
      'If you run your practice you know how frustrating.',
      'That\'s why some of appointment reminder system.',
    ],
  )
  final List<String> services;

  const DoctorModel({
    required this.name,
    this.image,
    required this.phone,
    required this.ratingSum,
    required this.ratingCount,
    required this.specialization,
    required this.yearsExperience,
    required this.patientsCount,
    required this.runningCount,
    required this.ongoingCount,
    required this.hourlyRate,
    required this.services,
  });

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get rating => ratingCount == 0 ? 0.0 : ratingSum / ratingCount;

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}
