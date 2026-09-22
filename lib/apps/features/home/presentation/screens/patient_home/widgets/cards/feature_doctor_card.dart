import 'package:flutter/material.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/apps/core/constants/app_constants.dart';
import '../../../../models/home_mock_data.dart';

class FeatureDoctorCard extends StatelessWidget {
  const FeatureDoctorCard({
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
        width: 96,
        height: 130,
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: palette.shadowSoft,
              blurRadius: 20,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Gaps.h16,
                Center(
                  child: Hero(
                    tag: 'doctor_image_${doctor.id}',
                    child: ClipOval(
                      child: Image.asset(
                        doctor.imageAsset,
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 54,
                          height: 54,
                          color: palette.surfaceAlt,
                          child: Icon(
                            Icons.person,
                            color: palette.textPlaceholder,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Gaps.h8,
                Text(
                  doctor.name,
                  style: context.medium12.copyWith(color: palette.textMain),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                if (doctor.hourlyRate != null) ...[
                  Gaps.h4,
                  Text(
                    doctor.hourlyRate!,
                    style: context.light8.copyWith(
                      color: palette.primary,
                      fontSize: 9,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
            // Rating badge (top left)
            Positioned(
              top: 8,
              left: 8,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 10),
                  const SizedBox(width: 2),
                  Text(
                    doctor.rating.toStringAsFixed(1),
                    style: context.regular12.copyWith(
                      color: palette.textSub,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            // Favorite icon (top right)? Wait, I don't see one in Figma structure but usually there is.
            // Actually, there's a heart icon inside the feature doctor group in Figma? Let's skip it unless needed.
          ],
        ),
      ),
    );
  }
}
