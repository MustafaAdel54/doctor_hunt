import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/i18n/strings.g.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Expanded(
      child: Column(
        children: [
          TextButton(
            onPressed: () => context.push(Paths.forgotPassword),
            child: Text(
              t.auth.forgotPassword,
              style: context.semiBold14Primary,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => context.push(Paths.register),
            child: Text(
              "${t.auth.noAccount} Join us",
              style: context.semiBold14Primary,
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
