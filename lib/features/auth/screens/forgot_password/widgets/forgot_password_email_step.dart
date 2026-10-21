import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:doctor_hunt/shared/utils/validators.dart';
import 'package:doctor_hunt/shared/widgets/app_text_field.dart';
import 'package:doctor_hunt/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'auth_bottom_sheet_wrapper.dart';

class ForgotPasswordEmailStep extends StatefulWidget {
  const ForgotPasswordEmailStep({
    super.key,
    required this.isLoading,
    required this.onContinue,
    this.initialEmail = '',
  });

  final bool isLoading;
  final ValueChanged<String> onContinue;
  final String initialEmail;

  @override
  State<ForgotPasswordEmailStep> createState() => _ForgotPasswordEmailStepState();
}

class _ForgotPasswordEmailStepState extends State<ForgotPasswordEmailStep> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onContinue(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthBottomSheetWrapper(
      title: t.auth.forgotPasswordTitle,
      subtitle: t.auth.forgotPasswordSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _emailController,
              label: t.auth.email,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
            ),
            SizedBox(height: 30.h),
            PrimaryButton(
              text: t.auth.continueText,
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
