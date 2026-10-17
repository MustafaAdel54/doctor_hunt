import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/features/auth/cubit/auth_cubit.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:doctor_hunt/shared/widgets/app_text_field.dart';
import 'package:doctor_hunt/shared/widgets/password_text_field.dart';
import 'package:doctor_hunt/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
          SizedBox(height: 32.h),
          PrimaryButton(
            text: t.auth.login,
            isLoading: widget.isLoading,
            onPressed: widget.isLoading ? null : _onSubmit,
            isFullWidth: true,
          ),
          SizedBox(height: 12.h),
          Center(
            child: TextButton(
              onPressed: () => context.push(Paths.forgotPassword),
              child: Text(
                t.auth.forgotPassword,
                style: context.semiBold14Primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
