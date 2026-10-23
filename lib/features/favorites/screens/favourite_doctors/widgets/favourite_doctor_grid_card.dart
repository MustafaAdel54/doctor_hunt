import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/features/doctors/widgets/doctor_image.dart';
import 'package:doctor_hunt/features/favorites/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/features/favorites/cubit/favorites_state.dart';
import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/utils/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class FavouriteDoctorGridCard extends StatelessWidget {
  const FavouriteDoctorGridCard({
    super.key,
    required this.doctor,
  });

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final locale = Localizations.localeOf(context).languageCode;
    final doctorName = doctor.localizedName(locale);

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: palette.shadowSoft,
            blurRadius: 20.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Material(
        color: palette.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: () {
            context.pushNamed(
              Routes.doctorDetails,
              pathParameters: {'doctorId': doctor.id},
              extra: doctor,
            );
          },
          child: Stack(
            children: [
              // Heart Toggle Button (Top Right)
              Positioned(
                top: 10.h,
                right: 10.w,
                child: BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, state) {
                    final isFav = state.isFavorite(doctor.id);
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        final willBeFav = !isFav;
                        context.read<FavoritesCubit>().toggleFavorite(doctor.id);
                        AppSnackBar.showFavorite(context, isAdded: willBeFav);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(4.r),
                        child: AnimatedScale(
                          scale: isFav ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutBack,
                          child: isFav
                              ? SvgPicture.asset(
                                  ImageAssets.heartFilled,
                                  width: 17.w,
                                  height: 15.h,
                                )
                              : SvgPicture.asset(
                                  ImageAssets.heartOutline,
                                  width: 17.w,
                                  height: 15.h,
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
              ),

              // Doctor Info (Centered)
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 18.h, 12.w, 12.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Doctor Avatar
                    DoctorImage(
                      image: doctor.image,
                      width: 84.r,
                      height: 84.r,
                      shape: BoxShape.circle,
                    ),
                    SizedBox(height: 10.h),
                    // Doctor Name
                    Text(
                      doctorName,
                      style: context.medium16TextMain,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),
                    // Doctor Specialization
                    if (doctor.specialization.isNotEmpty)
                      Text(
                        doctor.specialization,
                        style: context.regular12Primary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
