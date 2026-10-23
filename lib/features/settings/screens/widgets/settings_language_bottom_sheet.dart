import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showSettingsLanguageBottomSheet(BuildContext context) {
  final palette = context.palette;
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: palette.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (bottomSheetCtx) {
      final currentLocale = LocaleSettings.currentLocale;
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.settings.languages,
                style: context.bold18TextMain,
              ),
              SizedBox(height: 16.h),
              ListTile(
                title: Text('English', style: context.medium16TextMain),
                trailing: currentLocale == AppLocale.en
                    ? Icon(Icons.check_circle_rounded, color: palette.primary)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                onTap: () {
                  LocaleSettings.setLocale(AppLocale.en);
                  Navigator.of(bottomSheetCtx).pop();
                },
              ),
              Divider(color: palette.textBorders.withValues(alpha: 0.3)),
              ListTile(
                title: Text('العربية', style: context.medium16TextMain),
                trailing: currentLocale == AppLocale.ar
                    ? Icon(Icons.check_circle_rounded, color: palette.primary)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                onTap: () {
                  LocaleSettings.setLocale(AppLocale.ar);
                  Navigator.of(bottomSheetCtx).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
