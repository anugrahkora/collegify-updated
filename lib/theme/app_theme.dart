import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData(
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
        backgroundColor: const Color.fromARGB(255, 240, 241, 242),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 240, 241, 242),
      primaryColor: const Color.fromARGB(255, 240, 241, 242),
      primaryColorDark: const Color.fromARGB(255, 153, 180, 191),
      highlightColor: const Color.fromARGB(255, 153, 180, 191),
      errorColor: Colors.red,
      focusColor: const Color.fromARGB(255, 34, 92, 115),
      secondaryHeaderColor: Colors.grey[300],
      disabledColor: Colors.grey[100],
      primaryColorLight: const Color.fromARGB(255, 255, 255, 255),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 161, 161, 161),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedLabelStyle: const TextStyle(fontSize: 12.0),
          elevation: 0.0,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          selectedItemColor: Colors.grey[700],
          unselectedItemColor: Colors.grey[400]),
      shadowColor: const Color.fromRGBO(112, 144, 176, 0.2),
      primaryTextTheme: TextTheme(
        headline1: TextStyle(
            color: const Color.fromARGB(255, 103, 103, 103),
            fontWeight: FontWeight.bold,
            fontSize: 15.0),
        bodyText1: const TextStyle(
          color: const Color.fromARGB(255, 103, 103, 103),
        ),
        bodyText2: TextStyle(
            color: const Color.fromARGB(255, 103, 103, 103), fontSize: 13.0),
      ),
      snackBarTheme: const SnackBarThemeData(
        elevation: 0.0,
        contentTextStyle: TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.fromARGB(255, 161, 161, 161),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color.fromARGB(255, 34, 92, 115),
          brightness: Brightness.light));
}

ThemeData darkTheme(BuildContext context) {
  return ThemeData(
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(
          color: const Color.fromARGB(255, 235, 235, 235),
        ),
        backgroundColor: const Color.fromARGB(255, 18, 18, 18),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18),
      primaryColor: const Color.fromARGB(255, 18, 18, 18),
      buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color.fromARGB(255, 235, 235, 235),
      )),
      primaryColorLight: const Color.fromARGB(255, 59, 59, 59),
      highlightColor: const Color.fromARGB(255, 100, 100, 100),
      errorColor: Colors.red,
      focusColor: const Color.fromARGB(255, 235, 235, 235),
      secondaryHeaderColor: Colors.grey[800],
      disabledColor: Colors.grey[600],
      primaryTextTheme: TextTheme(
        headline1: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
        bodyText1: const TextStyle(color: Colors.white),
        bodyText2: TextStyle(color: Colors.grey[500], fontSize: 13.0),
      ),
      shadowColor: const Color.fromRGBO(18, 18, 18, 0.2),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedLabelStyle: const TextStyle(fontSize: 12.0),
        elevation: 0.0,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: const Color.fromARGB(255, 235, 235, 235),
        unselectedItemColor: const Color.fromARGB(255, 140, 140, 140),
      ),
      snackBarTheme: const SnackBarThemeData(
        elevation: 0.0,
        contentTextStyle: TextStyle(
          color: const Color.fromARGB(255, 40, 40, 40),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color.fromARGB(255, 235, 235, 235),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color.fromARGB(255, 70, 152, 185),
          brightness: Brightness.light));
}
