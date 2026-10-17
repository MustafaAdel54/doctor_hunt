import 'package:doctor_hunt/shared/constants/app_constants.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.inbox,
    this.onRetry,
    this.retryText,
  });

  final String message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? retryText;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64.sp, color: palette.textPlaceholder),
            Gaps.h16,
            Text(
              message,
              style: context.medium16TextSub,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              Gaps.h24,
              TextButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh, size: 20.sp),
                label: Text(
                  retryText ?? t.common.retry,
                  style: context.medium14Primary,
                ),
                style: TextButton.styleFrom(foregroundColor: palette.primary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
