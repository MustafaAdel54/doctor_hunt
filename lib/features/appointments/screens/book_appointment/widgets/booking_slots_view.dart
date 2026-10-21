import 'package:doctor_hunt/features/appointments/cubit/booking_cubit.dart';
import 'package:doctor_hunt/features/appointments/cubit/booking_state.dart';
import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingSlotsView extends StatelessWidget {
  final String dateHeading;

  const BookingSlotsView({
    super.key,
    required this.dateHeading,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 14.h),

              // Centered Selected Date Heading
              Center(
                child: Text(
                  dateHeading,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: context.palette.textMain,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 20.h),

              // Afternoon Slots Section
              if (state.afternoonSlots.isNotEmpty) ...[
                Text(
                  t.appointments.afternoonSlots(count: state.afternoonSlots.length),
                  style: context.medium16TextMain,
                ),
                SizedBox(height: 12.h),
                _buildSlotGrid(context, state.afternoonSlots, state.selectedSlot),
                SizedBox(height: 24.h),
              ],

              // Evening Slots Section
              if (state.eveningSlots.isNotEmpty) ...[
                Text(
                  t.appointments.eveningSlots(count: state.eveningSlots.length),
                  style: context.medium16TextMain,
                ),
                SizedBox(height: 12.h),
                _buildSlotGrid(context, state.eveningSlots, state.selectedSlot),
                SizedBox(height: 20.h),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSlotGrid(
    BuildContext context,
    List<String> slots,
    String? selectedSlot,
  ) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: slots.map((slot) {
        final isSelected = slot == selectedSlot;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            context.read<BookingCubit>().selectSlot(slot);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            width: 76.w,
            height: 40.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? FigmaRaw.green500
                  : FigmaRaw.green500.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6.r),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: FigmaRaw.green500.withValues(alpha: 0.3),
                        blurRadius: 8.r,
                        offset: Offset(0, 3.h),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              slot,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? FigmaRaw.white : FigmaRaw.green500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
