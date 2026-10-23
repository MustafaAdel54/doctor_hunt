import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';

class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Text(
      title,
      style: context.bold14TextSub.copyWith(
        color: palette.textSub.withValues(alpha: 0.8),
      ),
    );
  }
}
