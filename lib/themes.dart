// framework
import 'package:flutter/material.dart';

// local files
import 'package:basic_file_manager/notifiers/preferences.dart';

Color getMainColor(AppTheme theme) {
  switch (theme) {
    case AppTheme.Light:
      return Color.fromRGBO(255, 255, 255, 1.0);
      break;
    case AppTheme.Gray:
      return Color.fromRGBO(135, 137, 134, 1.0);
      break;

    case AppTheme.Dark:
      return Color.fromRGBO(55, 55, 55, 1.0);
      break;

    // Add more themes here ...
    default:
      return null;
  }
}
