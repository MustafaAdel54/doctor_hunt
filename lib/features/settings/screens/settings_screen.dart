import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/features/auth/cubit/auth_cubit.dart';
import 'package:doctor_hunt/features/auth/cubit/auth_state.dart';
import 'package:doctor_hunt/features/auth/models/user_model.dart';
import 'package:doctor_hunt/features/profile/cubit/profile_cubit.dart';
import 'package:doctor_hunt/features/profile/cubit/profile_state.dart';
import 'package:doctor_hunt/features/settings/screens/widgets/logout_dialog.dart';
import 'package:doctor_hunt/features/settings/screens/widgets/settings_language_bottom_sheet.dart';
import 'package:doctor_hunt/features/settings/screens/widgets/settings_logout_button.dart';
import 'package:doctor_hunt/features/settings/screens/widgets/settings_menu_item.dart';
import 'package:doctor_hunt/features/settings/screens/widgets/settings_profile_card.dart';
import 'package:doctor_hunt/features/settings/screens/widgets/settings_section_card.dart';
import 'package:doctor_hunt/features/settings/screens/widgets/settings_section_header.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) => sl<ProfileCubit>()..loadProfile()),
      ],
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatefulWidget {
  const _SettingsView();

  @override
  State<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<_SettingsView> {
  bool _notificationsEnabled = true;

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showLogoutConfirmationDialog(context);
    if (confirmed == true && context.mounted) {
      await context.read<AuthCubit>().logout();
      if (context.mounted) {
        context.go(Paths.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.surface,
      appBar: AppBar(
        title: Text(
          t.settings.title,
          style: context.bold18TextMain,
        ),
        backgroundColor: palette.surface,
        elevation: 0,
        centerTitle: false,
        leading: context.canPop()
            ? IconButton(
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: palette.textMain,
                  size: 28.sp,
                ),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (code) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.errors.server),
                  backgroundColor: palette.danger,
                ),
              );
            },
          );
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Profile Summary Card
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  final user = _resolveUser(context, state);
                  final sessionUser = sl<SessionService>().currentUser;
                  final fallbackName = sessionUser?.userMetadata?['name'] as String? ??
                      sessionUser?.email?.split('@').first ??
                      '';

                  return SettingsProfileCard(
                    user: user,
                    sessionEmail: sessionUser?.email ?? '',
                    fallbackName: fallbackName,
                    onTap: () async {
                      await context.push(Paths.profilePatient);
                      if (context.mounted) {
                        context.read<ProfileCubit>().loadProfile();
                      }
                    },
                  );
                },
              ),

              SizedBox(height: 18.h),

              // Account Settings Group
              SettingsSectionHeader(title: t.settings.accountSettings),
              SizedBox(height: 10.h),
              SettingsSectionCard(
                children: [
                  SettingsMenuItem(
                    icon: Icons.lock_outline_rounded,
                    title: t.settings.changePassword,
                    onTap: () => context.push(Paths.forgotPassword),
                  ),
                  SettingsSectionCard.buildDivider(context),
                  SettingsMenuItem(
                    icon: Icons.notifications_none_rounded,
                    title: t.settings.notifications,
                    trailing: Switch.adaptive(
                      value: _notificationsEnabled,
                      activeTrackColor: palette.primary,
                      onChanged: (val) => setState(() => _notificationsEnabled = val),
                    ),
                  ),
                  SettingsSectionCard.buildDivider(context),
                  SettingsMenuItem(
                    icon: Icons.shield_outlined,
                    title: t.settings.privacyPolicy,
                    onTap: () => context.push(Paths.privacyPolicy),
                  ),
                ],
              ),

              SizedBox(height: 18.h),

              // More Options Group
              SettingsSectionHeader(title: t.settings.moreOptions),
              SizedBox(height: 10.h),
              SettingsSectionCard(
                children: [
                  SettingsMenuItem(
                    icon: Icons.language_rounded,
                    title: t.settings.languages,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          LocaleSettings.currentLocale == AppLocale.ar
                              ? 'العربية'
                              : 'English',
                          style: context.medium14TextSub,
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: palette.textSub.withValues(alpha: 0.6),
                          size: 20.sp,
                        ),
                      ],
                    ),
                    onTap: () async {
                      await showSettingsLanguageBottomSheet(context);
                      if (mounted) setState(() {});
                    },
                  ),
                  SettingsSectionCard.buildDivider(context),
                  SettingsMenuItem(
                    icon: Icons.info_outline_rounded,
                    title: t.settings.buildVersion,
                    trailing: Text(
                      'v1.0.0',
                      style: context.regular14TextSub,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Log Out Button
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  final isLoading = authState.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  );

                  return SettingsLogoutButton(
                    isLoading: isLoading,
                    onTap: () => _handleLogout(context),
                  );
                },
              ),

              // Bottom Navigation Clearance (PatientShell extendBody)
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  UserModel? _resolveUser(BuildContext context, ProfileState state) {
    if (state is ProfileLoaded) return state.user;
    if (state is ProfileUpdating) return state.user;
    if (state is ProfileUpdateSuccess) return state.user;
    return context.read<ProfileCubit>().currentUser;
  }
}
