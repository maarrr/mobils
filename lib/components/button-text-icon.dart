
import 'package:flutter/material.dart';

import '../constants.dart';
import 'custom-text.dart';

class ButtonTextIcon extends StatelessWidget {
  final String text;
  final double size;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const ButtonTextIcon({Key? key,
    required this.text,
    required this.size,
    required this.icon,
    required this.color,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: textColor), // Icon on the left
      label: CustomText(text: text, size: size) , // Text on the right
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shadowColor: primaryVariant,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)),
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}