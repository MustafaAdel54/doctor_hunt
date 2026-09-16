import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/i18n/strings.g.dart';

class AuthSocialButtons extends StatelessWidget {
  const AuthSocialButtons({
    super.key,
    this.isLoading = false,
    required this.onGooglePressed,
    required this.onFacebookPressed,
  });

  final bool isLoading;
  final VoidCallback onGooglePressed;
  final VoidCallback onFacebookPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SocialButton(
            text: t.auth.google,
            icon: SvgPicture.asset(
              'assets/icons/google_icon.svg',
              width: 24.w,
              height: 24.w,
            ),
            onPressed: isLoading ? null : onGooglePressed,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _SocialButton(
            text: t.auth.facebook,
            icon: SvgPicture.asset(
              'assets/icons/facebook_icon.svg',
              width: 24.w,
              height: 24.w,
            ),
            onPressed: isLoading ? null : onFacebookPressed,
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  final String text;
  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: palette.shadowSoft,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(width: 8.w),
            Text(
              text,
              style: context.semiBold.copyWith(
                color: palette.textMain,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
