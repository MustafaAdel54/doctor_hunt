import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
              width: 18.w,
              height: 18.w,
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
              width: 18.w,
              height: 18.w,
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
    return Material(
      color: palette.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          height: 54.h,
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: palette.textBorders),
            boxShadow: [
              BoxShadow(
                color: palette.shadowSoft,
                blurRadius: 22.r,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(width: 12.w),
              Text(
                text,
                style: context.light16TextSub,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
