import 'dart:convert';
import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:mobils/components/button.dart';
import 'package:mobils/components/custom-text.dart';
import 'package:path_provider/path_provider.dart';

import 'components/button-text-icon.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'package:mobils/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PhotoScreen extends StatefulWidget {
  final image;

  const PhotoScreen({Key? key, this.image}) : super(key: key);

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
 bool _isLoading = false;
 String _generatedImage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const CustomText(text: "PixelGenius", size: 24),
          centerTitle: true,
          backgroundColor: backgroundColor,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp, color: textColor),
              onPressed: () {
                Navigator.of(context).pop();
              },
          )
        ),
        body:Padding(
        padding: const EdgeInsets.all(margin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                  textText: "Edit photo by IA",
                  sizeText: 24,
                  onPressed: _generateVariations,
                  color: primaryColor
              ),
              const SizedBox(height: 30),
              _isLoading ?
                const AspectRatio (
                  aspectRatio: 1.0 / 1.0,
                  child: SpinKitSpinningLines(
                    color: primaryColor,
                    size: 160.0,
                    duration: Duration(seconds: 2),
                  ),
                )
                  : _generatedImage.isNotEmpty ?
                  AspectRatio(
                      aspectRatio: 1.0 / 1.0,
                      child: Image.memory(
                        base64.decode(_generatedImage),
                        fit: BoxFit.cover,
                      )
                  ) : AspectRatio (
                    aspectRatio: 1.0 / 1.0,
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
              const SizedBox(height: 30),
              _generatedImage.isNotEmpty ?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ButtonTextIcon(
                    text: "Save",
                    size: 18,
                    color: primaryColor,
                    icon: Icons.save_alt,
                    onPressed: _save,
                  ),
                  ButtonTextIcon(
                    text: "Undo",
                    size: 18,
                    color: primaryVariant,
                    icon: Icons.undo,
                    onPressed: _undo,
                  ),
              ]
              ) : const SizedBox(height: 30),

            ],
          ),

        ),
    );
  }

  void _generateVariations() async {
    String imagePath = await downloadImage(widget.image);

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
      setState(() {
        _generatedImage = imageVariation.data[0].b64Json.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> downloadImage(String imageUrl) async {
    try {
      http.Response response = await http.get(Uri.parse(imageUrl));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Get the app's documents directory
        Directory appDocDir = await getApplicationDocumentsDirectory();

        // Define the file path where the image will be saved
        String filePath = '${appDocDir.path}/downloaded_image.jpg';

        // Write the image data to a file
        File imageFile = File(filePath);
        await imageFile.writeAsBytes(response.bodyBytes);

        // Show a success message or navigate to a different screen
        print('Image downloaded successfully: $filePath');

        return filePath;

      } else {
        // Handle errors, e.g., display an error message
        print('Failed to download image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions, e.g., display an error message
      print('Error downloading image: $e');
    }

    return "";
  }

  _undo(){
    setState(() {
      _generatedImage = '';
    });
  }

 _save() async {
   if (_generatedImage.isNotEmpty) {
     ImageUtils.saveImage(context, _generatedImage, "edits");
   } else {
      // Handle the case where no image is generated.
      await ImageUtils.showMessageDialog(context, 'No image to save', isError: true);
   }
 }



}