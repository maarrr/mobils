import 'package:flutter/material.dart';
import 'package:mobils/components/button.dart';
import 'package:mobils/login.dart';
import 'package:mobils/sign-in.dart';

import 'constants.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  _FirstScreenState createState() => _FirstScreenState();
}


class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: Padding(
        padding: const EdgeInsets.all(margin),
      child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kToolbarHeight),
            const Text("PixelGenius",
              style: TextStyle(
                color: primaryVariant,
                fontSize: 62,
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text("Ignite Your Creativity with AI Photo Wizardry.",
              style: TextStyle(
                color: textColor,
                fontSize: 48,
                fontFamily: fontFamily,
                fontStyle: FontStyle.italic,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Button(
                      textText: "Login",
                      sizeText: 24,
                      color: primaryColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Button(
                      textText: "Sign In",
                      sizeText: 24,
                      color: primaryVariant,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

}