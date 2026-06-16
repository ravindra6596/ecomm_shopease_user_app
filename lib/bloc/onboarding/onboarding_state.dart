abstract class OnboardingState {
  const OnboardingState();
}

class OnboardingInitialState extends OnboardingState {
  const OnboardingInitialState();
}

class OnboardingPageChangedState extends OnboardingState {
  final int currentPage;
  const OnboardingPageChangedState(this.currentPage);
}

class OnboardingCompletedState extends OnboardingState {
  final int currentPage;
  const OnboardingCompletedState(this.currentPage);
}
