import 'package:carry_bot/core/common/client/client_connect.dart';
import 'package:carry_bot/core/network/connection_checker.dart';
import 'package:carry_bot/features/device/data/data%20source/ble_source.dart';
import 'package:carry_bot/features/device/data/data%20source/sensor_data.dart';
import 'package:carry_bot/features/device/data/repository/device_repo_implement.dart';
import 'package:carry_bot/features/device/domain/repository/device_repository.dart';
import 'package:carry_bot/features/device/domain/usecase/listen_ble_usecase.dart';
import 'package:carry_bot/features/device/domain/usecase/sendMessage_ble_usecase.dart';
import 'package:carry_bot/features/device/presentation/bloc/device_bloc.dart';
import 'package:carry_bot/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependency() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  _homeInit();
  _deviceInit();

  serviceLocator
      .registerLazySingleton<SensorInformation>(() => SensorInformation());

  serviceLocator.registerLazySingleton<BLEService>(
    () => BLEService(),
  );

  serviceLocator.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(
        InternetConnection.createInstance(),
      ));
}

void _homeInit() {
  serviceLocator.registerLazySingleton(() => HomeBloc(
        bleService: serviceLocator(),
      ));
}

void _deviceInit() {
  serviceLocator
    ..registerFactory<BleDeviceData>(
      () => BleDeviceDataImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<DeviceRepository>(
      () => DeviceRepositoryImplementation(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory<ListenBleUseCase>(
      () => ListenBleUseCase(
        serviceLocator(),
      ),
    )
    ..registerFactory<SendBleMessageUseCase>(
      () => SendBleMessageUseCase(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => DeviceBloc(
        listenBleUseCase: serviceLocator(),
        sendBleMessageUseCase: serviceLocator(),
      ),
    );
}
