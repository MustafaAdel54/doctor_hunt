import 'package:doctor_hunt/core/di/injector.dart';
import 'package:doctor_hunt/core/router/routes.dart';
import 'package:doctor_hunt/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:doctor_hunt/features/onboarding/widgets/onboarding_page_widget.dart';
import 'package:doctor_hunt/shared/generated/image_assets.dart';
import 'package:doctor_hunt/shared/generated/style_atoms.dart';
import 'package:doctor_hunt/shared/i18n/strings.g.dart';
import 'package:doctor_hunt/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  static const int _pageCount = 3;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext(BuildContext context, int currentIndex) {
    if (currentIndex < _pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      sl<SharedPreferences>().setBool('seen_onboarding', true);
      context.go(Paths.login);
    }
  }

  void _onSkip(BuildContext context) {
    sl<SharedPreferences>().setBool('seen_onboarding', true);
    context.go(Paths.login);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Scaffold(
        backgroundColor: palette.surface,
        body: Builder(
          builder: (context) {
            return Stack(
              children: [
                // Bottom Gradient
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 300.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            palette.primary.withValues(alpha: 0.15),
                            palette.surface.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Top Left Green Dot
                Positioned(
                  top: -50.w,
                  left: -50.w,
                  child: Image.asset(
                    ImageAssets.greenDot,
                    width: 300.w,
                    fit: BoxFit.contain,
                  ),
                ),

                // Main Content
                SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) => context
                              .read<OnboardingCubit>()
                              .pageChanged(index),
                          children: [
                            OnboardingPageWidget(
                              imagePath:
                                  ImageAssets.onboarding1,
                              title: t.onboarding.page1Title,
                              subtitle: t.onboarding.page1Subtitle,
                            ),
                            OnboardingPageWidget(
                              imagePath:
                                  ImageAssets.onboarding2,
                              title: t.onboarding.page2Title,
                              subtitle: t.onboarding.page2Subtitle,
                            ),
                            OnboardingPageWidget(
                              imagePath:
                                  ImageAssets.onboarding3,
                              title: t.onboarding.page3Title,
                              subtitle: t.onboarding.page3Subtitle,
                            ),
                          ],
                        ),
                      ),

                      // Bottom Buttons
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 24.h,
                        ),
                        child: BlocBuilder<OnboardingCubit, int>(
                          builder: (context, currentIndex) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PrimaryButton(
                                  text: currentIndex == _pageCount - 1
                                      ? t.onboarding.getStarted
                                      : t.onboarding.next,
                                  onPressed: () =>
                                      _onNext(context, currentIndex),
                                  isFullWidth: true,
                                ),
                                SizedBox(height: 16.h),
                                TextButton(
                                  onPressed: () => _onSkip(context),
                                  child: Text(
                                    t.onboarding.skip,
                                    style: context.regular14TextSub,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
