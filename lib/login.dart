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
            Align(
              alignment: Alignment.topCenter,

              child:
              Column(
                children: [
                  SizedBox(height: 8),
                  Text(
                    'PixelGenius',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                ]
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Text("Email", style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  )),
                  TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {

                      },
                      decoration: decoration.copyWith(
                          label: Text('Email'),
                      )
                  ),
                  SizedBox(height: 16),
                  TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: decoration.copyWith(
                        label: Text('Password'),
                      )
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
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