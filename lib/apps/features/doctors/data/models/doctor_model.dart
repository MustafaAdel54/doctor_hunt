import 'package:freezed_annotation/freezed_annotation.dart';

part 'doctor_model.freezed.dart';
part 'doctor_model.g.dart';

@freezed
class DoctorModel with _$DoctorModel {
  const factory DoctorModel({
    required String uid,
    required Map<String, String> name,
    required String specialization,
    required Map<String, String> bio,
    required Map<String, String> address,
    required int fee,
    @Default(0.0) double ratingSum,
    @Default(0) int ratingCount,
    String? photoUrl,
    String? clinicPhone,
    @Default([]) List<String> treats,
    @Default(0) int yearsExperience,
  }) = _DoctorModel;

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);
}

extension DoctorModelExt on DoctorModel {
  double get averageRating => ratingCount == 0 ? 0 : ratingSum / ratingCount;
}
