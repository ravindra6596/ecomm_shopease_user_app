import 'dart:developer';

import 'package:e_comm_user/bloc/navigation/navigation_event.dart';
import 'package:e_comm_user/bloc/navigation/navigation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationInitialState()) {
    on<NavigationEvent>(navigationEventHandler);
  }

  navigationEventHandler(NavigationEvent event, emit) {
    if (event is NavigationTabChangedEvent) {
      emit(NavigationTabChangedState(event.index));
    }
  }
}
