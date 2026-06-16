abstract class NavigationState {
  const NavigationState();
}

class NavigationInitialState extends NavigationState {
  const NavigationInitialState();
}

class NavigationTabChangedState extends NavigationState {
  final int currentIndex;
  const NavigationTabChangedState(this.currentIndex);
}
