
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mobils/constants.dart';
import 'package:mobils/main-screen.dart';
import 'package:mobils/profile.dart';
import 'package:mobils/smart_creator.dart';
import 'package:mobils/smart_editor.dart';

import '../gallery.dart';

const iconSize = 36.00;

class BottomMenu extends StatelessWidget {

  const BottomMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: surfaceColor,
      child: IconTheme(
        data: const IconThemeData(color: primaryColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              tooltip: 'Main',
              icon: const Icon(Icons.home, size: iconSize),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
                  ),
                );
              },
            ),
            IconButton(
              tooltip: 'Gallery',
              icon: const Icon(Icons.photo_library_outlined, size: iconSize),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GalleryScreen(),
                  ),
                );
              },
            ),
            IconButton(
              tooltip: 'Generate',
              icon: const Icon(Icons.add_photo_alternate_outlined,  size: iconSize),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SmartCreatorScreen(),
                  ),
                );
              },
            ),
            IconButton(
              tooltip: 'Profile',
              icon: const Icon(Icons.perm_identity_sharp, size: iconSize),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }


}