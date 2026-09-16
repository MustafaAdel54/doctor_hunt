import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';

CustomTransitionPage<T> fadePage<T>({
  required Widget child,
  required LocalKey key,
}) => CustomTransitionPage<T>(
  key: key,
  child: child,
  transitionDuration: AppDurations.medium,
  transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
);
