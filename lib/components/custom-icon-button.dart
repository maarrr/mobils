import 'package:flutter/material.dart';

import '../constants.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final VoidCallback? onPressed;

  const CustomIconButton({Key? key, required this.icon, required this.size, required this.color, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        padding: EdgeInsets.all(16),
        tooltip: 'add',
        color: textColor,
        icon: Icon(icon, size: size),
        onPressed: onPressed
      ),
    );
  }
}