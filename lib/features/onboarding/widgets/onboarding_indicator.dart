import 'package:doctor_hunt/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({super.key, required this.pageCount});

  final int pageCount;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, currentIndex) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            pageCount,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              height: 8.h,
              width: currentIndex == index ? 24.w : 8.w,
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? palette.primary
                    : palette.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        );
      },
    );
  }
}
