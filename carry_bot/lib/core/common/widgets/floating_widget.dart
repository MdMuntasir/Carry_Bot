import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FloatingWidgetManager {
  static OverlayEntry? _overlayEntry;

  static void showFloatingWidget(BuildContext context, String message) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => FloatingWidget(message: message),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void removeFloatingWidget() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class FloatingWidget extends StatefulWidget {
  final String message;
  const FloatingWidget({super.key, required this.message});

  @override
  _FloatingWidgetState createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget> {
  Offset position = Offset(10, 150);
  bool messageShowed = true;
  Timer? timer;
  void onTap() {
    setState(() {
      messageShowed = !messageShowed;
    });
  }

  void resetTimer() {
    timer?.cancel();
    timer = Timer(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          messageShowed = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    resetTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position += details.delta;
          });
        },
        onDoubleTap: () => FloatingWidgetManager.removeFloatingWidget(),
        child: Material(
          color: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF93B1A6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    FontAwesomeIcons.car,
                    color: Color(0xFF183D3D),
                    size: 35,
                  ),
                ),
              ),
              SizedBox(width: 8),
              AnimatedContainer(
                width: messageShowed ? 180 : 0,
                height: 40,
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF183D3D),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                ),
                child: messageShowed
                    ? Text(
                        widget.message,
                        style: TextStyle(color: Colors.white),
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
