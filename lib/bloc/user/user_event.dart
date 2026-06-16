abstract class UserEvent {}

class UserListEvent extends UserEvent {
  final int page;
  final int limit;
  UserListEvent( this.page,   this.limit );
}
class UserSearchEvent extends UserEvent {
  final String search;
  UserSearchEvent(this.search);
}
class UserDetailEvent extends UserEvent {
  final int userId;
  UserDetailEvent(this.userId);
}