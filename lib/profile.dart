

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobils/components/bottom-menu.dart';
import 'package:mobils/components/custom-text-file.dart';
import 'package:mobils/components/header.dart';

import 'components/button.dart';
import 'components/custom-text.dart';
import 'constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  fetchUserData() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        setState(() {
          _displayNameController.text = user.displayName ?? '';
          _emailController.text = user.email ?? '';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const Header(),
      body: Center(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CustomText(text: "Username", size: 18),
                CustomTextFile(controller: _displayNameController, isPassword: false),
                const SizedBox(height: 16),
                const CustomText(text: "Email", size: 18),
                CustomTextFile(controller: _emailController, isPassword: false),
                const SizedBox(height: 16),
                const CustomText(text: "Password", size: 18),
                CustomTextFile(controller: _passwordController, isPassword: true),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.center,
                  child: Button(textText: 'Update profile', sizeText: 24, onPressed: _update),
                )
              ],
            ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          // Add your logout logic here
        },
        icon: const Icon(Icons.logout, color: textColor), // Icon on the left
        label: const CustomText(text: 'Logout', size: 18) , // Text on the right
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shadowColor: primaryVariant,
          elevation: 3,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0)),
          padding: const EdgeInsets.all(16),
        ),
      ),
      bottomNavigationBar: BottomMenu()
    );

  }

  _update() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        if( user.displayName != _displayNameController.text) {
          await user.updateDisplayName(_displayNameController.text);
        }

        if( user.email != _emailController.text) {
          await user.updateEmail(_emailController.text);
        }

        if(_passwordController.text.isNotEmpty || _passwordController.text != null){
          await user.updatePassword(_passwordController.text);
        }

        await user.reload();

      }
    } catch (e) {
      print('Error');
    }
  }

  signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

}