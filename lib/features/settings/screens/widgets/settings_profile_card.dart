import 'package:doctor_hunt/features/auth/models/user_model.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsProfileCard extends StatelessWidget {
  const SettingsProfileCard({
    super.key,
    required this.user,
    required this.sessionEmail,
    required this.fallbackName,
    required this.onTap,
  });

  final UserModel? user;
  final String sessionEmail;
  final String fallbackName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final displayName = (user?.name != null && user!.name!.isNotEmpty)
        ? user!.name!
        : fallbackName.isNotEmpty
            ? fallbackName
            : t.home.defaultUser;

    final displayEmail = (user?.email != null && user!.email.isNotEmpty)
        ? user!.email
        : sessionEmail;

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: palette.textBorders.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: palette.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: palette.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                _buildAvatar(context, user?.photoUrl),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: context.bold16TextMain,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        displayEmail,
                        style: context.regular12TextSub,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: palette.textSub.withValues(alpha: 0.6),
                  size: 24.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String? photoUrl) {
    final palette = context.palette;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 26.r,
        backgroundImage: NetworkImage(photoUrl),
        backgroundColor: palette.surfaceAlt,
      );
    }
    return CircleAvatar(
      radius: 26.r,
      backgroundImage: const AssetImage(ImageAssets.avatar),
      backgroundColor: palette.surfaceAlt,
    );
  }
}
