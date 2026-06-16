abstract class OnboardingEvent {
  const OnboardingEvent();
}

class OnboardingPageChangedEvent extends OnboardingEvent {
  final int pageIndex;
  const OnboardingPageChangedEvent(this.pageIndex);
}

class OnboardingNextPageEvent extends OnboardingEvent {
  const OnboardingNextPageEvent();
}

class OnboardingPreviousPageEvent extends OnboardingEvent {
  const OnboardingPreviousPageEvent();
}

class OnboardingSkipEvent extends OnboardingEvent {
  const OnboardingSkipEvent();
}

class OnboardingCompleteEvent extends OnboardingEvent {
  const OnboardingCompleteEvent();
}
