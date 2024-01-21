import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mobils/components/header.dart';
import 'package:mobils/constants.dart';
import 'package:mobils/utils.dart';

import 'components/menu.dart';

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


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const Header(),
      body: SingleChildScrollView(
        child: Padding(
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
                ),
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
                    onPressed: () => ImageUtils.saveImage(context, _generatedImage, "creations"),
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
      ),
      bottomNavigationBar: Menu(
        currentIndex: 1,
        onTap: (index) {
          Menu.navigateToScreen(context, index);
        },
      ),
    );
  }
}
