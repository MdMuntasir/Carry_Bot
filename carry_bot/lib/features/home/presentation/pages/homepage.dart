import 'dart:async';
import 'dart:developer';

import 'package:carry_bot/core/common/client/client_connect.dart';
import 'package:carry_bot/features/device/presentation/pages/device_page.dart';
import 'package:carry_bot/features/home/presentation/bloc/home_bloc.dart';
import 'package:carry_bot/features/home/presentation/bloc/home_event.dart';
import 'package:carry_bot/features/home/presentation/bloc/home_state.dart';
import 'package:carry_bot/injection_Container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeInitialEvent());
    serviceLocator<BLEService>().onScanUpdated = (results) {
      setState(() {
        serviceLocator<BLEService>().scanResults = results;
      });
    };

    // timer = Timer.periodic(const Duration(seconds: 5), (_){
    //   if(context.read<HomeBloc>().state is HomeScannedDevices) {
    //     context.read<HomeBloc>().add(HomeInitialEvent());
    //   }
    // });
  }

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Center(
          child: Text(
            "Bot Controller",
            style: GoogleFonts.signikaNegative(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )),
        body: Stack(
          alignment: Alignment.bottomRight,
          children: [
            BlocConsumer(
              bloc: context.read<HomeBloc>(),
              listenWhen: (prev, current) => current is HomeActionState,
              buildWhen: (prev, current) =>
                  current is! HomeActionState && current is HomeState,
              listener: (context, state) {
                if (state is HomeDeviceConnected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Connected"),
                    ),
                  );
                  serviceLocator<BLEService>().enableNotifications();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DevicePage(
                          device: state.device,
                        ),
                      ));
                } else if (state is HomeDeviceConnectionFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                    ),
                  );
                } else if (state is HomeNoBluetoothConnection) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Enable Bluetooth"),
                      content:
                          Text("Bluetooth is required to scan for devices."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await FlutterBluePlus.turnOn().then(
                              (_) {
                                if (context.mounted) {
                                  context
                                      .read<HomeBloc>()
                                      .add(HomeInitialEvent());
                                }
                              },
                            );
                          },
                          child: Text("Turn On"),
                        ),
                      ],
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is HomeScannedDevices) {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    itemCount: serviceLocator<BLEService>().scanResults.length,
                    itemBuilder: (context, index) {
                      final device = serviceLocator<BLEService>()
                          .scanResults[index]
                          .device;
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF93B1A6),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.bluetooth,
                                color: Color(0xFF183D3D),
                              ),
                            ),
                          ),
                          title: Text(
                            device.platformName,
                          ),
                          subtitle: Text(
                            device.remoteId.toString(),
                          ),
                          onTap: () async {
                            context
                                .read<HomeBloc>()
                                .add(HomeClickedDeviceEvent(device));
                          },
                        ),
                      );
                    },
                  );
                } else if (state is HomeScanFailedState) {
                  return Center(
                    child: Text(state.error),
                  );
                } else if (state is HomeScanningDevices) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Center(
                  child: Text("Something Went Wrong."),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: FloatingActionButton(
                onPressed: () {
                  context.read<HomeBloc>().add(HomeInitialEvent());
                },
                child: Icon(Icons.search),
              ),
            )
          ],
        ));
  }
}
