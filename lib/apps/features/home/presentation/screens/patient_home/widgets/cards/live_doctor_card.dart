import 'package:flutter/material.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import '../../../../models/home_mock_data.dart';

class LiveDoctorCard extends StatelessWidget {
  const LiveDoctorCard({super.key, required this.doctor, required this.onTap});

  final HomeDoctor doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 116,
        height: 168,
        child: Stack(
          children: [
            // Background Image
            Hero(
              tag: 'doctor_image_${doctor.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  doctor.imageAsset,
                  width: 116,
                  height: 168,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 116,
                    height: 168,
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

            // Dark Overlay for better contrast
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: palette.black.withValues(alpha: 0.2),
              ),
            ),

            // LIVE Badge
            if (doctor.isLive)
              Positioned(
                top: 11,
                right: 11,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: palette.danger,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: palette.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'LIVE',
                        style: context.medium8.copyWith(
                          color: palette.white,
                          fontSize: 7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Play Button
            Center(
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: palette.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: palette.primary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
