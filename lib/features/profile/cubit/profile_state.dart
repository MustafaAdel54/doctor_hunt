import 'package:doctor_hunt/features/auth/models/user_model.dart';

sealed class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileSuccess extends ProfileState {
  const ProfileSuccess();
}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  const ProfileLoaded(this.user);
}

class ProfileUpdating extends ProfileState {
  final UserModel user;
  const ProfileUpdating(this.user);
}

class ProfileUpdateSuccess extends ProfileState {
  final UserModel user;
  const ProfileUpdateSuccess(this.user);
}

class ProfileUpdateError extends ProfileState {
  final String code;
  final UserModel user;
  const ProfileUpdateError({required this.code, required this.user});
}

class ProfileError extends ProfileState {
  final String code;
  const ProfileError(this.code);
}
