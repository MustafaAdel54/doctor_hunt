import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class Gaps {
  static Widget get h4 => SizedBox(height: 4.h);
  static Widget get h8 => SizedBox(height: 8.h);
  static Widget get h12 => SizedBox(height: 12.h);
  static Widget get h16 => SizedBox(height: 16.h);
  static Widget get h24 => SizedBox(height: 24.h);
  static Widget get h32 => SizedBox(height: 32.h);

  static Widget get w4 => SizedBox(width: 4.w);
  static Widget get w8 => SizedBox(width: 8.w);
  static Widget get w12 => SizedBox(width: 12.w);
  static Widget get w16 => SizedBox(width: 16.w);
  static Widget get w24 => SizedBox(width: 24.w);
}

abstract final class AppRadius {
  static double get sm => 8.r;
  static double get md => 12.r;
  static double get lg => 16.r;
  static double get xl => 24.r;
  static double get pill => 100.r;
}

abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}

const Size designSize = Size(375, 812);
