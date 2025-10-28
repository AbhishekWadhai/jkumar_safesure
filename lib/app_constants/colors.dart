import 'package:flutter/material.dart';

class AppColors {
  static const Color backgroundColor = Colors.blue;
  static const Color appMainDark = Color(0xFF881449);
  static const Color appMainMid = Color(0xFFE61263);
  static const Color appMainLight = Color(0xFFF580A3);

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
