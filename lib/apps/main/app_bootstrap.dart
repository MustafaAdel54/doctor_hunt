import 'package:flutter/material.dart';

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Stub for main branch. The state management branches will inject their
    // providers (BlocProvider, ProviderScope) here.
    return child;
  }
}
