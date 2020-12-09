import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyTheme {
  static const Color mainColor = Color(0XFF262624);
  static const Color darkColor = Color(0XFF1e1c26);
  static const Color greyColor = Color(0XFF5D5D5D);
  static const Color greyAccentColor = Color(0XFF838383);
  static const Color whiteColor = Colors.white;
  static const Color yellowColor = Color(0XFFF2B009);
  static const Color yellowAccentColor = Color(0XFFE27937);
  static const Color blueColor = Color(0XFF4984AA);
  static const Color blueAccentColor = Color(0XFF463CD9);
  static const Color redColor = Color(0XFFEB7279);
  static const Color orangeColor = Color(0XFFE27937);
  static const DecorationImage backgroundImage = DecorationImage(
    image: AssetImage("assets/background-image.png"),
    //colorFilter: ColorFilter.mode(Color(0XFF525252), BlendMode.multiply),
    fit: BoxFit.cover,
    repeat: ImageRepeat.repeatY,
  );
  static ThemeData themeData = ThemeData(
    primaryColor: mainColor,
    accentColor: whiteColor,
    fontFamily: "DottiesVanilla",
    textTheme: TextTheme(
      headline1: TextStyle(
        fontFamily: "DottiesChocolate",
        fontSize: 36.0,
        fontWeight: FontWeight.w600,
      ),
      headline2: TextStyle(
        fontFamily: "DottiesChocolate",
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
        color: MyTheme.whiteColor,
      ),
      headline3: TextStyle(
        fontFamily: "DottiesChocolate",
        fontSize: 28.0,
        fontWeight: FontWeight.w500,
      ),
      headline4: TextStyle(
        fontFamily: "DottiesVanilla",
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
      ),
      headline5: TextStyle(
        fontFamily: "DottiesVanilla",
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: MyTheme.whiteColor,
      ),
      bodyText2: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
