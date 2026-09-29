import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/i18n/strings.g.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class SignupFooter extends StatelessWidget {
  const SignupFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 24.h),
          child: TextButton(
            onPressed: () => context.go(Paths.login),
            child: Text(
              "${t.auth.haveAccount} ${t.auth.login}",
              style: context.semiBold14Primary,
            ),
          ),
        ),
      ),
    );
  }
}
