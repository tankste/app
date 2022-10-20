import 'package:flutter/material.dart';

ThemeData tanksteTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF9253a4),
    primarySwatch: const MaterialColor(0xFF9253a4, {
      50: Color(0xFF),
      100: Color(0xFFe9dcec),
      200: Color(0xFFdecbe3),
      300: Color(0xFFd3bada),
      400: Color(0xFFc8a9d1),
      500: Color(0xFFbd97c8),
      600: Color(0xFFb286bf),
      700: Color(0xFFa775b6),
      800: Color(0xFF9c64ad),
      900: Color(0xFF9253a4),
    }),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white, backgroundColor: Color(0xFF9253a4)),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(const Color(0xFF9253a4)),
    ));

ThemeData tanksteThemeDark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFBD97C8),
    primarySwatch: const MaterialColor(0xFFBD97C8, {
      50: Color(0xFFF8F4F9),
      100: Color(0xFFF1EAF4),
      200: Color(0xFFEBDFEE),
      300: Color(0xFFE4D5E9),
      400: Color(0xFFDECBE3),
      500: Color(0xFFD7C0DE),
      600: Color(0xFFD0B6D8),
      700: Color(0xFFCAABD3),
      800: Color(0xFFC3A1CD),
      900: Color(0xFFBD97C8),
    }),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.black, backgroundColor: Color(0xFFBD97C8)),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(const Color(0xFFBD97C8)),
    ));
