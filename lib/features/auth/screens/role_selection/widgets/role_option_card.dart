import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoleOptionCard extends StatelessWidget {
  const RoleOptionCard({
    super.key,
    required this.title,
    required this.description,
    this.iconAsset,
    this.fallbackIcon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String description;
  final String? iconAsset;
  final IconData? fallbackIcon;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? palette.primary
                : palette.textBorders.withValues(alpha: 0.5),
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: palette.shadowSoft,
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Background
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? palette.primary.withValues(alpha: 0.1)
                        : palette.surface,
                    shape: BoxShape.circle,
                  ),
                  child: iconAsset != null
                      ? SvgPicture.asset(
                          iconAsset!,
                          width: 24.w,
                          height: 24.w,
                          colorFilter: ColorFilter.mode(
                            palette
                                .primary, // Using primary color for SVG icons
                            BlendMode.srcIn,
                          ),
                        )
                      : Icon(fallbackIcon, color: palette.primary, size: 24.sp),
                ),
                SizedBox(width: 16.w),
                // Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      Text(
                        title,
                        style: context.semiBold18TextMain,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        description,
                        style: context.regular14TextSub.copyWith(height: 1.4),
                      ),
                    ],
                  ),
                ),
                // Space for checkmark to avoid text overlap
                SizedBox(width: 32.w),
              ],
            ),

            // Checkmark aligned top-right
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: palette.primary,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(4.w),
                  child: Icon(Icons.check, color: palette.white, size: 16.sp),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
