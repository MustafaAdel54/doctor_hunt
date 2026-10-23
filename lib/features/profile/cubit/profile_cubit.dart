import 'package:doctor_hunt/core/error/failures.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/features/auth/models/user_model.dart';
import 'package:doctor_hunt/features/profile/repo/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.repo, required this.sessionService})
      : super(const ProfileInitial());

  final ProfileRepo repo;
  final SessionService sessionService;

  bool _isCreatingProfile = false;
  bool _isUpdatingProfile = false;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isUpdating => _isUpdatingProfile;

  /// Loads the profile for the currently authenticated user (or provided uid).
  Future<void> loadProfile([String? targetUid]) async {
    final uid = targetUid ?? sessionService.currentUserId;
    if (uid == null || uid.isEmpty) {
      if (!isClosed) emit(const ProfileError('unauthenticated'));
      return;
    }

    try {
      if (!isClosed) emit(const ProfileLoading());
      final result = await repo.getProfile(uid);
      if (isClosed) return;

      result.fold(
        (failure) => emit(ProfileError(_mapFailureToCode(failure))),
        (user) {
          _currentUser = user;
          emit(ProfileLoaded(user));
        },
      );
    } catch (_) {
      if (!isClosed) emit(const ProfileError('unknown'));
    }
  }

  /// Updates editable profile fields (name, phone, photoUrl) for the current user.
  /// Enforces single-flight execution to prevent accidental duplicate submissions.
  Future<bool> updateProfile({
    required String name,
    required String phone,
    String? photoUrl,
  }) async {
    if (_isUpdatingProfile) return false;

    var current = _currentUser;
    if (current == null) {
      final uid = sessionService.currentUserId;
      if (uid == null) {
        if (!isClosed) emit(const ProfileError('unauthenticated'));
        return false;
      }
      final loadRes = await repo.getProfile(uid);
      loadRes.fold((l) => null, (r) => current = r);
      if (current == null) {
        if (!isClosed) emit(const ProfileError('load_failed'));
        return false;
      }
      _currentUser = current;
    }

    _isUpdatingProfile = true;
    try {
      if (!isClosed) emit(ProfileUpdating(current!));

      final updatedUser = current!.copyWith(
        name: name.trim(),
        phone: phone.trim(),
        photoUrl: photoUrl ?? current!.photoUrl,
      );

      final result = await repo.updateProfile(updatedUser);
      if (isClosed) return false;

      return await result.fold(
        (failure) {
          if (!isClosed) {
            emit(ProfileUpdateError(
              code: _mapFailureToCode(failure),
              user: current!,
            ));
          }
          return false;
        },
        (_) async {
          _currentUser = updatedUser;
          // Refresh session profile cache
          await sessionService.refreshProfile();
          if (!isClosed) {
            emit(ProfileUpdateSuccess(updatedUser));
            emit(ProfileLoaded(updatedUser));
          }
          return true;
        },
      );
    } finally {
      _isUpdatingProfile = false;
    }
  }

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
      emit(const ProfileLoading());
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
            if (!isClosed) emit(const ProfileSuccess());
          } else {
            if (!isClosed) emit(ProfileError(_mapFailureToCode(failure)));
          }
        },
        (user) {
          // Profile created. Re-evaluate session so router redirects to home.
          _currentUser = user;
          sessionService.refreshProfile();
          if (!isClosed) emit(const ProfileSuccess());
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
