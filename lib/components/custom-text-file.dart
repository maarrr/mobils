import 'package:flutter/material.dart';

import '../constants.dart';

class CustomTextFile extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;

  const CustomTextFile({Key? key, required this.controller, required this.isPassword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
          obscureText: isPassword,
          style: const TextStyle(color: textColor),
          controller: controller,
          validator: (value) {
            if(value == null || value.isEmpty){
              return "This field can't be empty";
            }
            return null;
          },
          textAlign: TextAlign.start,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            errorStyle: TextStyle(
              color: errorColor,
              fontSize: 14.0,
              fontFamily: fontFamily,
            ),
          )
        );
  }
}