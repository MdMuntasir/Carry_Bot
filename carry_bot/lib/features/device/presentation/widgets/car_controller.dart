import 'package:carry_bot/features/device/presentation/widgets/car_button.dart';
import 'package:flutter/cupertino.dart';

class CarController extends StatelessWidget {
  const CarController({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    return Container(
      height: h*.3,
      width: w,
      child: Center(child: CarButton(),),
    );
  }
}
