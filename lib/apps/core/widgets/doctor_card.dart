import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../../../../generated/style_atoms.dart';
import '../../features/doctors/data/models/doctor_model.dart';
import '../../../i18n/strings.g.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
    this.onBookTap,
  });

  final DoctorModel doctor;
  final VoidCallback onTap;
  final VoidCallback? onBookTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final locale = TranslationProvider.of(context).locale.name;

    final name = doctor.name[locale] ?? doctor.name.values.firstOrNull ?? '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: palette.textBorders),
          boxShadow: [
            BoxShadow(
              color: palette.shadowSoft,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                color: palette.primary.withValues(alpha: 0.1),
                image: doctor.image != null
                    ? DecorationImage(
                        image: NetworkImage(doctor.image!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: doctor.image == null
                  ? Icon(Icons.person, color: palette.primary, size: 40)
                  : null,
            ),
            Gaps.w16,
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: context.bold.copyWith(color: palette.textMain),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gaps.h4,
                  Text(
                    doctor.specialization,
                    style: context.regular.copyWith(color: palette.textSub),
                  ),
                  Gaps.h8,
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Gaps.w4,
                      Text(
                        doctor.rating.toStringAsFixed(1),
                        style: context.medium.copyWith(color: palette.textMain),
                      ),
                      Gaps.w12,
                      Icon(
                        Icons.work_history,
                        color: palette.primary,
                        size: 16,
                      ),
                      Gaps.w4,
                      Text(
                        t.doctors.experience(n: doctor.yearsExperience),
                        style: context.medium.copyWith(color: palette.textSub),
                      ),
                    ],
                  ),
                  if (onBookTap != null) ...[
                    Gaps.h12,
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onBookTap,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: palette.primary,
                          side: BorderSide(color: palette.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        child: Text(t.doctors.bookNow),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
