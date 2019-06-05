import 'dart:async';

import 'package:basic_file_manager/models/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesBlocError extends Error {
  final String message;

  PreferencesBlocError(this.message);
}

class PreferencesState {
  final AppTheme theme;

  const PreferencesState(this.theme);
}

class PreferencesNotifier with ChangeNotifier {
  PreferencesState _currentPrefs = PreferencesState(AppTheme.Light);

  AppTheme get theme => _currentPrefs.theme;

  set theme(AppTheme newValue) {
    if (newValue == _currentPrefs.theme) return;
    _currentPrefs = PreferencesState(newValue);
    notifyListeners();
    _savePreferences();
  }

  PreferencesNotifier() {
    _loadSharedPreferences();
  }

  Future<void> _loadSharedPreferences() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    int theme = sharedPrefs.getInt('theme') ?? 0;

    _currentPrefs = PreferencesState(AppTheme.values[theme]);

    print("Current theme: ${AppTheme.values[theme]}");
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setInt('theme', _currentPrefs.theme.index);
  }
}
