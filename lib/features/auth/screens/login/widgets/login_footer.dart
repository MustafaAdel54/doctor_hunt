import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Center(
        child: TextButton(
          onPressed: () => context.push(Paths.register),
          child: Text(
            "${t.auth.noAccount} ${t.auth.joinUs}",
            style: context.semiBold14Primary,
          ),
        ),
      ),
    );
  }
}
