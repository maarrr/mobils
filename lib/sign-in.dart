import 'package:flutter/material.dart';
import 'package:mobils/constants.dart';


class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}


class _SignInScreenState extends State<SignInScreen> {
  late String email;
  late String name;
  late String password;
  late String confirmPassword;
  bool isError = false;
  late String msg;

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
        SingleChildScrollView(
          child:
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 64, 32, 16), // Adjust the value as needed
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Name", style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontFamily: 'Work Sans',
                  )),
                  TextField(
                      keyboardType: TextInputType.name,
                      style: const TextStyle(color: textColor),
                      textAlign: TextAlign.start,
                      onChanged: (value) { name = value; },
                      decoration: decoration
                  ),
                  const SizedBox(height: 16),

                  const Text("Email", style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontFamily: 'Work Sans',
                  )),
                  TextField(
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: textColor),
                      textAlign: TextAlign.start,
                      onChanged: (value) { email = value;},
                      decoration: decoration
                  ),
                  const SizedBox(height: 16),

                  const Text("Password", style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontFamily: 'Work Sans',
                  )),
                  TextField(
                      obscureText: true,
                      style: const TextStyle(color: textColor),
                      textAlign: TextAlign.start,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: decoration
                  ),
                  const SizedBox(height: 16),

                  const Text("Confirm password", style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontFamily: 'Work Sans',
                  )),
                  TextField(
                      obscureText: true,
                      style: const TextStyle(color: textColor),
                      textAlign: TextAlign.start,
                      onChanged: (value) {
                        confirmPassword = value;
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
                        "Already have an account?",
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
                          'Login',
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
                      onPressed: () {
                        if(password.compareTo(confirmPassword) == 0) {
                          isError = true;
                          msg = "Password and confirmation should be equal";
                        }


                      },
                      child: const Text(
                        'Sign In',
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
          ),
        )

    );
  }
}
