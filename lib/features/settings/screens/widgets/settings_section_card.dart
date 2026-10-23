import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsSectionCard extends StatelessWidget {
  const SettingsSectionCard({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  static Widget buildDivider(BuildContext context) {
    final palette = context.palette;
    return Divider(
      height: 1,
      thickness: 1,
      indent: 64.w,
      endIndent: 16.w,
      color: palette.textBorders.withValues(alpha: 0.25),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: palette.textBorders.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: palette.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
