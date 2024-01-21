import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobils/components/custom-text-file.dart';
import 'package:mobils/components/custom-text.dart';
import 'package:mobils/constants.dart';
import 'package:mobils/sign-in.dart';


import 'components/button.dart';
import 'components/header.dart';
import 'main-screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isError = false;
  late String _msg = "";

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const Header(),
      body:
      Padding(
        padding: const EdgeInsets.all(margin),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(text: "Email", size: 16),
                    CustomTextFile(controller: _emailController, isPassword: false),
                    const SizedBox(height: 16),
                    const CustomText(text: "Password", size: 16),
                    CustomTextFile(controller: _passwordController, isPassword: true),
                    const SizedBox(height: 16),
                    if(_isError)
                      Column(
                        children: [
                          Text(
                            _msg,
                            style: const TextStyle(
                              color: errorColor,
                              fontSize: 14,
                              fontFamily: fontFamily,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomText(text: "Don't have an account?", size: 18),
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
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.center,
                      child: Button(
                        textText: 'Login',
                        sizeText: 24,
                        color: primaryColor,
                        onPressed: () async {
                          setState(() {
                            _isError = false;
                          });
                          if (_formKey.currentState!.validate()) {
                            await _login(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
          )
        ),
      )
    );
  }

  _login(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isError = true;
        if(e.code == 'email-already-in-use'){
          _msg = "Email already in use.";

        }else {
          _msg = "Error in procedure. Try again";
        }
      });
    }
  }
}