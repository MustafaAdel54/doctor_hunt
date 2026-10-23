import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/features/doctors/widgets/doctor_image.dart';
import 'package:doctor_hunt/features/favorites/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/features/favorites/cubit/favorites_state.dart';
import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:doctor_hunt/shared/utils/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class DoctorProfileCard extends StatelessWidget {
  final DoctorModel doctor;
  final String doctorId;

  const DoctorProfileCard({
    super.key,
    required this.doctor,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final locale = Localizations.localeOf(context).languageCode;
    final name = doctor.localizedName(locale);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: FigmaRaw.black.withValues(alpha: 0.08),
            blurRadius: 20.r,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Image (92w x 87h, rounded 8.r)
              Hero(
                tag: 'doctor_image_$doctorId',
                child: DoctorImage(
                  image: doctor.image,
                  width: 92.w,
                  height: 87.h,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(width: 14.w),

              // Details Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Favorite Heart
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: context.medium18TextMain,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        BlocBuilder<FavoritesCubit, FavoritesState>(
                          builder: (context, state) {
                            final isFav = state.isFavorite(doctorId);
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                final willBeFav = !isFav;
                                context
                                    .read<FavoritesCubit>()
                                    .toggleFavorite(doctorId);
                                AppSnackBar.showFavorite(context,
                                    isAdded: willBeFav);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(2.r),
                                child: AnimatedScale(
                                  scale: isFav ? 1.05 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOutBack,
                                  child: isFav
                                      ? SvgPicture.asset(
                                          ImageAssets.heartFilled,
                                          width: 19.w,
                                          height: 17.h,
                                        )
                                      : SvgPicture.asset(
                                          ImageAssets.heartOutline,
                                          width: 19.w,
                                          height: 17.h,
                                          colorFilter: const ColorFilter.mode(
                                            FigmaRaw.grey300,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),

                    // Specialization
                    Text(
                      doctor.specialization,
                      style: context.light14TextSub,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 8.h),

                    // Rating Stars and Hourly Rate
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 5 Stars
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (index) {
                            final isFilled = index < (doctor.rating > 0 ? doctor.rating.round() : 4);
                            return Padding(
                              padding: EdgeInsets.only(right: 2.w),
                              child: Icon(
                                Icons.star,
                                size: 13.sp,
                                color: isFilled ? FigmaRaw.amber500 : FigmaRaw.grey300,
                              ),
                            );
                          }),
                        ),

                        // Hourly Rate with Green Dollar
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: r'$ ',
                                style: TextStyle(
                                  color: FigmaRaw.green500,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Rubik',
                                ),
                              ),
                              TextSpan(
                                text: '${doctor.hourlyRate.toStringAsFixed(2)}/hr',
                                style: context.medium16TextMain,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Centered Book Now Button (140.w x 32.h, rounded 4.r)
          SizedBox(
            width: 140.w,
            height: 32.h,
            child: ElevatedButton(
              onPressed: () {
                context.pushNamed(
                  Routes.bookAppointment,
                  pathParameters: {'doctorId': doctorId},
                  extra: doctor,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FigmaRaw.green500,
                foregroundColor: FigmaRaw.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                padding: EdgeInsets.zero,
                elevation: 0,
              ),
              child: Text(
                t.doctors.bookNow,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: FigmaRaw.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
