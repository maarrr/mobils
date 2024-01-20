import 'package:flutter/material.dart';
import 'package:mobils/constants.dart';
import 'package:mobils/photo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingList extends StatelessWidget {
  final List<SpinKitCubeGrid> images;
  final int elementPerRow;
  final int count;

  // Declare the images list and initialize it in the constructor
  LoadingList({Key? key, required this.elementPerRow, required this.count })
      : images = List<SpinKitCubeGrid>.generate(
    count,
        (index) => SpinKitCubeGrid(
      color: primaryColor,
      size: 50.0,
    ),
  ), super(key: key);

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
            child: Padding(
              padding: const EdgeInsets.all(4.0), // adjust as needed
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  child: images[index],
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