import 'package:auto_route/annotations.dart';
import 'package:e_comm_user/bloc/onboarding/onboarding_bloc.dart';
import 'package:e_comm_user/bloc/onboarding/onboarding_event.dart';
import 'package:e_comm_user/bloc/onboarding/onboarding_state.dart';
import 'package:e_comm_user/core/shared_pref_helper.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/utils/assets.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

@RoutePage()
class OnboardingScreen extends StatelessWidget {
    OnboardingScreen({super.key});

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(title: intro1),
    OnboardingItem(title: intro2),
    OnboardingItem(title: intro3),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(),
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingCompletedState) {
            _completeOnboarding(context);
          }
        },
        child: OnboardingContent(onboardingItems: _onboardingItems),
      ),
    );
  }

  Future<void> _completeOnboarding(BuildContext context) async {
    await SharedPrefHelper.setOnboardingCompleted(true);
    if (context.mounted) {
      getIt<AppRoutes>().replace(MainRoute());
    }
  }
}

class OnboardingContent extends StatefulWidget {
  final List<OnboardingItem> onboardingItems;

  const OnboardingContent({super.key, required this.onboardingItems});

  @override
  State<OnboardingContent> createState() => _OnboardingContentState();
}

class _OnboardingContentState extends State<OnboardingContent> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  bool isCompleting = false;
  void _nextPage(int currentPage) {
    if (isCompleting) return;
    if (currentPage < widget.onboardingItems.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      isCompleting = true;
      context.read<OnboardingBloc>().add(const OnboardingCompleteEvent());
    }
  }

  void _skipOnboarding() {
    if (isCompleting) return;

    isCompleting = true;
    context.read<OnboardingBloc>().add(const OnboardingCompleteEvent());
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              context.read<OnboardingBloc>().add(OnboardingPageChangedEvent(index));
            },
            itemCount: widget.onboardingItems.length,
            itemBuilder: (context, index) {
              return OnboardingPage(item: widget.onboardingItems[index]);
            },
          ),
          Positioned(
            top: 3.h,
            right: 3.w,
            child: Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _skipOnboarding,
                child: CustomText(text: skip,color: primaryColor,style: CustomTextStyle.bold),
              ),
            ),
          ),
          Positioned(
            left: 3.w,
            right: 3.w,
            bottom: 2.h,
            child: BlocBuilder<OnboardingBloc, OnboardingState>(
              builder: (context, state) {
                // final currentPage = state is OnboardingPageChangedState
                //     ? state.currentPage
                //     : 0;
                final currentPage = switch (state) {
                  OnboardingPageChangedState s => s.currentPage,
                  OnboardingCompletedState s => s.currentPage,
                  _ => 0,
                };
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    currentPage > 0
                        ? TextButton(
                      onPressed: _previousPage,
                      child: CustomText(text: previous,color: primaryColor,style: CustomTextStyle.bold),
                    )
                        : const SizedBox(width: 80),
                    BlocBuilder<OnboardingBloc, OnboardingState>(
                      builder: (context, state) {
                        return SmoothPageIndicator(
                          controller: _pageController,
                          count: widget.onboardingItems.length,
                          effect: WormEffect(
                            dotHeight: 10,
                            dotWidth: 10,
                            activeDotColor: primaryColor,
                          ),
                        );
                      },
                    ),
                    TextButton(
                      onPressed: () => _nextPage(currentPage),
                      child: CustomText(
                        text: currentPage == widget.onboardingItems.length - 1
                            ? getStarted
                            : next,
                        color: currentPage == widget.onboardingItems.length - 1 ? successColor : primaryColor,
                        style: CustomTextStyle.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(item.title),
            fit: BoxFit.cover,
          )
      ),
    );
  }
}
/*
*
*
* return Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              size: 80,
              color: item.color,
            ),
          ),
          SizedBox(height: 48),
          CustomText(
            text: item.title,
            style: CustomTextStyle.bold,
            fontSize: 24,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          CustomText(
            text: item.description,
            style: CustomTextStyle.regular,
            fontSize: 16,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );*/
class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingItem({
    required this.title,
      this.description = '',
      this.icon = Icons.shopping_bag,
      this.color = Colors.black,
  });
}
