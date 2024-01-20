import 'package:flutter/material.dart';
import 'package:mobils/constants.dart';
import 'package:mobils/photo.dart';

class WrapList extends StatelessWidget {
  final List<String> images;
  final int elementPerRow;
  final VoidCallback onReturn;

  const WrapList({Key? key, required this.images, required this.elementPerRow, this.onReturn = _defaultCallback }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return
          GridView.builder(
               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 4,
                 childAspectRatio: 1.0,
               ),
               itemCount: images.length,
               itemBuilder: (BuildContext context, int index) {
                 return Card(
                   color: surfaceColor,
                   child: InkWell(
                     onTap: () {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (context) => PhotoScreen(
                             image: images[index],
                           ),
                         ),
                       ).then((value) => onReturn());
                     },
                     child: Padding(
                       padding: const EdgeInsets.all(4.0), // adjust as needed
                       child: AspectRatio(
                         aspectRatio: 1,
                         child: ClipRRect(
                           borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                           child: Image.network(
                             images[index],
                             fit: BoxFit.cover,
                           ),
                         ),
                       ),
                     ),
                   ),
                 );
               },
           );
  }

  // Default callback function (you can customize this based on your needs)
  static void _defaultCallback() {
  }

}