import 'package:e_comm_user/models/home_response_model.dart';

abstract class HomeState {
  const HomeState();
}
class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final HomeResponseModel homeResponseModel;
  final int bannerIndex;
  const HomeLoaded(this.homeResponseModel,this.bannerIndex);
}
class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}
class BannerIndexState extends HomeState {
  final int index;
  BannerIndexState(this.index);
}