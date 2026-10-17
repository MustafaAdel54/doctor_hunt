import 'package:doctor_hunt/shared/constants/app_constants.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final userName =
        Supabase.instance.client.auth.currentUser?.userMetadata?['name']
            as String? ??
        t.home.defaultUser;

    return Container(
      width: double.infinity,
      height: 156.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30.r),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.primary,
            palette.primaryDark,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background circles (bg group in Figma)
          Positioned(
            top: 0,
            left: -30.w,
            child: Container(
              width: 216.w,
              height: 216.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -50.h,
            right: -30.w,
            child: Container(
              width: 242.w,
              height: 242.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 40.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      t.home.greeting(name: userName),
                      style: context.regular20White.copyWith(
                        color: palette.white.withValues(alpha: 0.7),
                      ),
                    ),
                    Gaps.h4,
                    Text(
                      t.doctors.title,
                      style: context.bold24White,
                    ),
                  ],
                ),
                ClipOval(
                  child: Image.asset(
                    ImageAssets.avatar,
                    width: 60.w,
                    height: 60.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60.w,
                      height: 60.h,
                      color: palette.white.withValues(alpha: 0.24),
                      child: Icon(
                        Icons.person,
                        color: palette.white,
                        size: 30.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
