import 'package:carry_bot/config/theme/Themes.dart';
import 'package:carry_bot/features/device/presentation/pages/device_page.dart';
import 'package:carry_bot/features/home/presentation/bloc/home_bloc.dart';
import 'package:carry_bot/injection_Container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'features/home/presentation/pages/homepage.dart';

void main() async {
  await initializeDependency();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    BluetoothDevice device = BluetoothDevice(remoteId: DeviceIdentifier(""));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: darkTheme,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => serviceLocator<HomeBloc>()),
        ],
        child: DevicePage(device: device),
      ),
    );
  }
}
