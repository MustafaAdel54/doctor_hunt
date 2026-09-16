import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doctor_hunt/apps/core/di/injector.dart';
import 'package:doctor_hunt/apps/core/session/session_service.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/apps/core/widgets/primary_button.dart';
import 'package:doctor_hunt/i18n/strings.g.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';
import 'widgets/role_option_card.dart';
import 'widgets/role_selection_header.dart';

/// Role Selection screen.
///
/// This screen is shown ONLY when a Firebase-authenticated user has no
/// Firestore application profile ([SessionStatus.authenticatedWithoutProfile]).
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
      create: (_) => sl<AuthCubit>(),
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

    // The currently signed-in Firebase user is the source of truth.
    // Both email-registered and Google users land here via
    // authenticatedWithoutProfile, so FirebaseAuth.instance.currentUser is
    // always non-null when this screen is shown.
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final sessionUid = sl<SessionService>().value.userId;

    final uid = sessionUid ?? firebaseUser?.uid;
    final email = firebaseUser?.email ?? '';

    if (uid == null) return; // Guard: should never happen

    context.read<AuthCubit>().createUserProfile(
      uid: uid,
      email: email,
      role: role,
      name: firebaseUser?.displayName,
      photoUrl: firebaseUser?.photoURL,
      phone: null, // Phone is collected later in the profile
      isVerified:
          firebaseUser?.providerData.any((p) => p.providerId == 'google.com') ??
          false,
    );

    // No explicit navigation needed. After createUserProfile writes users/{uid},
    // the SessionService Firestore stream fires, the session transitions to
    // authenticated(role: ...), and GoRouter redirects to the correct home.
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.surface,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: palette.danger),
              );
            },
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

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
                          iconAsset: 'assets/icons/patient_icon.svg',
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
