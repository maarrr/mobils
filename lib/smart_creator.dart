import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mobils/constants.dart';
import 'package:mobils/store.dart';

import 'components/bottom-menu.dart';

class SmartCreatorScreen extends StatefulWidget {
  const SmartCreatorScreen({Key? key}) : super(key: key);

  @override
  _SmartCreatorScreenState createState() => _SmartCreatorScreenState();
}

class _SmartCreatorScreenState extends State<SmartCreatorScreen> {
  TextEditingController _descriptionController = TextEditingController();
  String _generatedImage = '';
  bool _isLoading = false;

  void _generateImage() async {
    setState(() {
      _isLoading = true;
      _generatedImage = ''; // Reset the previous image

    });

    try {
      OpenAIImageModel image = await OpenAI.instance.image.create(
        prompt: "${_descriptionController.text}",
        n: 1,
        size: OpenAIImageSize.size1024,
        responseFormat: OpenAIImageResponseFormat.b64Json,
      );

      setState(() {
        _generatedImage = image.data[0].b64Json.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveImage(String base64Image) async {
    if (_generatedImage.isNotEmpty) {
      try {
        Uint8List bytes = base64.decode(_generatedImage);

        // Create a reference to the Firebase Storage bucket
        final storageRef = firebase_storage.FirebaseStorage.instance.ref();

        // Generate a unique filename for the image
        final uid = await Store.getUser();
        String filename = 'creations/image_${DateTime.now().millisecondsSinceEpoch}.png';
        final destination = '$uid/$filename';

        // Upload the image to Firebase Storage
        await storageRef.child(destination).putData(bytes);

        // Show a success message
        await _showMessageDialog('Image saved to Firebase Storage');
      } catch (e) {
        // Show an error message
        await _showMessageDialog('Error saving image: $e', isError: true);
      }
    } else {
      // Handle the case where no image is generated.
      await _showMessageDialog('No image to save', isError: true);
    }
  }


  Future<void> _showMessageDialog(String message, {bool isError = false}) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Image Generator', style: TextStyle(color: textColor)),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoading
                ? SpinKitSpinningLines(
              color: primaryColor,
              size: 160.0,
              duration: const Duration(seconds: 2),
            )
                : _generatedImage.isNotEmpty
                ? Image.memory(
              base64.decode(_generatedImage),
              height: 250,
              width: 250,
              fit: BoxFit.cover,
            )
                : Container(
              width: 250,
              height: 250,
              margin: EdgeInsets.only(bottom: 30),
              color: backgroundColor,
              child: SpinKitCubeGrid(
                color: primaryColor,
                size: 160.0,
                duration: const Duration(seconds: 2),
              )
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: "Input your image description...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _generateImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: textColor,
                  ),
                  child: Text('Generate Image'),
                ),
                ElevatedButton(
                  onPressed: () => _saveImage(_generatedImage),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: textColor,
                  ),
                  child: Text('Save Image'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}
