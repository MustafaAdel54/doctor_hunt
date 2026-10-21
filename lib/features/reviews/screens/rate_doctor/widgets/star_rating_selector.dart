import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StarRatingSelector extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const StarRatingSelector({
    super.key,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starNumber = index + 1;
        final isFilled = starNumber <= rating;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onRatingChanged(starNumber),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Icon(
              isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
              color: isFilled
                  ? const Color(0xFFF6D060)
                  : palette.textSub.withValues(alpha: 0.3),
              size: 40.sp,
            ),
          ),
        );
      }),
    );
  }
}
