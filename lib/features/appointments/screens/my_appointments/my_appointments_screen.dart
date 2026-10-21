import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/features/appointments/cubit/appointments_cubit.dart';
import 'package:doctor_hunt/features/appointments/cubit/appointments_state.dart';
import 'package:doctor_hunt/features/appointments/models/appointment_model.dart';
import 'package:doctor_hunt/features/home/screens/popular_doctors/widgets/popular_doctors_background_glow.dart';
import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/appointment_card.dart';
import 'widgets/appointments_empty_state.dart';
import 'widgets/appointments_header.dart';
import 'widgets/appointments_tab_bar.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: sl<AppointmentsCubit>().state.selectedTab.index,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return BlocProvider.value(
      value: sl<AppointmentsCubit>(),
      child: Builder(
        builder: (context) {
          return BlocConsumer<AppointmentsCubit, AppointmentsState>(
            listenWhen: (prev, curr) =>
                prev.selectedTab != curr.selectedTab ||
                prev.errorMessage != curr.errorMessage,
            listener: (context, state) {
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: palette.danger,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }

              // Synchronize page view when tab is tapped
              final targetIndex = state.selectedTab.index;
              if (_pageController.hasClients &&
                  _pageController.page?.round() != targetIndex) {
                _pageController.animateToPage(
                  targetIndex,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                );
              }
            },
            builder: (context, state) {
              return Scaffold(
                backgroundColor: palette.surface,
                body: Stack(
                  children: [
                    const PopularDoctorsBackgroundGlow(),
                    SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header (Back button + "Appointments" title)
                          const AppointmentsHeader(),

                          SizedBox(height: 8.h),

                          // Segmented 3-tab bar
                          const AppointmentsTabBar(),

                          SizedBox(height: 14.h),

                          // Tab Content with PageView for smooth animated transitions
                          Expanded(
                            child: PageView(
                              controller: _pageController,
                              physics: const BouncingScrollPhysics(),
                              onPageChanged: (index) {
                                final tab = AppointmentTab.values[index];
                                context.read<AppointmentsCubit>().switchTab(tab);
                              },
                              children: [
                                _buildTabList(
                                  context: context,
                                  state: state,
                                  tab: AppointmentTab.upcoming,
                                  items: state.upcomingAppointments,
                                ),
                                _buildTabList(
                                  context: context,
                                  state: state,
                                  tab: AppointmentTab.completed,
                                  items: state.completedAppointments,
                                ),
                                _buildTabList(
                                  context: context,
                                  state: state,
                                  tab: AppointmentTab.cancelled,
                                  items: state.cancelledAppointments,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTabList({
    required BuildContext context,
    required AppointmentsState state,
    required AppointmentTab tab,
    required List<AppointmentModel> items,
  }) {
    if (state.isLoading && state.appointments.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: FigmaRaw.green500,
        ),
      );
    }

    if (items.isEmpty) {
      return RefreshIndicator(
        color: FigmaRaw.green500,
        onRefresh: () async {
          await context
              .read<AppointmentsCubit>()
              .loadAppointments(isSilent: true);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: SizedBox(
            height: 0.65.sh,
            child: AppointmentsEmptyState(tab: tab),
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: FigmaRaw.green500,
      onRefresh: () async {
        await context
            .read<AppointmentsCubit>()
            .loadAppointments(isSilent: true);
      },
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final item = items[index];
          return AppointmentCard(
            key: ValueKey(item.id),
            appointment: item,
            tab: tab,
          );
        },
      ),
    );
  }
}
