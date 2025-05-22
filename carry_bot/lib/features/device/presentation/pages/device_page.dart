import 'dart:convert';

import 'package:carry_bot/core/common/client/client_connect.dart';
import 'package:carry_bot/features/device/data/data%20source/sensor_data.dart';
import 'package:carry_bot/features/device/presentation/bloc/device_bloc.dart';
import 'package:carry_bot/features/device/presentation/bloc/device_event.dart';
import 'package:carry_bot/features/device/presentation/bloc/device_state.dart';
import 'package:carry_bot/features/device/presentation/widgets/car_controller.dart';
import 'package:carry_bot/features/device/presentation/widgets/sensor_data.dart';
import 'package:carry_bot/injection_Container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/sensor_model.dart';

class DevicePage extends StatefulWidget {
  final BluetoothDevice device;
  const DevicePage({
    super.key,
    required this.device,
  });

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  List<SensorModel> sensorInfo = [];
  bool shrink = false;

  @override
  void initState() {
    serviceLocator<BLEService>().enableNotifications();

    context.read<DeviceBloc>().add(DeviceInitialEvent(context));
    serviceLocator<SensorInformation>().setListener((sensorData) {
      setState(() {
        sensorInfo = sensorData;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async{
              await serviceLocator<BLEService>().disconnectDevice();
              if(context.mounted) {
                Navigator.of(context).pop();
            }
            },
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          title: Text(
            "Carry Bot",
            style: GoogleFonts.signikaNegative(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: h,
          child: BlocBuilder(
              bloc: context.read<DeviceBloc>(),
              builder: (context, state) {
                if (state is DeviceLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: shrink ? w * .03 : w * .15,
                        bottom: shrink ? 0 : h * .05,
                      ),
                      child: Wrap(
                        runSpacing: 15,
                        spacing: 15,
                        children: List.generate(sensorInfo.length + 1, (index) {
                          return index == 0
                              ? SizedBox(
                                  width: w,
                                )
                              : SensorDataShow(
                                  sensor: sensorInfo[index - 1],
                                  minimize: shrink,
                                );
                        }),
                      ),
                    ),
                    AnimatedPositioned(
                      bottom: shrink ? 0 : -h * .5,
                      duration: Duration(milliseconds: 300),
                      child: CarController(),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 300),
                      bottom: shrink ? 125 : 5,
                      right: shrink ? 135 : 0,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: FloatingActionButton(
                          onPressed: () async{
                            !shrink?
                            await serviceLocator<BLEService>()
                                .sendData(jsonEncode({"mode": "manual"})):
                            await serviceLocator<BLEService>()
                                .sendData(jsonEncode({"mode": "auto"}))
                            ;
                            setState(() {
                              shrink = !shrink;
                            });
                          },
                          child: Text(shrink ? "Auto" : "Manual"),
                        ),
                      ),
                    )
                  ],
                );
              }),
        ));
  }
}
