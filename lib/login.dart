import 'package:flutter/material.dart';
import 'package:mobils/constants.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  bool _isError = false;

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
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.start,
                      onChanged: (value) {

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
                      keyboardType: TextInputType.visiblePassword,
                      textAlign: TextAlign.start,
                      onChanged: (value) {

                      },
                      decoration: decoration
                  ),
                  const SizedBox(height: 16),
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
                          /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(),
                      ),
                    );*/
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: mainColor,
                            fontSize: 18,
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shadowColor: secondaryColor,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: const Size(240, 60), //////// HERE
                      ),
                      onPressed: () {},
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