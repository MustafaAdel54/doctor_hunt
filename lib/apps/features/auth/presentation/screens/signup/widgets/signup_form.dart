import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';
import 'package:doctor_hunt/apps/core/widgets/password_text_field.dart';
import 'package:doctor_hunt/apps/core/widgets/primary_button.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/i18n/strings.g.dart';
import '../../../cubit/auth_cubit.dart';

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

  void _onSubmit() {
    if (!_termsAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.auth.termsRequired)),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      // Creates only the Supabase Auth account. Role is chosen in Role Selection
      // after authentication, then createProfile writes the database document.
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
            validator: (v) =>
                v == null || v.isEmpty ? t.validation.required : null,
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _emailCtrl,
            label: t.auth.email,
            showLabel: false,
            hint: t.auth.email,
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
                v == null || v.isEmpty ? t.validation.required : null,
          ),
          SizedBox(height: 16.h),
          PasswordTextField(
            controller: _passCtrl,
            label: t.auth.password,
            showLabel: false,
            hint: t.auth.password,
            validator: (v) =>
                v == null || v.isEmpty ? t.validation.required : null,
          ),
          SizedBox(height: 16.h),

          // Terms Checkbox
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _termsAgreed = !_termsAgreed),
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: _termsAgreed ? palette.primary : palette.textBorders,
                    shape: BoxShape.circle,
                  ),
                  child: _termsAgreed
                      ? Icon(Icons.check, size: 14.sp, color: palette.white)
                      : null,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  t.auth.agreeTerms,
                  style: context.regular.copyWith(
                    color: palette.textSub,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 32.h),
          PrimaryButton(
            text: t.auth.register,
            onPressed: widget.isLoading ? null : _onSubmit,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}
