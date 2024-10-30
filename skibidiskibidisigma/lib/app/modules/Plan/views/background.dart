import '../views/appColor.dart';
import 'package:flutter/material.dart';

class WidgetBackground extends StatelessWidget {
  final AppColor appColor = AppColor();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -164,
          right: -8.0,
          child: Container(
            width: 256.0,
            height: 256.0,
            decoration: BoxDecoration(
              backgroundBlendMode: BlendMode.hardLight,
              color: Color.fromARGB(255, 247, 247, 247),
            ),
          ),
        )
      ],
    );
  }
}