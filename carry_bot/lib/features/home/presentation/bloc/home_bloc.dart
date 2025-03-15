import 'dart:async';

import 'package:carry_bot/features/home/presentation/bloc/home_event.dart';
import 'package:carry_bot/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent,HomeState>{
  HomeBloc():super(HomeInitialState()){
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeClickedDeviceEvent>(homeClickedDeviceEvent);
    on<HomeClickedRefreshEvent>(homeClickedRefreshEvent);
  }

  FutureOr<void> homeInitialEvent(HomeInitialEvent event,Emitter<HomeState> emit,){}

  FutureOr<void> homeClickedDeviceEvent(HomeClickedDeviceEvent event,Emitter<HomeState> emit,){}

  FutureOr<void> homeClickedRefreshEvent(HomeClickedRefreshEvent event,Emitter<HomeState> emit,){}


}