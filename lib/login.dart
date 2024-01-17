import 'package:flutter/material.dart';
import 'package:mobils/sign-in.dart';

const decoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);


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
      backgroundColor: Colors.grey[900],
      body:
      Padding(
        padding: const EdgeInsets.all(32.0), // Adjust the value as needed
        child: Center(
          child: Column(
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child:
              Column(
                children: [
                  SizedBox(height: 16),
                  Text(
                    'PixelGenius',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: 'Work Sans',
                    ),
                  ),
                ]
              )
            ),


            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Email", style: TextStyle(
                    color: Colors.white,
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
                  SizedBox(height: 16),
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
                  SizedBox(height: 16),
                  Row(

                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Work Sans',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Perform some action
                    },
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple,
                      onPrimary: Colors.blue,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}