import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SignupFooter extends StatelessWidget {
  const SignupFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Center(
        child: TextButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Paths.login);
            }
          },
          child: Text(
            "${t.auth.haveAccount} ${t.auth.login}",
            style: context.semiBold14Primary,
          ),
        ),
      ),
    );
  }
}
