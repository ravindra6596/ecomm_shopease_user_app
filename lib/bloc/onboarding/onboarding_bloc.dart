import 'package:e_comm_user/bloc/onboarding/onboarding_event.dart';
import 'package:e_comm_user/bloc/onboarding/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  int currentPage = 0;
  OnboardingBloc() : super(const OnboardingInitialState()) {
    on<OnboardingEvent>(onboardingEventHandler);
  }

  onboardingEventHandler(OnboardingEvent event, emit) {
    if (event is OnboardingPageChangedEvent) {
      currentPage = event.pageIndex;
      emit(OnboardingPageChangedState(event.pageIndex));
    } else if (event is OnboardingCompleteEvent) {
      emit(OnboardingCompletedState(currentPage));
    }
  }
}
