import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ImageUtils {

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> saveImage(BuildContext context, String generatedImage, String folder) async {
    if (generatedImage.isNotEmpty) {
      try {
        Uint8List bytes = base64.decode(generatedImage);

        // Create a reference to the Firebase Storage bucket
        final storageRef = firebase_storage.FirebaseStorage.instance.ref();

        // Generate a unique filename for the image
        User? user = _auth.currentUser;
        final uid = user!.uid;
        String filename = '$folder/image_${DateTime.now().millisecondsSinceEpoch}.png';
        final destination = '$uid/$filename';

        // Upload the image to Firebase Storage
        await storageRef.child(destination).putData(bytes);

        // Show a success message
        await showMessageDialog(context, 'Image saved to Firebase Storage');
      } catch (e) {
        // Show an error message
        await showMessageDialog(context, 'Error saving image: $e', isError: true);
      }
    } else {
      // Handle the case where no image is generated.
      await showMessageDialog(context, 'No image to save', isError: true);
    }
  }

  static Future<void> showMessageDialog(BuildContext context, String message, {bool isError = false}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isError ? 'Error' : 'Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}