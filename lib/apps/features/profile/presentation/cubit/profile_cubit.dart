import 'package:doctor_hunt/apps/core/error/failures.dart';
import 'package:doctor_hunt/apps/core/session/session_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/profile_repo.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.repo, required this.sessionService})
      : super(const ProfileState.initial());

  final ProfileRepo repo;
  final SessionService sessionService;

  bool _isCreatingProfile = false;

  /// Creates the database application profile after role selection.
  /// Used for both email-registered and Google Sign-In users.
  Future<void> createProfile({
    required String role,
    String? name,
    String? photoUrl,
    String? phone,
  }) async {
    if (_isCreatingProfile) return;
    _isCreatingProfile = true;

    try {
      emit(const ProfileState.loading());
      final result = await repo.createProfile(
        role: role,
        name: name,
        photoUrl: photoUrl,
        phone: phone,
      );
      result.fold(
        (failure) {
          if (failure is AuthFailure && failure.code == 'account-already-setup') {
            // Self-healing: profile already exists, re-evaluate session so router redirects home
            sessionService.refreshProfile();
            if (!isClosed) emit(const ProfileState.success());
          } else {
            if (!isClosed) emit(ProfileState.error(_mapFailureToCode(failure)));
          }
        },
        (user) {
          // Profile created. Re-evaluate session so router redirects to home.
          sessionService.refreshProfile();
          if (!isClosed) emit(const ProfileState.success());
        },
      );
    } finally {
      _isCreatingProfile = false;
    }
  }

  String _mapFailureToCode(Failure failure) {
    if (failure is AuthFailure) return failure.code;
    if (failure is NetworkFailure) return 'network';
    if (failure is ServerFailure) return 'server';
    return 'unknown';
  }
}
