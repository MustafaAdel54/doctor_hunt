import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/features/auth/models/user_model.dart';
import 'package:doctor_hunt/features/profile/cubit/profile_cubit.dart';
import 'package:doctor_hunt/features/profile/cubit/profile_state.dart';
import 'package:doctor_hunt/features/profile/screens/profile/widgets/profile_information_section.dart';
import 'package:doctor_hunt/features/profile/screens/widgets/profile_header.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  Future<void> _navigateToEdit(BuildContext context) async {
    final sessionRole = sl<SessionService>().value.role;
    final destination = sessionRole == 'doctor'
        ? Paths.editProfileDoctor
        : Paths.editProfilePatient;

    final updated = await context.push<bool>(destination);
    if (context.mounted) {
      context.read<ProfileCubit>().loadProfile();
      if (updated == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.profile.updateSuccess),
            backgroundColor: context.palette.primary,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.surface,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          UserModel? user;
          String? errorCode;
          bool isLoading = false;

          if (state is ProfileLoading) {
            isLoading = true;
          } else if (state is ProfileLoaded) {
            user = state.user;
          } else if (state is ProfileUpdating) {
            user = state.user;
          } else if (state is ProfileUpdateSuccess) {
            user = state.user;
          } else if (state is ProfileError) {
            errorCode = state.code;
          } else {
            user = context.read<ProfileCubit>().currentUser;
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header matching Figma Node 1-506
                ProfileHeader(
                  title: t.profile.title,
                  photoUrl: user?.photoUrl,
                  onCameraTap: () => _navigateToEdit(context),
                ),

                if (isLoading)
                  Padding(
                    padding: EdgeInsets.only(top: 60.h),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: palette.primary,
                      ),
                    ),
                  )
                else if (errorCode != null && user == null)
                  _buildErrorView(context, errorCode)
                else
                  ProfileInformationSection(
                    user: user,
                    onEdit: () => _navigateToEdit(context),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String errorCode) {
    final palette = context.palette;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: palette.danger,
              size: 48.sp,
            ),
            SizedBox(height: 12.h),
            Text(
              t.errors.server,
              textAlign: TextAlign.center,
              style: context.regular14TextSub,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => context.read<ProfileCubit>().loadProfile(),
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: palette.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(t.common.retry),
            ),
          ],
        ),
      ),
    );
  }
}
