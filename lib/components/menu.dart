import 'package:flutter/material.dart';
import 'package:mobils/constants.dart';

import '../gallery.dart';
import '../main-screen.dart';
import '../profile.dart';
import '../smart_creator.dart';

class Menu extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const Menu({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: surfaceColor,
      selectedItemColor: primaryVariant,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Main',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.gesture),
          label: 'Generator',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo_library_outlined),
          label: 'Gallery',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.perm_identity_sharp),
          label: 'Profile',
        ),
      ],
    );
  }

  static void navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SmartCreatorScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GalleryScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
      default:
        break;
    }
  }
}