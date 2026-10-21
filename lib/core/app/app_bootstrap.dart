import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/features/favorites/cubit/favorites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<FavoritesCubit>(),
      child: child,
    );
  }
}
