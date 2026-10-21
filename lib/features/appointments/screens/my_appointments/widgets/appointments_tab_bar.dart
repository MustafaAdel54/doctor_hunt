import 'package:doctor_hunt/features/appointments/cubit/appointments_cubit.dart';
import 'package:doctor_hunt/features/appointments/cubit/appointments_state.dart';
import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentsTabBar extends StatelessWidget {
  const AppointmentsTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      buildWhen: (prev, curr) => prev.selectedTab != curr.selectedTab,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTab(
                context,
                title: t.appointments.upcoming,
                tab: AppointmentTab.upcoming,
                isSelected: state.selectedTab == AppointmentTab.upcoming,
              ),
              _buildTab(
                context,
                title: t.appointments.completed,
                tab: AppointmentTab.completed,
                isSelected: state.selectedTab == AppointmentTab.completed,
              ),
              _buildTab(
                context,
                title: t.appointments.cancelled,
                tab: AppointmentTab.cancelled,
                isSelected: state.selectedTab == AppointmentTab.cancelled,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String title,
    required AppointmentTab tab,
    required bool isSelected,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.read<AppointmentsCubit>().switchTab(tab);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 106.w,
        height: 38.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? FigmaRaw.green500
              : const Color(0xFFE8F8F3),
          borderRadius: BorderRadius.circular(6.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: FigmaRaw.green500.withValues(alpha: 0.25),
                    blurRadius: 8.r,
                    offset: Offset(0, 3.h),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? FigmaRaw.white : FigmaRaw.green500,
          ),
        ),
      ),
    );
  }
}
