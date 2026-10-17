import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/core/utils/error_mapper.dart';
import 'package:doctor_hunt/features/profile/cubit/profile_cubit.dart';
import 'package:doctor_hunt/features/profile/cubit/profile_state.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:doctor_hunt/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'widgets/role_option_card.dart';
import 'widgets/role_selection_header.dart';

/// Role Selection screen.
///
/// This screen is shown ONLY when a Supabase-authenticated user has no
/// database application profile ([SessionStatus.authenticatedWithoutProfile]).
///
/// It is reached after:
/// - Email + password sign-up  (new email user, no profile yet)
/// - Google Sign-In            (new Google user, no profile yet)
///
/// It is NOT reachable from the Login "Don't have an account?" link directly.
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>(),
      child: const _RoleSelectionView(),
    );
  }
}

class _RoleSelectionView extends StatefulWidget {
  const _RoleSelectionView();

  @override
  State<_RoleSelectionView> createState() => _RoleSelectionViewState();
}

class _RoleSelectionViewState extends State<_RoleSelectionView> {
  String? _selectedRole;

  void _onContinue() {
    final role = _selectedRole;
    if (role == null) return;

    // Both email-registered and Google users land here via
    // authenticatedWithoutProfile, so Supabase currentUser is
    // always non-null when this screen is shown.
    final supabaseUser = Supabase.instance.client.auth.currentUser;
    final sessionUid = sl<SessionService>().value.userId;
    final uid = sessionUid ?? supabaseUser?.id;

    if (uid == null) return; // Guard: should never happen

    final metadata = supabaseUser?.userMetadata;

    context.read<ProfileCubit>().createProfile(
      role: role,
      name: metadata?['name'] as String?,
      photoUrl: metadata?['photoUrl'] as String?,
      phone: null, // Phone is collected later in the profile
    );

    // No explicit navigation needed. After createProfile writes users/{uid},
    // the SessionService Firestore stream fires, the session transitions to
    // authenticated(role: ...), and GoRouter redirects to the correct home.
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.surface,
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            final msg = getErrorMessage(state.code);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), backgroundColor: palette.danger),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileLoading;

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const RoleSelectionHeader(),
                        SizedBox(height: 48.h),

                        RoleOptionCard(
                          title: t.auth.rolePatient,
                          description: t.auth.rolePatientDesc,
                          iconAsset: ImageAssets.patientIcon,
                          isSelected: _selectedRole == 'patient',
                          onTap: isLoading
                              ? null
                              : () => setState(() => _selectedRole = 'patient'),
                        ),
                        SizedBox(height: 24.h),

                        RoleOptionCard(
                          title: t.auth.roleDoctor,
                          description: t.auth.roleDoctorDesc,
                          fallbackIcon: Icons.medical_services_outlined,
                          isSelected: _selectedRole == 'doctor',
                          onTap: isLoading
                              ? null
                              : () => setState(() => _selectedRole = 'doctor'),
                        ),

                        const Spacer(),
                        SizedBox(height: 24.h),
                        PrimaryButton(
                          text: t.onboarding.next,
                          onPressed: (_selectedRole != null && !isLoading)
                              ? _onContinue
                              : null,
                          isFullWidth: true,
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
