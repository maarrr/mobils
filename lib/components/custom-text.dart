import 'package:flutter/material.dart';

import '../constants.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;

  const CustomText({Key? key, required this.text, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(text,
      style: TextStyle(
        color: textColor,
        fontSize: size,
        fontFamily: fontFamily,
      ),
    );
  }
}
