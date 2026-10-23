import 'package:doctor_hunt/features/profile/screens/edit_profile/widgets/profile_text_field.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.isSaving,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final bool isSaving;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 8.h),
              Text(
                t.profile.personalInfo,
                style: context.bold18TextMain,
              ),
              SizedBox(height: 16.h),

              // Name Field
              ProfileTextField(
                label: t.profile.name,
                controller: nameController,
                hintText: t.profile.enterName,
                enabled: !isSaving,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return t.validation.required;
                  }
                  return null;
                },
              ),

              SizedBox(height: 20.h),

              // Contact Number Field
              ProfileTextField(
                label: t.profile.contactNumber,
                controller: phoneController,
                hintText: t.profile.enterPhone,
                keyboardType: TextInputType.phone,
                enabled: !isSaving,
                validator: (val) {
                  if (val != null && val.trim().isNotEmpty && val.trim().length < 6) {
                    return t.profile.invalidPhone;
                  }
                  return null;
                },
              ),

              SizedBox(height: 36.h),

              // Submit Button
              ElevatedButton(
                onPressed: isSaving ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: palette.primary,
                  foregroundColor: palette.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: isSaving
                    ? SizedBox(
                        height: 20.w,
                        width: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          color: palette.white,
                        ),
                      )
                    : Text(
                        t.profile.update,
                        style: context.bold16White,
                      ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
