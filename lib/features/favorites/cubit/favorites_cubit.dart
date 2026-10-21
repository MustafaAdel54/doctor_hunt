import 'package:doctor_hunt/features/favorites/repo/favorites_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({required this.repo}) : super(const FavoritesState()) {
    loadFavorites();
  }

  final FavoritesRepo repo;

  Future<void> loadFavorites() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await repo.getFavoriteDoctorIds();
    result.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: 'server',
          ));
        }
      },
      (ids) {
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            favoriteDoctorIds: ids.toSet(),
            clearError: true,
          ));
        }
      },
    );
  }

  Future<void> toggleFavorite(String doctorId) async {
    final currentIds = Set<String>.from(state.favoriteDoctorIds);
    final isFav = currentIds.contains(doctorId);

    // Optimistic update
    if (isFav) {
      currentIds.remove(doctorId);
    } else {
      currentIds.add(doctorId);
    }
    emit(state.copyWith(favoriteDoctorIds: currentIds, clearError: true));

    // Supabase synchronization
    final result = isFav
        ? await repo.removeFavorite(doctorId)
        : await repo.addFavorite(doctorId);

    result.fold(
      (failure) {
        if (!isClosed) {
          // Revert optimistic update on failure
          final revertedIds = Set<String>.from(state.favoriteDoctorIds);
          if (isFav) {
            revertedIds.add(doctorId);
          } else {
            revertedIds.remove(doctorId);
          }
          emit(state.copyWith(
            favoriteDoctorIds: revertedIds,
            errorMessage: 'server',
          ));
        }
      },
      (_) {
        // Success: already reflected in state
      },
    );
  }
}
