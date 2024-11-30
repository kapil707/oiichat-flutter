import 'package:flutter/material.dart';
import 'package:oiichat/Config/colors.dart';

final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: lightHeaderBgColor,
      foregroundColor: lightHeaderTxtColor,
    ));

final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Colors.grey[800],
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: darkHeaderBgColor,
      foregroundColor: darkHeaderTxtColor,
    ));
