import 'dart:developer';
import 'package:carry_bot/core/common/mqtt%20client/client_connect.dart';
import 'package:carry_bot/core/connection%20state/mqtt_state.dart';
import 'package:carry_bot/core/network/connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // void publishFunction() async {
  //   MQTTClient mqttClient = MQTTClient();
  //   MQTTState status = await mqttClient.connectClient(
  //     "Muntasir",
  //     "CarryB0T",
  //     "ca4608428ecc49bf8d21c278b450ef13.s1.eu.hivemq.cloud",
  //     "Redmi 6",
  //   );
  //
  //   if (status is MQTTSuccess) {
  //     RemoteHomeData remoteHomeData = RemoteHomeDataImpl();
  //     ConnectionChecker connectionChecker =
  //         ConnectionCheckerImpl(InternetConnection.createInstance());
  //     HomeRepository homeRepository = HomeRepositoryImplementation(
  //         status.data, remoteHomeData, connectionChecker);
  //
  //     MQTTState responseStat = await homeRepository.publish(
  //       status.data,
  //       "testMessage",
  //       "This is a message from Redmi 6",
  //     );
  //     if (responseStat is MQTTFailed) {
  //       if (context.mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text("Connection Failed: ${responseStat.error}"),
  //           ),
  //         );
  //       }
  //     }
  //   } else {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Connection Failed: ${status.error}"),
  //         ),
  //       );
  //     }
  //   }
  // }
  //
  // void subscribeFunction() async {
  //   MQTTClient mqttClient = MQTTClient();
  //   MQTTState status = await mqttClient.connectClient(
  //     "Muntasir",
  //     "CarryB0T",
  //     "ca4608428ecc49bf8d21c278b450ef13.s1.eu.hivemq.cloud",
  //     "Redmi 6",
  //   );
  //   if (status is MQTTSuccess) {
  //     RemoteHomeData remoteHomeData = RemoteHomeDataImpl();
  //     ConnectionChecker connectionChecker =
  //         ConnectionCheckerImpl(InternetConnection.createInstance());
  //     HomeRepository homeRepository = HomeRepositoryImplementation(
  //       status.data,
  //       remoteHomeData,
  //       connectionChecker,
  //     );
  //
  //     MQTTState responseStat =
  //         await homeRepository.subscribe(status.data, "testMessage", (message) {
  //       log(message);
  //     });
  //
  //     if (responseStat is MQTTFailed) {
  //       if (context.mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text("Connection Failed: ${responseStat.error}"),
  //           ),
  //         );
  //       }
  //     }
  //   } else {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Connection Failed: ${status.error}"),
  //         ),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
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
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              SizedBox(
                width: w,
              ),

              ElevatedButton(
                onPressed: (){},
                child: Text(
                  "Search Devices",
                  style: GoogleFonts.lexend(),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }
}
