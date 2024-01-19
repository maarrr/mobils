import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobils/bottom-menu.dart';
import 'package:mobils/store.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as img;

import 'package:dart_openai/dart_openai.dart';

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

  // A stream of the photos in the Firebase Storage bucket
  late Stream<List<Reference>> photosStream;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final storageRef = FirebaseStorage.instance.ref();




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
        body:Padding(
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
                            backgroundColor: primaryColor,
                            shadowColor: secondaryColor,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                            minimumSize: const Size(42, 42), //////// HERE
                          ),
                          onPressed: () {
                            pickMedia(ImageSource.camera);
                          },
                          child: addButtonStyle("", Icons.camera_alt)
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shadowColor: secondaryColor,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                            minimumSize: const Size(42, 42), //////// HERE
                          ),
                          onPressed: () async {
                              imagePath = await pickMediaStr(ImageSource.gallery);
                              uploadFile();
                              setState(() {});
                          },
                          child: addButtonStyle("", Icons.add)
                      )
                    ],
                  ),
                   Expanded(child: StreamBuilder<List<String>>(
                        stream: imageUrlsStream, // a stream of image URLs
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // the stream has data
                            final imageUrls = snapshot.data;
                            return ListView.builder(
                              itemCount: imageUrls?.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Image.network(imageUrls![index]),
                                );
                              },
                            );
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
        bottomNavigationBar: const BottomMenu(),
    );
  }


  void pickMedia(ImageSource source) async {
    XFile? file;
    file = await ImagePicker().pickImage(source: source);

    if (file != null) {
      imagePath = file.path;
      setState(() {});
    }
  }

  Future<String?> pickMediaStr(ImageSource source) async {
    XFile? file;
    file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      return file.path.toString();
    }
    return null;
  }

  Future uploadFile() async {
    if (imagePath == null) return;
    File fileToUpload = File(imagePath as String);
    final fileName = basename(fileToUpload.path);
    final uid = await Store.getUser();
    final destination = '$uid/$fileName';

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

    getAllImagesFromStorage();
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
    final folder = await Store.getUser();

    try {
      // Reference to the folder in Firebase Storage
      Reference storageFolder = FirebaseStorage.instance.ref().child(folder!);

      // Retrieve a list of items (files and subdirectories) within the folder
      ListResult result = await storageFolder.listAll();

      print("result:");
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