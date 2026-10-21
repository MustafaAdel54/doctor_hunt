import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:doctor_hunt/shared/utils/validators.dart';
import 'package:doctor_hunt/shared/widgets/password_text_field.dart';
import 'package:doctor_hunt/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'auth_bottom_sheet_wrapper.dart';

class ForgotPasswordResetStep extends StatefulWidget {
  const ForgotPasswordResetStep({
    super.key,
    required this.isLoading,
    required this.onUpdatePassword,
  });

  final bool isLoading;
  final ValueChanged<String> onUpdatePassword;

  @override
  State<ForgotPasswordResetStep> createState() => _ForgotPasswordResetStepState();
}

class _ForgotPasswordResetStepState extends State<ForgotPasswordResetStep> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onUpdatePassword(_newPasswordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthBottomSheetWrapper(
      title: t.auth.resetPasswordTitle,
      subtitle: t.auth.resetPasswordSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PasswordTextField(
              controller: _newPasswordController,
              label: t.auth.newPassword,
              validator: Validators.password,
            ),
            SizedBox(height: 16.h),
            PasswordTextField(
              controller: _confirmPasswordController,
              label: t.auth.reenterPassword,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Please re-enter your password';
                }
                if (val != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: 24.h),
            PrimaryButton(
              text: t.auth.updatePassword,
              isLoading: widget.isLoading,
              onPressed: widget.isLoading ? null : _submit,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
