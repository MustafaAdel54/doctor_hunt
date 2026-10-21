import 'dart:async';

import 'package:doctor_hunt/core/utils/error_mapper.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:doctor_hunt/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'auth_bottom_sheet_wrapper.dart';
import 'otp_digit_field.dart';

class ForgotPasswordOtpStep extends StatefulWidget {
  const ForgotPasswordOtpStep({
    super.key,
    required this.isLoading,
    required this.onContinue,
    required this.onResend,
    this.onClearError,
    this.errorMessage,
    this.codeLength = 6,
  });

  final bool isLoading;
  final ValueChanged<String> onContinue;
  final VoidCallback onResend;
  final VoidCallback? onClearError;
  final String? errorMessage;
  final int codeLength;

  @override
  State<ForgotPasswordOtpStep> createState() => _ForgotPasswordOtpStepState();
}

class _ForgotPasswordOtpStepState extends State<ForgotPasswordOtpStep> {
  String _otp = '';
  int _secondsRemaining = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  void _handleResend() {
    if (_secondsRemaining > 0 || widget.isLoading) return;
    _startTimer();
    widget.onResend();
  }

  void _submit() {
    if (_otp.length == widget.codeLength) {
      widget.onContinue(_otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isTimerActive = _secondsRemaining > 0;
    final timerString = '00:${_secondsRemaining.toString().padLeft(2, '0')}';

    return AuthBottomSheetWrapper(
      title: t.auth.enterCodeTitle,
      subtitle: t.auth.enterCodeSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OtpDigitField(
            length: widget.codeLength,
            onChanged: (code) {
              setState(() => _otp = code);
              if (widget.errorMessage != null &&
                  widget.errorMessage!.isNotEmpty) {
                widget.onClearError?.call();
              }
            },
            onCompleted: (code) {
              setState(() => _otp = code);
              _submit();
            },
          ),
            if (widget.errorMessage != null &&
                widget.errorMessage!.isNotEmpty) ...[
              SizedBox(height: 14.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: palette.dangerLight,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: palette.danger.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: palette.danger,
                      size: 20.r,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        getErrorMessage(widget.errorMessage!),
                        style: context.regular12Danger,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 16.h),
            Center(
              child: TextButton(
                onPressed: (isTimerActive || widget.isLoading)
                    ? null
                    : _handleResend,
                child: Text(
                  isTimerActive
                      ? t.auth.resendCodeIn(time: timerString)
                      : t.auth.resendCode,
                  style: isTimerActive
                      ? context.regular14TextSub
                      : context.regular14Primary,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            PrimaryButton(
              text: t.auth.continueText,
              isLoading: widget.isLoading,
              onPressed: (_otp.length == widget.codeLength && !widget.isLoading)
                  ? _submit
                  : null,
              isFullWidth: true,
            ),
          ],
        ),
    );
  }
}
