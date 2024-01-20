import 'package:flutter/material.dart';

import '../constants.dart';
import 'custom-text.dart';

class Button extends StatelessWidget {
  final String textText;
  final double sizeText;
  final VoidCallback? onPressed;

  const Button({Key? key, required this.textText, required this.sizeText, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shadowColor: primaryVariant,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)),
        padding: const EdgeInsets.all(16),
        minimumSize: const Size(240, 60),
      ),
      onPressed: onPressed,
      child: CustomText(text: textText, size: sizeText),
    );
  }
}