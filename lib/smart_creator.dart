import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:mobils/components/button.dart';
import 'package:mobils/components/header.dart';
import 'package:mobils/constants.dart';
import 'package:mobils/utils.dart';
import 'package:mobils/components/button-text-icon.dart';
import 'package:mobils/components/menu.dart';

class SmartCreatorScreen extends StatefulWidget {
  const SmartCreatorScreen({Key? key}) : super(key: key);

  @override
  _SmartCreatorScreenState createState() => _SmartCreatorScreenState();
}

class _SmartCreatorScreenState extends State<SmartCreatorScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String _generatedImage = '';
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const Header(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(margin),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _isLoading
                  ? const SpinKitSpinningLines(
                      color: primaryColor,
                      size: 280.0,
                      duration: Duration(seconds: 2),
                    )
                  : _generatedImage.isNotEmpty ? Image.memory(
                      base64.decode(_generatedImage),
                      height: 280,
                      width: 280,
                      fit: BoxFit.cover,
                    )
                  : Container(
                    width: 280,
                    height: 280,
                    margin: const EdgeInsets.only(bottom: 30),
                    color: backgroundColor,
                    child: const SpinKitCubeGrid(
                      color: primaryColor,
                      size: 200.0,
                      duration: Duration(seconds: 2),
                    ),
                  ),
              const SizedBox(height: 16),
              _generatedImage.isNotEmpty && !_isLoading ?
                  ButtonTextIcon(
                    text: "Save",
                    size: 18,
                    color: primaryVariant,
                    icon: Icons.save_alt,
                    onPressed: () => ImageUtils.saveImage(context, _generatedImage, "creations"),
                  )
              : const SizedBox(height: 16),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                style:
                const TextStyle(color: textColor),
                decoration: const InputDecoration(
                  hintText: "Write your thoughts...",  // Use hintText instead of labelText
                  hintStyle: TextStyle(
                    color: textColor, // Adjust opacity for a subtle hint
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Button(
                textText: 'Generate Image',
                sizeText: 24,
                color: primaryColor,
                onPressed: _generateImage,
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


}
