import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mobils/constants.dart';

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
        // Download the image bytes
        var response = await http.get(Uri.parse(_generatedImage));
        Uint8List bytes = response.bodyBytes;

        // Create a reference to the Firebase Storage bucket
        final storageRef = firebase_storage.FirebaseStorage.instance.ref();

        // Generate a unique filename for the image
        String filename = 'image_${DateTime.now().millisecondsSinceEpoch}.png';

        // Upload the image to Firebase Storage
        await storageRef.child(filename).putData(bytes);

        // Show a success message or perform any other actions after uploading to Firebase Storage
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Image saved to Firebase Storage"),
          ),
        );
      } catch (e) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error saving image: $e"),
          ),
        );
      }
    } else {
      // Handle the case where no image is generated.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No image to save"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Image Generator', style: TextStyle(color: textColor)),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoading
                ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(mainColor),
            )
                : _generatedImage.isNotEmpty
                ? Image.memory(
              base64.decode(_generatedImage),
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            )
                : Container(
              width: 200,
              height: 200,
              color: Colors.grey,
              child: Icon(
                Icons.image,
                size: 100,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: 'Describe the image...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                labelStyle: TextStyle(color: mainColor),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _generateImage,
                  style: ElevatedButton.styleFrom(
                    primary: mainColor,
                    onPrimary: textColor,
                  ),
                  child: Text('Generate Image'),
                ),
                ElevatedButton(
                  onPressed: () => _saveImage(_generatedImage),
                  style: ElevatedButton.styleFrom(
                    primary: mainColor,
                    onPrimary: textColor,
                  ),
                  child: Text('Save Image'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
