import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/common/client/client_connect.dart';
import '../../../../injection_Container.dart';

class CarButton extends StatefulWidget {
  final double rotate;
  final String move;
  const CarButton({
    super.key,
    this.rotate = 0,
    required this.move,
  });

  @override
  State<CarButton> createState() => _CarButtonState();
}

class _CarButtonState extends State<CarButton> {
  bool tapped = false, sentData = false;
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double angle = (3.1416 * widget.rotate) / 180;

    return Transform.rotate(
      angle: angle,
      child: InkWell(
        onTapDown: (_) {
          setState(() {
            tapped = true;
          });
          timer =
              Timer.periodic(const Duration(milliseconds: 100), (timer) async {
            sentData = await serviceLocator<BLEService>().sendData(widget.move);
          });
          if (!sentData) {
            timer?.cancel();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(milliseconds: 1500),
                content: Text("Unfortunately buttons not working"),
              ),
            );
          }
        },
        onTapUp: (_) {
          setState(() {
            tapped = false;
          });
          timer?.cancel();
        },
        child: ClipPath(
          clipper: CustomClipPath(),
          child: Container(
            height: h * .08,
            width: h * .05,
            decoration: BoxDecoration(
              color: tapped ? Colors.white : Color(0xFF93B1A6),
              shape: BoxShape.values[0],
            ),
            child: Icon(
              Icons.keyboard_double_arrow_up,
              color: Color(0xFF183D3D),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    Path path_0 = Path();
    path_0.moveTo(0, h * 0.5028571);
    path_0.lineTo(0, h);
    path_0.lineTo(w, h);
    path_0.lineTo(w, h * 0.4985714);
    path_0.quadraticBezierTo(w * 0.4811667, h * -0.0788429, w * 0.4991667, 0);
    path_0.quadraticBezierTo(w * 0.5087583, h * -0.0664143, 0, h * 0.5028571);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
