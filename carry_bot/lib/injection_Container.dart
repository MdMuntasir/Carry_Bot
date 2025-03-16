import 'package:carry_bot/core/common/client/client_connect.dart';
import 'package:carry_bot/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependency() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  serviceLocator.registerLazySingleton<BLEService>(
    () => BLEService(),
  );

  serviceLocator.registerLazySingleton(() => HomeBloc(
        bleService: serviceLocator(),
      ));
}
