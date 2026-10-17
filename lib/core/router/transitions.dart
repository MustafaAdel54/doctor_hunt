import 'package:doctor_hunt/shared/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<T> fadePage<T>({
  required Widget child,
  required LocalKey key,
}) => CustomTransitionPage<T>(
  key: key,
  child: child,
  transitionDuration: AppDurations.medium,
  transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
);
