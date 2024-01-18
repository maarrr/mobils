import 'package:flutter/material.dart';
import 'package:mobils/constants.dart';
import 'package:mobils/gallery.dart';
import 'package:mobils/sign-in.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  bool isError = false;
  late String msg = "ERRROR";


  //final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'PixelGenius',
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontFamily: 'Work Sans',
          ),
        ),
        backgroundColor: backgroundColor,
        centerTitle: true,

      ),
      body:
      Padding(
        padding: const EdgeInsets.all(32.0), // Adjust the value as needed
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Email", style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontFamily: 'Work Sans',
                  )),
                  TextField(
                      style: const TextStyle(color: textColor),
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.start,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: decoration
                  ),
                  const SizedBox(height: 16),
                  const Text("Password", style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Work Sans',
                  )),
                  TextField(
                      style: const TextStyle(color: textColor),
                      obscureText: true,
                      textAlign: TextAlign.start,
                      onChanged: (value) {
                        password = value;
                        },
                      decoration: decoration
                  ),
                  const SizedBox(height: 16),
                  if(isError)
                    Column(
                      children: [
                        Text(
                          msg,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontFamily: 'Work Sans',
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Work Sans',
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                              ),
                          );
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 18,
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shadowColor: secondaryColor,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: const Size(240, 60), //////// HERE
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const GalleryScreen(),
                        ),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 24,
                          fontFamily: 'Work Sans',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        ),
      )
    );
  }
}