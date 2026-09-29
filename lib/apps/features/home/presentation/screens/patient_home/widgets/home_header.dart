import 'package:flutter/material.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/apps/core/constants/app_constants.dart';
import 'package:doctor_hunt/generated/image_assets.dart';
import 'package:doctor_hunt/i18n/strings.g.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      height: 156,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20),
        ), // Based on typical designs, though figma didn't explicitly show radius, usually there's a slight radius. Let me omit it for now if it's 0 in Figma.
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.primary,
            palette
                .primaryDark, // Or hardcode #0EBE7E and #07D9AD if strictly required, but palette is safer for dark mode. Let's use palette.
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background circles (bg group in Figma)
          Positioned(
            top: 0,
            left: -30,
            child: Container(
              width: 216,
              height: 216,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -30,
            child: Container(
              width: 242,
              height: 242,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      t.home.greeting(name: 'Handwerker'), // FLAG: No profile plumbing available. Wiring default name.
                      style: context.regular20.copyWith(color: palette.white.withValues(alpha: 0.7)),
                    ),
                    Gaps.h4,
                    Text(
                      t.doctors.title,
                      style: context.bold24.copyWith(color: palette.white),
                    ),
                  ],
                ),
                ClipOval(
                  child: Image.asset(
                    ImageAssets.avatar,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: palette.white.withValues(alpha: 0.24),
                      child: Icon(
                        Icons.person,
                        color: palette.white,
                        size: 30,
                      ),
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
