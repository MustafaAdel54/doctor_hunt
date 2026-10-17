import 'dart:async';

import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/core/session/session_service.dart';
import 'package:doctor_hunt/core/session/session_state.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/splash_background_glow.dart';
import 'widgets/splash_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    final sessionService = sl<SessionService>();

    // 1. Allow at least 2 seconds for the branded splash animation
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    // 2. If the background session is still evaluating, wait until it finishes
    if (sessionService.value.status == SessionStatus.initial) {
      final completer = Completer<void>();
      void listener() {
        if (sessionService.value.status != SessionStatus.initial) {
          if (!completer.isCompleted) completer.complete();
        }
      }

      sessionService.addListener(listener);
      await completer.future.timeout(
        const Duration(seconds: 3),
        onTimeout: () {},
      );
      sessionService.removeListener(listener);
    }

    if (!mounted) return;

    final session = sessionService.value;
    final prefs = sl<SharedPreferences>();
    final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

    if (session.status == SessionStatus.authenticated) {
      if (session.role == 'doctor') {
        context.go(Paths.doctorHome);
      } else {
        context.go(Paths.patientHome);
      }
    } else if (session.status == SessionStatus.authenticatedWithoutProfile) {
      context.go(Paths.roleSelection);
    } else if (session.status == SessionStatus.authenticatedInactive) {
      context.go(Paths.accountInactive);
    } else {
      // Unauthenticated: if first time -> onboarding, else -> login
      if (!seenOnboarding) {
        context.go(Paths.onboarding);
      } else {
        context.go(Paths.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.surface,
      body: Stack(
        children: [
          const SplashBackgroundGlow(),
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.92 + (0.08 * value),
                    child: child,
                  ),
                );
              },
              child: const SplashLogo(),
            ),
          ),
        ],
      ),
    );
  }
}
