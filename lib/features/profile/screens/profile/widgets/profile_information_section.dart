import 'package:doctor_hunt/features/auth/models/user_model.dart';
import 'package:doctor_hunt/features/profile/screens/profile/widgets/profile_information_card.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileInformationSection extends StatelessWidget {
  const ProfileInformationSection({
    super.key,
    required this.user,
    required this.onEdit,
  });

  final UserModel? user;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final nameValue = (user?.name != null && user!.name!.isNotEmpty)
        ? user!.name!
        : t.profile.notProvided;

    final phoneValue = (user?.phone != null && user!.phone!.isNotEmpty)
        ? user!.phone!
        : t.profile.notProvided;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 8.h),

            // Section Header: "Personal information" (Figma Node 1-506)
            Text(
              t.profile.personalInfo,
              style: context.bold18TextMain,
            ),

            SizedBox(height: 16.h),

            // Name Card (Figma Node 1-506)
            ProfileInformationCard(
              label: t.profile.name,
              value: nameValue,
              onTap: onEdit,
            ),

            SizedBox(height: 14.h),

            // Contact Number Card (Figma Node 1-506)
            ProfileInformationCard(
              label: t.profile.contactNumber,
              value: phoneValue,
              onTap: onEdit,
            ),

            SizedBox(height: 36.h),

            // "Continue" Button (Figma Node 1-506)
            ElevatedButton(
              onPressed: onEdit,
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: palette.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                t.profile.continueText,
                style: context.bold16White,
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
