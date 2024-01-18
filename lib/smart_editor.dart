import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';

class MyImageEditor extends StatefulWidget {

  const MyImageEditor({Key? key}) : super(key: key);

  @override
  _MyImageEditorState createState() => _MyImageEditorState();
}

class _MyImageEditorState extends State<MyImageEditor> {
  String _image = "";
  Color selectedColor = Colors.black;
  List<List<Offset>> strokes = [];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile!.path.toString();
      strokes.clear(); // Clear previous drawings when a new image is picked
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Editor'),
      ),
      body: Column(
        children: [
          _image == null
              ? Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
            ),
          )
              : Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                setState(() {
                  strokes.last.add(renderBox.globalToLocal(details.globalPosition));
                });
              },
              onPanEnd: (details) {
                strokes.add([]); // Start a new stroke
              },
              child: CustomPaint(
                painter: MyPainter(PickedFile(_image), strokes, selectedColor),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pick a color'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: selectedColor,
                            onColorChanged: (color) {
                              setState(() {
                                selectedColor = color;
                              });
                            },
                            showLabel: true,
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Done'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Pick Color'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final PickedFile image;
  final List<List<Offset>> strokes;
  final Color color;

  MyPainter(this.image, this.strokes, this.color);

  @override
  void paint(Canvas canvas, Size size) async {
    final img = await decodeImageFromList(await File(this.image.path).readAsBytes());
    canvas.drawImage(img, Offset.zero, Paint());

    Paint paint = Paint()
      ..color = color.withOpacity(0.5) // Set opacity for the drawn area
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (var stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        if (stroke[i] != null && stroke[i + 1] != null) {
          canvas.drawLine(stroke[i], stroke[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
