import 'package:carry_bot/features/device/domain/entity/sensor_entity.dart';
import 'package:flutter/material.dart';

class SensorDataShow extends StatefulWidget {
  final bool minimize;
  final SensorEntity sensor;
  const SensorDataShow({
    super.key,
    this.minimize = false,
    required this.sensor,
  });

  @override
  State<SensorDataShow> createState() => _SensorDataShowState();
}

class _SensorDataShowState extends State<SensorDataShow> {
  double height = 0, width = 0;
  Color color = Colors.grey;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;

    switch (widget.sensor.situation) {
      case "G":
        color = Colors.green;
        break;
      case "Y":
        color = Colors.yellow;
        break;
      case "R":
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
        break;
    }

    if (widget.minimize) {
      height = h * .2;
      width = w * .45;
    } else {
      height = h * .28;
      width = w * .6;
    }

    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color(0xFF183D3D),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              widget.minimize
                  ? SizedBox(
                      width: w,
                    )
                  : Text(
                      widget.sensor.name!,
                      style: TextStyle(
                        color: Color(0xFF93B1A6),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: widget.minimize ? height * .6 : height * .55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: color,
                  ),
                ),
              ),
              Text(
                widget.minimize
                    ? "${widget.sensor.name!.split(" ")[0]} : ${widget.sensor.value}"
                    : "Value : ${widget.sensor.value}",
                style: TextStyle(
                    color: Color(0xFF93B1A6),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
