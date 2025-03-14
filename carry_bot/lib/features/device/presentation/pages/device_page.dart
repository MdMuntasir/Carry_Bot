import 'package:carry_bot/features/device/data/model/sensor_model.dart';
import 'package:carry_bot/features/device/presentation/widgets/sensor_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

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
        title: Center(
          child: Text(
            "Carry Bot",
            style: GoogleFonts.signikaNegative(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: w,
          ),
          SensorDataShow(
            sensor: SensorModel(
              name: "Depth Sensor",
              value: 10.5,
              situation: "G",
            ),
            minimize: shrink,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                shrink = !shrink;
              });
            },
            child: Text("Shrink"),
          )
        ],
      ),
    );
  }
}
