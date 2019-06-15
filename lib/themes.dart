// framework
import 'package:flutter/material.dart';

// local files
import 'package:basic_file_manager/notifiers/preferences.dart';

var _light = const Color.fromRGBO(255, 255, 255, 1.0);
var _gray = Color.fromRGBO(189, 195, 199, 1.0);
var _dark = const Color.fromRGBO(55, 55, 55, 1.0);

Color getMainColor(AppTheme theme) {
  switch (theme) {
    case AppTheme.Light:
      return _light;
      break;
    case AppTheme.Gray:
      return _gray;
      break;

    case AppTheme.Dark:
      return _dark;
      break;

    // Add more themes here ...
    default:
      return null;
  }
}

ThemeData appThemeData(AppTheme theme) {
  switch (theme) {
    case AppTheme.Light:
      return ThemeData(
          toggleableActiveColor: _dark,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: _light, foregroundColor: _dark),
          appBarTheme: AppBarTheme(
              color: _light,
              textTheme: TextTheme(title: TextStyle(color: _dark)),
              iconTheme: IconThemeData()),
          primaryColor: _light,
          iconTheme:
              IconThemeData(color: const Color.fromRGBO(170, 170, 170, 1.0)));
      break;
    case AppTheme.Gray:
      return ThemeData(
          toggleableActiveColor: _gray,
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: _gray),
          primaryColor: _gray,
          iconTheme: IconThemeData(color: _gray));
      break;

    case AppTheme.Dark:
      return ThemeData(
          // scaffoldBackgroundColor: const Color.fromRGBO(50, 50, 50, 1.0),
          // for switch button
          toggleableActiveColor: _dark,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: _dark, foregroundColor: _light),
          appBarTheme: AppBarTheme(
              color: _dark,
              textTheme: TextTheme(title: TextStyle(color: _light)),
              iconTheme: IconThemeData(color: _light)),
          primaryColor: _dark,
          iconTheme: IconThemeData(color: _dark));
      break;

    // Add more themes here ...
    default:
      return null;
  }
}
