import 'package:flutter/material.dart';

class GenericUIFunctions{
  static SnackBar snackBar(String text){
    return SnackBar(
      content: Text(text),
    );
  }
}