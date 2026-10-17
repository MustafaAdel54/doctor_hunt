import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.icons,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<IconData> icons;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: palette.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: palette.black.withValues(alpha: 0.1),
            blurRadius: 20.r,
            offset: Offset(0, -5.h),
          ),
        ],
      ),
      child: SizedBox(
        height: 80.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(icons.length, (index) {
            final isSelected = currentIndex == index;
            return _buildNavItem(context, index, icons[index], isSelected);
          }),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    bool isSelected,
  ) {
    final palette = context.palette;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? palette.primary : palette.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? palette.white : palette.textSub,
          size: 26.sp,
        ),
      ),
    );
  }
}
