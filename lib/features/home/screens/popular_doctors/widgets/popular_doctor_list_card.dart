import 'package:doctor_hunt/features/favorites/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/features/favorites/cubit/favorites_state.dart';
import 'package:doctor_hunt/features/home/models/home_mock_data.dart';
import 'package:doctor_hunt/shared/generated/app_colors.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:doctor_hunt/shared/utils/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PopularDoctorListCard extends StatelessWidget {
  final HomeDoctor doctor;
  final VoidCallback onTap;

  const PopularDoctorListCard({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 104.h),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: palette.shadowSoft,
            blurRadius: 20.r,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Material(
        color: palette.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Doctor Photo
                Hero(
                  tag: 'doctor_image_${doctor.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.asset(
                      doctor.imageAsset,
                      width: 82.w,
                      height: 82.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 82.w,
                        height: 82.h,
                        color: palette.surfaceAlt,
                        child: Icon(
                          Icons.person,
                          color: palette.textPlaceholder,
                          size: 32.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                // Doctor Info & Rating
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Name and Heart Button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              doctor.name,
                              style: context.medium18TextMain.copyWith(
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          BlocBuilder<FavoritesCubit, FavoritesState>(
                            builder: (context, state) {
                              final isFav = state.isFavorite(doctor.id);
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  final willBeFav = !isFav;
                                  context
                                      .read<FavoritesCubit>()
                                      .toggleFavorite(doctor.id);
                                  AppSnackBar.showFavorite(context,
                                      isAdded: willBeFav);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 2.h),
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
                      if (doctor.specialization != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          doctor.specialization!,
                          style: context.light14TextSub.copyWith(
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      SizedBox(height: 8.h),
                      // Rating Bar & Views
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: doctor.rating,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: palette.warning,
                            ),
                            unratedColor: palette.textBorders,
                            itemCount: 5,
                            itemSize: 13.sp,
                            direction: Axis.horizontal,
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '${doctor.rating.toStringAsFixed(1)} ',
                                    style: context.semiBold14TextMain,
                                  ),
                                  if (doctor.viewsCount != null)
                                    TextSpan(
                                      text: t.doctors.viewsCount(
                                          count: doctor.viewsCount.toString()),
                                      style: context.light12TextSub,
                                    ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
