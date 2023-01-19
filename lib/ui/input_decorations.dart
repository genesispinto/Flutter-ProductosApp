


import 'package:flutter/material.dart';

class InputDecorations{
  static InputDecoration authInputdecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon
  }){
    return InputDecoration(
            hintText: hintText,
            labelText: labelText,
            labelStyle: const TextStyle(
              color: Colors.grey
            ),
            enabledBorder: const UnderlineInputBorder(
            borderSide: 
            BorderSide(
            color: Colors.purple)
            ),
            focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
            color: Colors.purple,
            width: 2)
            ),
            
            prefixIcon: Icon(prefixIcon, color: Colors.purple)
          );
  }
}