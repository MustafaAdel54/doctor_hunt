import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../../../../generated/style_atoms.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.showLabel = true,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool showLabel;
  final String? Function(String?)? validator;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          Text(
            widget.label,
            style: context.bold.copyWith(color: palette.textMain),
          ),
          Gaps.h8,
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          validator: widget.validator,
          style: context.regular.copyWith(color: palette.textMain),
          decoration: InputDecoration(
            hintText: widget.hint ?? (widget.showLabel ? null : widget.label),
            hintStyle: context.regular.copyWith(color: palette.textPlaceholder),
            filled: true,
            fillColor: palette.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: palette.textSub,
              ),
              onPressed: _toggleVisibility,
              splashRadius: 24,
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
