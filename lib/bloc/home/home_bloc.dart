
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/home_response_model.dart';
import 'package:e_comm_user/repository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'home_event.dart';
import 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;
  int currentBannerIndex = 0;
  HomeBloc() : homeRepository = getIt<HomeRepository>(), super(HomeInitial()) {
      on<GetHomeEvent>(getHomeData);
      on<ClearHomeEvent>(clearHomeData);
      on<BannerPageChangedEvent>(bannerPageChanged);
  }

  getHomeData(GetHomeEvent event,emit) async {
    try {
      emit(HomeLoading());
      final result = await homeRepository.getHome(event.categoryId);

      switch (result) {
        case Success<HomeResponseModel, Exception>():
          await emit(HomeLoaded(result.data,0));
          break;
        case Failure<HomeResponseModel, Exception>():
          emit(HomeError(result.error.toString()));
          break;
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  clearHomeData(ClearHomeEvent event,emit) {
    emit(HomeInitial());
  }

  bannerPageChanged(BannerPageChangedEvent event,emit) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(HomeLoaded(
        currentState.homeResponseModel,
         event.index,
      ));
    }
  }
}
