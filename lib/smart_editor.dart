import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mobils/constants.dart';


class SmartEditorScreen extends StatefulWidget {
  const SmartEditorScreen({Key? key}) : super(key: key);

  @override
  _SmartEditorScreenState createState() => _SmartEditorScreenState();
}

class _SmartEditorScreenState extends State<SmartEditorScreen> {
  String _generatedImage = '';
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String imagePath = pickedFile.path.toString();
      _generateVariations(imagePath);
    }
  }

  void _generateVariations(String imagePath) async {
    setState(() {
      _isLoading = true;
      _generatedImage = ''; // Reset the previous image
    });

    try {
      OpenAIImageModel imageVariation = await OpenAI.instance.image.variation(
        image: File(imagePath),
        n: 1,
        size: OpenAIImageSize.size1024,
        responseFormat: OpenAIImageResponseFormat.b64Json,
      );
      print(imageVariation.data[0].url.toString());
      setState(() {
        _generatedImage = imageVariation.data[0].b64Json.toString();
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
        Uri? imageUrl = Uri.tryParse(_generatedImage);
        if (imageUrl == null) {
          print("Invalid URL: $_generatedImage");
          return;
        }

        var response = await http.get(imageUrl);
        Uint8List bytes = response.bodyBytes;

        final storageRef = firebase_storage.FirebaseStorage.instance.ref();
        String filename = 'image_${DateTime.now().millisecondsSinceEpoch}.png';

        await storageRef.child(filename).putData(bytes);

        print("Image saved to Firebase Storage");
      } catch (e) {
        print("Error saving image: $e");
      }
    } else {
      print("No image to save");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Image variations Generator', style: TextStyle(color: textColor)),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoading
                ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
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

    );
  }
}
