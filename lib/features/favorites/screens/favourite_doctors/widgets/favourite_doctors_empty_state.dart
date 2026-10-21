import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavouriteDoctorsEmptyState extends StatelessWidget {
  const FavouriteDoctorsEmptyState({
    super.key,
    this.isSearchResult = false,
  });

  final bool isSearchResult;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                color: palette.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                isSearchResult
                    ? Icons.search_off_rounded
                    : Icons.favorite_border_rounded,
                size: 42.r,
                color: palette.primary,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              isSearchResult
                  ? t.doctors.noDoctors
                  : t.doctors.noFavourites,
              style: context.bold18TextMain,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              isSearchResult
                  ? t.doctors.searchHint
                  : t.doctors.noFavouritesDesc,
              style: context.regular14TextSub,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
