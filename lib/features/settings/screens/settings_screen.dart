import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/features/auth/cubit/auth_cubit.dart';
import 'package:doctor_hunt/features/auth/cubit/auth_state.dart';
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
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  Future<void> _showLogoutDialog(BuildContext context) async {
    final palette = context.palette;
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          t.settings.signOut,
          style: dialogCtx.bold18TextMain,
        ),
        content: Text(
          t.common.confirm,
          style: dialogCtx.regular14TextSub,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(
              t.common.cancel,
              style: dialogCtx.medium14TextSub,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: palette.danger,
              foregroundColor: palette.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: Text(
              t.settings.signOut,
              style: dialogCtx.bold14White,
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
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
        centerTitle: true,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
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
        builder: (context, state) {
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Language Selection Tile
                Container(
                  decoration: BoxDecoration(
                    color: palette.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: palette.textBorders),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.language_rounded,
                      color: palette.primary,
                      size: 22.sp,
                    ),
                    title: Text(
                      t.settings.language,
                      style: context.medium14TextMain,
                    ),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<AppLocale>(
                        value: LocaleSettings.currentLocale,
                        items: const [
                          DropdownMenuItem(
                            value: AppLocale.en,
                            child: Text('English'),
                          ),
                          DropdownMenuItem(
                            value: AppLocale.ar,
                            child: Text('العربية'),
                          ),
                        ],
                        onChanged: (newLocale) {
                          if (newLocale != null) {
                            LocaleSettings.setLocale(newLocale);
                          }
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Log Out Button
                Material(
                  color: palette.transparent,
                  child: InkWell(
                    onTap: isLoading ? null : () => _showLogoutDialog(context),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Ink(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: palette.danger.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: palette.danger.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isLoading)
                            SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.w,
                                color: palette.danger,
                              ),
                            )
                          else ...[
                            Icon(
                              Icons.logout_rounded,
                              color: palette.danger,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              t.settings.signOut,
                              style: context.bold14Danger,
                            ),
                          ],
                        ],
                      ),
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
