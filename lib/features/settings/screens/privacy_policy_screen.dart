import 'package:doctor_hunt/features/settings/screens/widgets/privacy_policy_bullet_item.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.surface,
      appBar: AppBar(
        backgroundColor: palette.surface,
        elevation: 0,
        centerTitle: false,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: Material(
            color: palette.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
              side: BorderSide(color: palette.textBorders.withValues(alpha: 0.5)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
              child: Icon(
                Icons.chevron_left_rounded,
                color: palette.textMain,
                size: 24.sp,
              ),
            ),
          ),
        ),
        title: Text(
          t.privacyPolicy.title,
          style: context.bold18TextMain,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.privacyPolicy.headline,
                style: context.bold18TextMain.copyWith(
                  color: palette.primary,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                t.privacyPolicy.paragraph1,
                style: context.regular14TextSub.copyWith(height: 1.6),
              ),
              SizedBox(height: 16.h),
              Text(
                t.privacyPolicy.paragraph2,
                style: context.regular14TextSub.copyWith(height: 1.6),
              ),
              SizedBox(height: 20.h),
              PrivacyPolicyBulletItem(text: t.privacyPolicy.bullet1),
              SizedBox(height: 12.h),
              PrivacyPolicyBulletItem(text: t.privacyPolicy.bullet2),
              SizedBox(height: 12.h),
              PrivacyPolicyBulletItem(text: t.privacyPolicy.bullet3),
              SizedBox(height: 12.h),
              PrivacyPolicyBulletItem(text: t.privacyPolicy.bullet4),
              SizedBox(height: 20.h),
              Text(
                t.privacyPolicy.paragraph3,
                style: context.regular14TextSub.copyWith(height: 1.6),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
