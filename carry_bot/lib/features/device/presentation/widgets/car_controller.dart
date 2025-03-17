import 'package:carry_bot/features/device/presentation/widgets/car_button.dart';
import 'package:flutter/cupertino.dart';

class CarController extends StatelessWidget {
  const CarController({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    return Container(
      height: h * .5,
      width: w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Color(0xFF183D3D),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 30,
            child: CarButton(
              rotate: 0,
              move: "front",
            ),
          ),
          Positioned(
            right: 50,
            top: 50,
            child: CarButton(
              rotate: 45,
              move: "fr",
            ),
          ),
          Positioned(
            right: 30,
            child: CarButton(
              rotate: 90,
              move: "right",
            ),
          ),
          Positioned(
            right: 50,
            bottom: 50,
            child: CarButton(
              rotate: 135,
              move: "br",
            ),
          ),
          Positioned(
            bottom: 30,
            child: CarButton(
              rotate: 180,
              move: "back",
            ),
          ),
          Positioned(
            left: 50,
            bottom: 50,
            child: CarButton(
              rotate: 225,
              move: "bl",
            ),
          ),
          Positioned(
            left: 30,
            child: CarButton(
              rotate: 270,
              move: "left",
            ),
          ),
          Positioned(
            left: 50,
            top: 50,
            child: CarButton(
              rotate: 315,
              move: "fl",
            ),
          ),
        ],
      ),
    );
  }
}
