import 'package:doctor_hunt/features/home/models/home_mock_data.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PopularDoctorListCard extends StatefulWidget {
  final HomeDoctor doctor;
  final VoidCallback onTap;

  const PopularDoctorListCard({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  @override
  State<PopularDoctorListCard> createState() => _PopularDoctorListCardState();
}

class _PopularDoctorListCardState extends State<PopularDoctorListCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.doctor.isFavorite;
  }

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
          onTap: widget.onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Doctor Photo
                Hero(
                  tag: 'doctor_image_${widget.doctor.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.asset(
                      widget.doctor.imageAsset,
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
                              widget.doctor.name,
                              style: context.medium18TextMain.copyWith(
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setState(() {
                                _isFavorite = !_isFavorite;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: _isFavorite
                                  ? SvgPicture.asset(
                                      ImageAssets.heartFilled,
                                      width: 19.w,
                                      height: 17.h,
                                    )
                                  : SvgPicture.asset(
                                      ImageAssets.heartOutline,
                                      width: 19.w,
                                      height: 17.h,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      if (widget.doctor.specialization != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          widget.doctor.specialization!,
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
                            rating: widget.doctor.rating,
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
                                    text: '${widget.doctor.rating.toStringAsFixed(1)} ',
                                    style: context.semiBold14TextMain,
                                  ),
                                  if (widget.doctor.viewsCount != null)
                                    TextSpan(
                                      text: t.doctors.viewsCount(count: widget.doctor.viewsCount.toString()),
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
