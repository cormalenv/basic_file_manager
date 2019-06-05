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
  final bool showFloatingButton;

  const PreferencesState({@required this.theme, this.showFloatingButton});
}

class PreferencesNotifier with ChangeNotifier {
  PreferencesState _currentPrefs = PreferencesState(
    theme: AppTheme.Light,
  );

  AppTheme get theme => _currentPrefs.theme;

  bool get showFloatingButton => _currentPrefs.showFloatingButton;

  set showFloatingButton(newValue) {
    if (newValue == _currentPrefs.showFloatingButton) return;
    _currentPrefs = PreferencesState(
        showFloatingButton: newValue, theme: _currentPrefs.theme);
    notifyListeners();
    _savePreferences();
  }

  set theme(AppTheme newValue) {
    if (newValue == _currentPrefs.theme) return;
    _currentPrefs = PreferencesState(
        theme: newValue, showFloatingButton: _currentPrefs.showFloatingButton);
    notifyListeners();
    _savePreferences();
  }

  PreferencesNotifier() {
    _loadSharedPreferences();
  }

  Future<void> _loadSharedPreferences() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    int theme = sharedPrefs.getInt('theme') ?? 0;
    bool showFloatingButton = sharedPrefs.getBool('showFloatingButton') ?? true;

    _currentPrefs = PreferencesState(
        theme: AppTheme.values[theme], showFloatingButton: showFloatingButton);
    print("Loading preferences");
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setInt('theme', _currentPrefs.theme.index);
    await sharedPrefs.setBool(
        'showFloatingButton', _currentPrefs.showFloatingButton);
  }
}
