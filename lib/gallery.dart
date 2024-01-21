import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mobils/components/button-text-icon.dart';
import 'package:mobils/components/header.dart';
import 'package:mobils/components/wrap-list.dart';
import 'package:mobils/utils.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as img;

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
  bool _isLoading = false;

  late StreamController<List<String>> imageUrlsController;

  Stream<List<String>> get imageUrlsStream => imageUrlsController.stream;

  @override
  void initState() {
    super.initState();

    imageUrlsController = StreamController<List<String>>.broadcast();
    _getImagesGallery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: const Header(),
        body:Padding(
              padding: const EdgeInsets.all(margin),
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
                            await _pickMedia(ImageSource.camera);
                            setState(() {_isLoading = true;});
                            await _getImagesGallery();
                            setState(() {_isLoading = false;});
                            },
                      ),
                      ButtonTextIcon(
                        text: "Gallery",
                        size: 24,
                        icon: Icons.photo_library_outlined,
                        color: primaryVariant,
                        onPressed: () async {
                          await _pickMedia(ImageSource.gallery);
                          setState(() {_isLoading = true;});
                          await _getImagesGallery();
                          setState(() {_isLoading = false;});
                        },
                      ),
                    ],
                  ),
                   const SizedBox(height: 16),
                   Expanded(child:
                      StreamBuilder<List<String>>(
                        stream: imageUrlsStream,
                        builder: (context, snapshot) {
                            if (!_isLoading && snapshot.hasData) {
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
                              return const Center(
                                child: SpinKitCircle(
                                  color: primaryColor,
                                  size: 100.0,
                                ),
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


  Future<void> _pickMedia(ImageSource source) async {
    XFile? file;
    file = await ImagePicker().pickImage(source: source);

    if (file != null) {
      imagePath = file.path;
      await _uploadFile();
    }
  }

  Future<void> _uploadFile() async {
    if (imagePath == null) return;
    File fileToUpload = File(imagePath as String);
    final fileName = basename(fileToUpload.path);

    User? user = FirebaseAuth.instance.currentUser;
    if(user == null) {
      print("Error");
      return;
    }

    final destination = '${user.uid}/$fileName';

    Uint8List squaredImageBytes = await _cropImageToSquare(fileToUpload);

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(destination);
      await ref.putData(squaredImageBytes);
    } catch (e) {
      print('error occured $e');
    }

  }

  Future<Uint8List> _cropImageToSquare(File imageFile) async {
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

  _getImagesGallery() async {
    imageUrlsController.add(await ImageUtils.getAllImagesFromStorage("gallery"));

  }


}