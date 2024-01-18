import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dart_openai/dart_openai.dart';

import 'constants.dart';



class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? imagePath;
  String? maskPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'PixelGenius',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontFamily: 'Work Sans',
            ),
          ),
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          shadowColor: secondaryColor,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          minimumSize: const Size(42,42), //////// HERE
                        ),
                        onPressed: () {pickMedia(ImageSource.camera);},
                        child: addButtonStyle("", Icons.camera_alt)
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          shadowColor: secondaryColor,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          minimumSize: const Size(42,42), //////// HERE
                        ),
                        onPressed: () async {
                          imagePath = await pickMedia(ImageSource.gallery);
                          maskPath = await pickMedia(ImageSource.gallery);
                          setState(() {});

                          OpenAIImageModel imageEdits = await OpenAI.instance.image.edit(
                            prompt: 'mask the image with color red',
                            image: File(imagePath as String),
                            mask: File(maskPath as String),
                            n: 1,
                            size: OpenAIImageSize.size1024,
                            responseFormat: OpenAIImageResponseFormat.url,
                          );

                          for (int index = 0; index < imageEdits.data.length; index++) {
                            final currentItem = imageEdits.data[index].url.toString();
                            print(currentItem);
                          }

                          },
                        child: addButtonStyle("", Icons.add)
                    )
                  ],
                ),
                (imagePath != null)
                    ? Image.file(File(imagePath as String))
                    : Container(
                  width: 300,
                  height: 300,
                  color: Colors.grey[300]!,
                ),

              ],
            ),
          )
        )
    );
  }


  Future<String?> pickMedia(ImageSource source) async {
    XFile? file;
    file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      return file.path.toString();
    }
    return null;
  }
}

Widget addButtonStyle(String msg, IconData icon) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: textColor,
          size: 24,
        ),
        /*SizedBox(width: 8), // Adjust the space between icon and text
        Text(
          msg,
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontFamily: 'Work Sans',
          ),
        ),*/
      ],);
}