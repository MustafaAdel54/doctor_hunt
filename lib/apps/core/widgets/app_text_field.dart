import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../../../../generated/style_atoms.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.showLabel = true,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool showLabel;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(label, style: context.bold.copyWith(color: palette.textMain)),
          Gaps.h8,
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: context.regular.copyWith(color: palette.textMain),
          decoration: InputDecoration(
            hintText: hint ?? (showLabel ? null : label),
            hintStyle: context.regular.copyWith(color: palette.textPlaceholder),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: palette.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: palette.textBorders),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: palette.textBorders),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: palette.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: palette.danger),
            ),
          ),
        ),
      ],
    );
  }
}
