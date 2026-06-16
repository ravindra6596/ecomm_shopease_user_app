abstract class HomeEvent {}

class GetHomeEvent extends HomeEvent {
  int categoryId;
  GetHomeEvent(this.categoryId);
}
class ClearHomeEvent extends HomeEvent {}
class BannerPageChangedEvent extends HomeEvent {
  final int index;
  BannerPageChangedEvent(this.index);
}