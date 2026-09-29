import 'package:flutter/material.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/apps/core/constants/app_constants.dart';
import 'package:doctor_hunt/apps/features/doctors/data/models/doctor_model.dart';

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
    final name = doctor.name[locale] ?? doctor.name.values.first;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: palette.shadowSoft,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Image with Hero
          Hero(
            tag: 'doctor_image_$doctorId',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: doctor.image != null
                  ? Image.network(
                      doctor.image!,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 90,
                        height: 90,
                        color: palette.primary.withValues(alpha: 0.1),
                        child: Icon(Icons.person, color: palette.primary, size: 40),
                      ),
                    )
                  : Container(
                      width: 90,
                      height: 90,
                      color: palette.primary.withValues(alpha: 0.1),
                      child: Icon(Icons.person, color: palette.primary, size: 40),
                    ),
            ),
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: context.medium18.copyWith(
                          color: palette.textMain,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.favorite, color: palette.danger, size: 24),
                  ],
                ),
                Gaps.h4,

                // Specialization
                Text(
                  doctor.specialization,
                  style: context.regular12.copyWith(color: palette.textSub),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gaps.h8,

                // Rating and Hourly Rate
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                          color: palette.textBorders,
                          size: 16,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '\$',
                          style: context.medium14.copyWith(
                            color: palette.primary,
                          ),
                        ),
                        Text(
                          ' ${doctor.hourlyRate.toStringAsFixed(2)}/hr',
                          style: context.regular14.copyWith(
                            color: palette.textSub,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Gaps.h12,

                // Book Now Button
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/patient/doctor/$doctorId/book');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: palette.primary,
                      foregroundColor: palette.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                    ),
                    child: Text(
                      'Book Now',
                      style: context.medium14.copyWith(color: palette.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
