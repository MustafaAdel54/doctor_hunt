import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/i18n/strings.g.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';
import 'package:doctor_hunt/apps/core/widgets/password_text_field.dart';
import 'package:doctor_hunt/apps/core/widgets/primary_button.dart';
import '../../../cubit/auth_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.isLoading});

  final bool isLoading;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().loginWithEmail(
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _emailCtrl,
            label: t.auth.email,
            showLabel: false,
            hint: t.auth.email,
            keyboardType: TextInputType.emailAddress,
            // Explicitly not adding a suffixIcon checkmark based on rules.
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
          SizedBox(height: 40.h),
          PrimaryButton(
            text: t.auth.login,
            onPressed: widget.isLoading ? null : _onSubmit,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}
