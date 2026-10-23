import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - 40.h)
      ..quadraticBezierTo(
        size.width / 2,
        size.height + 25.h,
        size.width,
        size.height - 40.h,
      )
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.title,
    this.photoUrl,
    this.onBack,
    this.onCameraTap,
  });

  final String title;
  final String? photoUrl;
  final VoidCallback? onBack;
  final VoidCallback? onCameraTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final headerHeight = 220.h;
    final avatarRadius = 55.r;

    return SizedBox(
      height: headerHeight + avatarRadius,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Green Curved Background (Figma Node 1-506)
          ClipPath(
            clipper: CurvedHeaderClipper(),
            child: Container(
              height: headerHeight,
              width: double.infinity,
              color: palette.primary,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        color: palette.white.withValues(alpha: 0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.r),
                          onTap: onBack ??
                              () {
                                if (context.canPop()) {
                                  context.pop();
                                }
                              },
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Icon(
                              Icons.chevron_left_rounded,
                              color: palette.white,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.h, right: 40.w),
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: context.bold18White,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Circular Avatar Overlapping the Curve
          Positioned(
            bottom: 0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: palette.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: palette.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: palette.surfaceAlt,
                    backgroundImage: (photoUrl != null && photoUrl!.isNotEmpty)
                        ? NetworkImage(photoUrl!) as ImageProvider
                        : const AssetImage(ImageAssets.avatar),
                  ),
                ),

                // Camera Badge Icon (Figma Node 1-506)
                Positioned(
                  right: 4.w,
                  bottom: 4.h,
                  child: Material(
                    color: palette.primary,
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onCameraTap,
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: palette.white,
                          size: 18.sp,
                        ),
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
