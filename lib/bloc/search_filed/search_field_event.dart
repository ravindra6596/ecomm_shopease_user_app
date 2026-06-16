abstract class SearchEvent {}

class StartHintRotation extends SearchEvent {}

class StopHintRotation extends SearchEvent {}

class NextHint extends SearchEvent {}

class QueryChanged extends SearchEvent {
  final String query;
  QueryChanged(this.query);
}
class UpdateHintsEvent extends SearchEvent {
  final List<String> hints;

  UpdateHintsEvent(this.hints);
}