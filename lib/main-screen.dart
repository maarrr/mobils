import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mobils/components/bottom-menu.dart';
import 'package:mobils/components/custom-icon-button.dart';
import 'package:mobils/components/custom-text.dart';
import 'package:mobils/components/header.dart';
import 'package:mobils/components/menu.dart';
import 'package:mobils/photo.dart';
import 'package:mobils/smart_creator.dart';
import 'package:mobils/store.dart';
import 'package:mobils/components/wrap-list.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as img;

import 'package:dart_openai/dart_openai.dart';

import 'constants.dart';



class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late String _username = 'No name';

  late StreamController<List<String>> editController;
  late StreamController<List<String>> generateController;

  Stream<List<String>> get imageEditStream => editController.stream;

  Stream<List<String>> get imageGenerateStream => generateController.stream;


  @override
  initState() {
    super.initState();
    getName();
    start();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const Header(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(text: "Welcome $_username!", size: 38),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(text: "Generated images", size: 24),
                CustomIconButton(
                    icon: Icons.add,
                    size: 24,
                    color: primaryVariant,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SmartCreatorScreen(),
                        ),
                      );
                    },
                ),
              ],
            ),
          Expanded(
            child:
            StreamBuilder<List<String>>(
              stream: imageGenerateStream, // a stream of image URLs
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // the stream has data
                  final imageUrls = snapshot.data;
                  if(imageUrls!.isEmpty) {
                    return const Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: CustomText(
                            text: "No generated images yet.",
                            size: 18
                        ));
                  } else {
                    return WrapList(images: imageUrls!, elementPerRow: 4);
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: "Edited images", size: 24),
              ],
            ),
          Expanded(
            child:
            StreamBuilder<List<String>>(
              stream: imageEditStream, // a stream of image URLs
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // the stream has data
                  final imageUrls = snapshot.data;
                  if(imageUrls!.isEmpty) {
                    return const Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: CustomText(
                            text: "No edited images yet.",
                            size: 18
                        ));
                  } else {
                    return WrapList(images: imageUrls!, elementPerRow: 4);
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          )
          ],
        )
      ),
      bottomNavigationBar: Menu(
        currentIndex: 0,
        onTap: (index) {
          Menu.navigateToScreen(context, index);
        },
      ),
    );
  }


  Future<List<String>> getAllImagesFromStorage(String folder) async {

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

      return imageUrls;

    } catch (e) {
      // Handle errors, if any
      print('Error getting images from Firebase Storage: $e');
    }

    return [];


  }

  Future<void> start() async {
    editController = StreamController<List<String>>.broadcast();
    generateController = StreamController<List<String>>.broadcast();

    final user = await Store.getUser();
    final editPath = '$user/edits';
    final createPath = '$user/creations';

    generateController.add(await getAllImagesFromStorage(createPath));

    editController.add(await getAllImagesFromStorage(editPath));
  }

  getName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null){
      setState(() {
        _username = user.displayName ?? 'no name';
      });
    }
  }
}