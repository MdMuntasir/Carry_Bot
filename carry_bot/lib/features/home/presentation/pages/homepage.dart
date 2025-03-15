import 'dart:developer';

import 'package:carry_bot/core/common/mqtt%20client/client_connect.dart';
import 'package:carry_bot/features/home/presentation/bloc/home_state.dart';
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
  final BLEService bleService = BLEService();
  List<ScanResult> devices = [];
  BluetoothDevice? selectedDevice;
  TextEditingController pinController = TextEditingController();

  void checkBluetoothStatus(BuildContext context) {
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) async {
      if (state == BluetoothAdapterState.off) {
        _showEnableBluetoothDialog(context);
      }
    });
  }

  void _showEnableBluetoothDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Enable Bluetooth"),
        content: Text("Bluetooth is required to scan for devices."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FlutterBluePlus.turnOn(); // 🔥 Works only on Android
            },
            child: Text("Turn On"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    bleService.onScanUpdated = (newDevices) {
      setState(() {
        devices = newDevices;
      });
    };
    bleService.startScanning();
  }

  @override
  void dispose() {
    bleService.stopScanning();
    super.dispose();
  }

  Future<void> onDeviceSelect(BluetoothDevice device) async {
    await device.connect();
    if (device.isConnected) {
      log("Device Connected"); //
      setState(() {
        selectedDevice = device;
        bleService.connectedDevice = device;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Connected"),
        ),
      );
      bleService.enableNotifications();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Couldn't connect to device"),
        ),
      );
    }
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
      body: BlocConsumer( listener: (context, state){}, builder: (context, state){
        if(state is HomeScannedDevices){
          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index].device;
              return ListTile(
                title: Text(
                  device.platformName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  device.remoteId.toString(),
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () async {
                  await onDeviceSelect(device);
                },
              );
            },
          );
        }

        else if(state is HomeScanFailedState){
          return Center(child: Text(state.error),);
        }

        else if(state is HomeScanningDevices){
          return Center(child: CircularProgressIndicator(),);
        }

        return Center(child: CircularProgressIndicator(),);
      },)

    );
  }
}
