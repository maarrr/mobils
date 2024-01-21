import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobils/components/button-text-icon.dart';
import 'package:mobils/components/custom-text-file.dart';
import 'package:mobils/components/header.dart';
import 'package:mobils/utils.dart';

import 'package:mobils/login.dart';
import 'components/button.dart';
import 'components/custom-text.dart';
import 'components/menu.dart';
import 'constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);


  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const Header(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: ButtonTextIcon(
                    text: "Logout",
                    size: 18,
                    color: primaryVariant,
                    icon: Icons.logout,
                    onPressed: signOut,
                  ),
              ),
              const SizedBox(height: 48),
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
                child:
                  Button(
                      textText: 'Update profile',
                      sizeText: 24,
                      color: primaryColor,
                      onPressed: () async{
                        await _update();
                        if(mounted) {     // To avoid warning: It's to check if the widget is mounted before calling setState
                          if (_isError) {
                            await ImageUtils.showMessageDialog(context, "Error updating the profile", isError: true);
                            _isError = false;
                          } else {
                            await ImageUtils.showMessageDialog(context, "Profile updated successfully");
                          }
                        }
                      },
                  ),
              )
            ],
          ),
        ),

      ),

      bottomNavigationBar: Menu(
        currentIndex: 3,
        onTap: (index) {
          Menu.navigateToScreen(context, index);
        },
      ),
    );

  }

  _fetchUserData() async {
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

  Future<void> _update() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        if( user.displayName != _displayNameController.text) {
          await user.updateDisplayName(_displayNameController.text);
        }

        if( user.email != _emailController.text) {
          await user.updateEmail(_emailController.text);
        }

        if(_passwordController.text.isNotEmpty || _passwordController.text != ""){
          await user.updatePassword(_passwordController.text);
        }

        await user.reload();
        _isError = false;
      }
    } catch (e) {
      print("Error updating user data: $e");
      _isError = true;
    }
  }

  signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

}