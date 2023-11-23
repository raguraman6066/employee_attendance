import 'package:flutter/material.dart';

class Utils {
  static void showSnackBar(
      {required String message, required BuildContext context, Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }
}
