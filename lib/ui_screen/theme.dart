import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes{
  static final light = ThemeData(
      // appBarTheme: const AppBarTheme(
      //   backgroundColor: primaryClr
      // ),
      backgroundColor: Colors.white,
    primaryColor: primaryClr,
    brightness: Brightness.light
    );

  static final dark =  ThemeData(
      // appBarTheme: const AppBarTheme(
      //     backgroundColor: darkGreyClr
      // ),
      backgroundColor: darkGreyClr,
    primaryColor: darkGreyClr,
    brightness: Brightness.dark
    );
}

TextStyle get subHeadingStyle {
  return TextStyle(
    fontFamily: 'Jalnan',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
    decoration: TextDecoration.none,
  );
}
TextStyle get headingStyle {
  return TextStyle(
      fontFamily: 'Jalnan',
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode?Colors.white:Colors.black
  );
}

TextStyle get subTitleStyle {
  return TextStyle(
      fontFamily: 'Jalnan',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode?Colors.grey[100]:Colors.grey[400]
  );
}
TextStyle get titleStyle {
  return TextStyle(
      fontFamily: 'Jalnan',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode?Colors.white:Colors.black
  );
}

TextStyle get subBtnTextStyle {
  return const TextStyle(
      fontFamily: 'Jalnan',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.white
  );
}
TextStyle get btnTextStyle {
  return const TextStyle(
      fontFamily: 'Jalnan',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white
  );
}