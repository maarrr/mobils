import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';


import 'constants.dart';



class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? imagePath;
  // A reference to the Firebase Storage bucket
  final storageRef = FirebaseStorage.instance.ref().child('photos');

  // A stream of the photos in the Firebase Storage bucket
  late Stream<List<Reference>> photosStream;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    photosStream = storageRef.listAll().asStream().map((result) => result.items);
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
                          onPressed: () {
                            pickMedia(ImageSource.gallery);
                          },
                          child: addButtonStyle("", Icons.add)
                      )
                    ],
                  ),
                  StreamBuilder<List<Reference>>(
                  stream: photosStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // The photos are available
                      final photos = snapshot.data;
                      return ListView.builder(
                        itemCount: photos?.length,
                        itemBuilder: (context, index) {
                          // Display each photo in a Card widget
                          return Card(
                            child: ListTile(
                              leading: FutureBuilder<String>(
                                future: photos?[index].getDownloadURL(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    // The download URL is available
                                    final url = snapshot.data;
                                    return Image.network(url!);
                                  } else {
                                    // The download URL is not available yet
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                              title: Text(photos![index].name),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Delete the photo from Firebase Storage
                                  photos[index].delete();
                                },
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      // The photos are not available yet
                      return Center(child: CircularProgressIndicator());
                    }
                  })

                ],
              ),
            )
        )
    );
  }


  void pickMedia(ImageSource source) async {
    XFile? file;
    file = await ImagePicker().pickImage(source: source);

    if (file != null) {
      imagePath = file.path;
      uploadFile();
      setState(() {});
    }
  }

  Future uploadFile() async {
    if (imagePath == null) return;
    final fileName = basename(File(imagePath as String).path);
    final destination = 'files/$fileName';

    print(fileName);

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(File(imagePath as String));
    } catch (e) {
      print('error occured $e');
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
}