import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobils/components/custom-icon-button.dart';
import 'package:mobils/components/custom-text.dart';
import 'package:mobils/components/header.dart';
import 'package:mobils/components/menu.dart';
import 'package:mobils/smart_creator.dart';
import 'package:mobils/components/wrap-list.dart';
import 'package:mobils/utils.dart';


// spinkit
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    _getName();
    _start();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const Header(),
      body:
      Padding(
        padding: const EdgeInsets.all(margin),
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
                      ).then((value) => _onReturn());
                    },
                ),
              ],
            ),
          const SizedBox(height: 8),
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
                    return WrapList(images: imageUrls!, elementPerRow: 4, onReturn: _onReturn);
                  }
                } else {
                  return const Center(
                    child: SpinKitCircle(
                      color: primaryColor,
                      size: 100.0,
                    ),
                  );
                }
              },
            ),
          ),
            const SizedBox(height: 16),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: "Edited images", size: 24),
              ],
            ),
            const SizedBox(height: 4),
            Expanded(
              child:
              StreamBuilder<List<String>>(
                stream: imageEditStream, // a stream of image URLs
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final imageUrls = snapshot.data;
                    if(imageUrls!.isEmpty) {
                      return const Padding(
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: CustomText(
                              text: "No edited images yet.",
                              size: 18
                          )
                      );
                    } else {
                      return WrapList(images: imageUrls!, elementPerRow: 4, onReturn: _onReturn);
                    }
                  } else {
                    return const Center(
                      child: SpinKitCircle(
                        color: primaryColor,
                        size: 100.0,
                      ),
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

  void _onReturn() {
    _start();
    setState(() {});
  }



  Future<void> _start() async {
    editController = StreamController<List<String>>.broadcast();
    generateController = StreamController<List<String>>.broadcast();

    generateController.add(await ImageUtils.getAllImagesFromStorage("creations"));
    editController.add(await ImageUtils.getAllImagesFromStorage("edits"));
  }

  Future<void> _getName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null){
      setState(() {
        _username = user.displayName ?? 'no name';
      });
    }
  }
}