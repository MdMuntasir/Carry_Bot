sealed class HomeEvent{
  const HomeEvent();
}

class HomeInitialEvent extends HomeEvent{}

class HomeClickedDeviceEvent extends HomeEvent{}

class HomeClickedRefreshEvent extends HomeEvent{}