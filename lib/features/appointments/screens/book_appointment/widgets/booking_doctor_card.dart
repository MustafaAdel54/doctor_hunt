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

class BookingDoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final String doctorId;

  const BookingDoctorCard({
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
      padding: EdgeInsets.all(10.w),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Doctor Image (72w x 68h, rounded 8.r)
          DoctorImage(
            image: doctor.image,
            width: 72.w,
            height: 68.h,
            borderRadius: BorderRadius.circular(8.r),
          ),
          SizedBox(width: 12.w),

          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name and Heart
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: context.medium16TextMain,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
                  ],
                ),

                SizedBox(height: 2.h),

                // Specialization / Clinic
                Text(
                  doctor.specialization,
                  style: context.regular12TextSub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 6.h),

                // 5 Stars Rating
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    final isFilled = index < (doctor.rating > 0 ? doctor.rating.round() : 4);
                    return Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: Icon(
                        Icons.star,
                        size: 11.sp,
                        color: isFilled ? FigmaRaw.amber500 : FigmaRaw.grey300,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
