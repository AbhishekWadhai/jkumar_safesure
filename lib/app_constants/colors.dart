import 'package:flutter/material.dart';

class AppColors {
  static const Color backgroundColor = Colors.blue;
  static const Color appMainDark = Color(0xFF3E5F44);
  static const Color appMainMid = Color(0xFFA7C1A8);
  static const Color appMainLight = Color(0xFFEEEFE0);

  static Color? scaffoldColor = Color.fromARGB(255, 238, 246, 255);
  static const LinearGradient appMainGradient = LinearGradient(
    colors: [
      appMainDark,
      appMainMid,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomLeft,
  );
}
