import 'package:carry_bot/core/common/widgets/floating_widget.dart';
import 'package:carry_bot/features/device/data/model/sensor_model.dart';
import 'package:carry_bot/features/device/presentation/widgets/car_controller.dart';
import 'package:carry_bot/features/device/presentation/widgets/sensor_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool shrink = false;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
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
          child: Stack(
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
                  children: [
                    SizedBox(
                      width: w,
                    ),
                    SensorDataShow(
                      sensor: SensorModel(
                        name: "Distance Sensor",
                        value: 10.5,
                        situation: "G",
                      ),
                      minimize: shrink,
                    ),
                    SensorDataShow(
                      sensor: SensorModel(
                        name: "Depth Sensor",
                        value: 10.5,
                        situation: "Y",
                      ),
                      minimize: shrink,
                    ),
                    SensorDataShow(
                      sensor: SensorModel(
                        name: "Load Sensor",
                        value: 10.5,
                        situation: "R",
                      ),
                      minimize: shrink,
                    ),
                  ],
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
                    onPressed: () {
                      setState(() {
                        shrink = !shrink;
                        FloatingWidgetManager.showFloatingWidget(context, "This is a hagu message");
                      });
                    },
                    child: Text(shrink ? "Auto" : "Manual"),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
