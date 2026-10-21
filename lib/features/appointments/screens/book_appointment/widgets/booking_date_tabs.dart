import 'package:doctor_hunt/features/appointments/cubit/booking_cubit.dart';
import 'package:doctor_hunt/features/appointments/cubit/booking_state.dart';
import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingDateTabs extends StatelessWidget {
  const BookingDateTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (prev, curr) =>
          prev.selectedDate != curr.selectedDate ||
          prev.availableDates != curr.availableDates,
      builder: (context, state) {
        return SizedBox(
          height: 64.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
            scrollDirection: Axis.horizontal,
            itemCount: state.availableDates.length,
            separatorBuilder: (_, __) => SizedBox(width: 14.w),
            itemBuilder: (context, index) {
              final item = state.availableDates[index];
              final isSelected = item.date.year == state.selectedDate.year &&
                  item.date.month == state.selectedDate.month &&
                  item.date.day == state.selectedDate.day;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  context.read<BookingCubit>().selectDate(item.date);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isSelected ? FigmaRaw.green500 : palette.surface,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: isSelected
                          ? FigmaRaw.green500
                          : palette.textSub.withValues(alpha: 0.15),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: FigmaRaw.green500.withValues(alpha: 0.25),
                              blurRadius: 10.r,
                              offset: Offset(0, 4.h),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          color: isSelected ? FigmaRaw.white : palette.textMain,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        item.hasSlots
                            ? t.appointments.slotsAvailable(count: item.slotsCount)
                            : t.appointments.noSlotsAvailable,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w300,
                          height: 1.2,
                          color: isSelected
                              ? FigmaRaw.white.withValues(alpha: 0.9)
                              : palette.textSub,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
