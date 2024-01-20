
import 'package:flutter/material.dart';
import 'package:mobils/components/custom-text.dart';
import 'package:mobils/constants.dart';

class Header extends StatelessWidget implements PreferredSizeWidget{

  const Header({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const CustomText(text: 'PixelGenius', size: 24),
      backgroundColor: surfaceColor,
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }



}