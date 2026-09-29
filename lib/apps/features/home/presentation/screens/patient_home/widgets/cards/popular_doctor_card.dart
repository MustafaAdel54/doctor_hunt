import 'package:flutter/material.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/apps/core/constants/app_constants.dart';
import '../../../../models/home_mock_data.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PopularDoctorCard extends StatelessWidget {
  const PopularDoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  final HomeDoctor doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 190,
        height: 264,
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: palette.shadowSoft,
              blurRadius: 40,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'doctor_image_${doctor.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.asset(
                  doctor.imageAsset,
                  width: 190,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 190,
                    height: 180,
                    color: palette.surfaceAlt,
                    child: Icon(
                      Icons.person,
                      color: palette.textPlaceholder,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      doctor.name,
                      style: context.medium18.copyWith(color: palette.textMain),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    if (doctor.specialization != null) ...[
                      Gaps.h4,
                      Text(
                        doctor.specialization!,
                        style: context.regular12.copyWith(
                          color: palette.textSub,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    Gaps.h4,
                    RatingBarIndicator(
                      rating: doctor.rating,
                      itemBuilder: (context, index) =>
                          Icon(Icons.star, color: context.palette.warning),
                      itemCount: 5,
                      itemSize: 12.0,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
