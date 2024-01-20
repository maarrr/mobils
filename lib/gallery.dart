import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mobils/components/button-text-icon.dart';
import 'package:mobils/components/custom-icon-button.dart';
import 'package:mobils/components/header.dart';
import 'package:mobils/photo.dart';
import 'package:mobils/store.dart';
import 'package:mobils/components/wrap-list.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as img;

import 'package:dart_openai/dart_openai.dart';

import 'components/custom-text.dart';
import 'components/menu.dart';
import 'constants.dart';



class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? imagePath;

  // Declare a StreamController of List<String>
  late StreamController<List<String>> imageUrlsController;

// Declare a getter for the stream of image URLs
  Stream<List<String>> get imageUrlsStream => imageUrlsController.stream;


  @override
  void initState() {
    super.initState();
    imageUrlsController = StreamController<List<String>>.broadcast();
    getAllImagesFromStorage();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: Header(),
        body:Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonTextIcon(
                          text: "Camera",
                          size: 24,
                          icon: Icons.camera_alt,
                          color: primaryColor,
                          onPressed: () async {
                            pickMedia(ImageSource.camera);
                            getAllImagesFromStorage();
                            setState(() {});
                            },
                      ),
                      ButtonTextIcon(
                        text: "Gallery",
                        size: 24,
                        icon: Icons.photo_library_outlined,
                        color: primaryVariant,
                        onPressed: () async {
                          pickMedia(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                   SizedBox(height: 16),
                   Expanded(child:
                      StreamBuilder<List<String>>(
                        stream: imageUrlsStream, // a stream of image URLs
                        builder: (context, snapshot) {
                            if (snapshot.hasData) {
                            // the stream has data
                            final imageUrls = snapshot.data;
                            if(imageUrls!.isEmpty) {
                              return const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                  child: CustomText(
                                      text: "Gallery is empty. Add some images!",
                                      size: 18
                                  ));
                            } else {
                              return WrapList(images: imageUrls, elementPerRow: 3);
                            }
                          } else {
                            // the stream has no data yet
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      )
                   )
                ],
              ),
            ),
      bottomNavigationBar: Menu(
        currentIndex: 2,
        onTap: (index) {
          Menu.navigateToScreen(context, index);
        },
      ),
    );
  }


  void pickMedia(ImageSource source) async {
    XFile? file;
    file = await ImagePicker().pickImage(source: source);

    if (file != null) {
      imagePath = file.path;
      uploadFile();
    }

    getAllImagesFromStorage();
  }

  Future uploadFile() async {
    if (imagePath == null) return;
    File fileToUpload = File(imagePath as String);
    final fileName = basename(fileToUpload.path);

    User? user = FirebaseAuth.instance.currentUser;
    if(user == null) {
      print("Error");
      return;
    }

    final destination = '${user.uid}/$fileName';

    // Replace 'your_image_file_path.jpg' with the actual path to your image file
    Uint8List squaredImageBytes = await cropImageToSquare(fileToUpload);

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(destination);
      await ref.putData(squaredImageBytes);
    } catch (e) {
      print('error occured $e');
    }

  }

  Future<Uint8List> cropImageToSquare(File imageFile) async {
    // Read the image from file
    img.Image? originalImage = img.decodeImage(imageFile.readAsBytesSync());

    // Check if decoding was successful
    if (originalImage == null) {
      // Handle the case where decoding failed
      print('Error decoding image');
      return Uint8List(0); // Exit the function
    }

    // Determine the minimum dimension (width or height) to create a square image
    int minDimension = originalImage.width < originalImage.height
        ? originalImage.width
        : originalImage.height;

    // Calculate the cropping area
    int x = (originalImage.width - minDimension) ~/ 2;
    int y = (originalImage.height - minDimension) ~/ 2;

    // Crop the image
    img.Image squaredImage = img.copyCrop(originalImage, x: x, y:y, width: minDimension, height: minDimension);

    // Convert the image to bytes
    Uint8List croppedBytes = Uint8List.fromList(img.encodePng(squaredImage));

    return croppedBytes;
  }


  getAllImagesFromStorage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if(user == null) {
      print("Error");
      return;
    }
      final folder = await user.uid;

      try {
        // Reference to the folder in Firebase Storage
        Reference storageFolder = FirebaseStorage.instance.ref().child(folder!);

        // Retrieve a list of items (files and subdirectories) within the folder
        ListResult result = await storageFolder.listAll();

        List<String> imageUrls = [];

        // Filter and add only image URLs to the list
        for (var item in result.items) {
          String imageUrl = await item.getDownloadURL();
          print(imageUrl);
          imageUrls.add(imageUrl);


        }

        // Add the list of image URLs to the stream
        imageUrlsController.add(imageUrls);

      } catch (e) {
        // Handle errors, if any
        print('Error getting images from Firebase Storage: $e');
      }
    }


}