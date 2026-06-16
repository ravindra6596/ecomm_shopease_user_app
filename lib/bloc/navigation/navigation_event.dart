abstract class NavigationEvent {
  const NavigationEvent();
}

class NavigationTabChangedEvent extends NavigationEvent {
  final int index;
  const NavigationTabChangedEvent(this.index);
}
