import 'package:doctor_hunt/features/auth/cubit/auth_cubit.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:doctor_hunt/shared/widgets/app_text_field.dart';
import 'package:doctor_hunt/shared/widgets/password_text_field.dart';
import 'package:doctor_hunt/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key, required this.isLoading});

  final bool isLoading;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _termsAgreed = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty) return t.validation.required;
    return null;
  }

  String? _validateEmail(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty) return t.validation.required;
    final emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+(\.[\w\-]+)+$');
    if (!emailRegex.hasMatch(v)) return t.validation.invalidEmail;
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return t.validation.required;
    if (value.length < 6) return t.validation.shortPassword(n: 6);
    return null;
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();
    if (!_termsAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.auth.termsRequired),
          backgroundColor: context.palette.danger,
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().registerWithEmailOnly(
        _emailCtrl.text.trim(),
        _passCtrl.text,
        _nameCtrl.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _nameCtrl,
            label: t.auth.name,
            showLabel: false,
            hint: t.auth.name,
            validator: _validateName,
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _emailCtrl,
            label: t.auth.email,
            showLabel: false,
            hint: t.auth.email,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          SizedBox(height: 16.h),
          PasswordTextField(
            controller: _passCtrl,
            label: t.auth.password,
            showLabel: false,
            hint: t.auth.password,
            validator: _validatePassword,
          ),
          SizedBox(height: 16.h),

          // Terms Checkbox (tap whole row to toggle)
          GestureDetector(
            onTap: () => setState(() => _termsAgreed = !_termsAgreed),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: _termsAgreed ? palette.primary : palette.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _termsAgreed ? palette.primary : palette.textBorders,
                      width: 1.5.w,
                    ),
                  ),
                  child: _termsAgreed
                      ? Icon(Icons.check, size: 14.sp, color: palette.white)
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    t.auth.agreeTerms,
                    style: context.regular12TextSub,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 32.h),
          PrimaryButton(
            text: t.auth.register,
            isLoading: widget.isLoading,
            onPressed: widget.isLoading ? null : _onSubmit,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}
