import 'package:flutter/material.dart';

class CarButton extends StatelessWidget {
  final double rotate;
  const CarButton({
    super.key,
    this.rotate = 0,
  });

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double angle = (3.1416 * rotate) / 180;

    return Transform.rotate(
      angle: angle,
      child: ClipPath(
        clipper: CustomClipPath(),
        child: Container(
          height: h * .3,
          width: h * .25,
          decoration: BoxDecoration(
            color: Color(0xFF93B1A6),
            shape: BoxShape.values[0],
          ),
          child: Icon(
            Icons.keyboard_double_arrow_up,
            color: Color(0xFF183D3D),
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
    path_0.moveTo(w * 0.4166667, h * 0.6000000);
    path_0.lineTo(w * 0.5833333, h * 0.6000000);
    path_0.lineTo(w * 0.5833333, h * 0.4600000);
    path_0.quadraticBezierTo(
        w * 0.5008333, h * 0.3115000, w * 0.5000000, h * 0.3500000);
    path_0.quadraticBezierTo(
        w * 0.5008333, h * 0.3115000, w * 0.4166667, h * 0.4600000);

    return path_0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
