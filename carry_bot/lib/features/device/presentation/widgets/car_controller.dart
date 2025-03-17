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
            top: -30,
            child: CarButton(
              rotate: 0,
            ),
          ),
          Positioned(
            right: -15,
            top: -15,
            child: CarButton(
              rotate: 45,
            ),
          ),
          Positioned(
            right: -15,
            child: CarButton(
              rotate: 90,
            ),
          ),
          Positioned(
            right: -15,
            bottom: -15,
            child: CarButton(
              rotate: 135,
            ),
          ),
          Positioned(
            bottom: -30,
            child: CarButton(
              rotate: 180,
            ),
          ),
          Positioned(
            left: -15,
            bottom: -15,
            child: CarButton(
              rotate: 225,
            ),
          ),
          Positioned(
            left: -15,
            child: CarButton(
              rotate: 270,
            ),
          ),
          Positioned(
            left: -15,
            top: -15,
            child: CarButton(
              rotate: 315,
            ),
          ),
        ],
      ),
    );
  }
}
