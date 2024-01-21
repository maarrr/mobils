import 'package:flutter/material.dart';

import 'custom-text.dart';

class Button extends StatelessWidget {
  final String textText;
  final double sizeText;
  final Color color;
  final VoidCallback? onPressed;

  const Button({Key? key, required this.textText, required this.sizeText, required this.onPressed, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)),
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
      ),
      onPressed: onPressed,
      child: CustomText(text: textText, size: sizeText),
    );
  }
}