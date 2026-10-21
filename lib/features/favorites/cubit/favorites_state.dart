import 'package:equatable/equatable.dart';

class FavoritesState extends Equatable {
  final Set<String> favoriteDoctorIds;
  final bool isLoading;
  final String? errorMessage;

  const FavoritesState({
    this.favoriteDoctorIds = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  bool isFavorite(String doctorId) => favoriteDoctorIds.contains(doctorId);

  FavoritesState copyWith({
    Set<String>? favoriteDoctorIds,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FavoritesState(
      favoriteDoctorIds: favoriteDoctorIds ?? this.favoriteDoctorIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [favoriteDoctorIds, isLoading, errorMessage];
}
