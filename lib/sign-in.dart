import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobils/components/header.dart';
import 'package:mobils/constants.dart';
import 'package:mobils/gallery.dart';
import 'package:mobils/login.dart';

import 'components/button.dart';
import 'components/custom-text-file.dart';
import 'components/custom-text.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}


class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isError = false;
  late String _msg;

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: const Header(),
        body: Center (
          child: SingleChildScrollView(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(margin),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(text: "Username", size: 16),
                      CustomTextFile(controller: _nameController, isPassword: false),
                      const SizedBox(height: 16),
                      const CustomText(text: "Email", size: 16),
                      CustomTextFile(controller: _emailController, isPassword: false),
                      const SizedBox(height: 16),
                      const CustomText(text: "Password", size: 16),
                      CustomTextFile(controller: _passwordController, isPassword: true),
                      const SizedBox(height: 16),
                      const CustomText(text: "Confirm password", size: 16),
                      CustomTextFile(controller: _confirmPasswordController, isPassword: true),
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
                        const CustomText(text: "Already have an account?", size: 18),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Login',
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
                        textText: 'Sign In',
                        sizeText: 24,
                        color: primaryColor,
                        onPressed: () async {
                          setState(() {
                            _isError = false;
                          });
                          if (_formKey.currentState!.validate()) {
                            await _signIn();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        )
    );

  }

   _signIn() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
     if(password.compareTo(confirmPassword) != 0) {
       setState(() {
         _isError = true;
         _msg = "Password and confirmation should be equal.";
       });
       return;
     }

     try { //Sign in in firebase Auth
       final userCredentials = await _auth.createUserWithEmailAndPassword(
           email: email, password: password);
       if(userCredentials != null) {

         userCredentials.user?.updateDisplayName(name);

         Navigator.push(context, MaterialPageRoute(
           builder: (context) => const GalleryScreen(),
         ),
         );
       }
     } on FirebaseAuthException catch (e) {
       setState(() {
         _isError = true;
         if(e.code == 'email-already-in-use'){
           _msg = "Email already in use.";

         }else {
           _msg = "Incorrect data. Try again";
         }
       });
     }
   }

}
