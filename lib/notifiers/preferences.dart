import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesBlocError extends Error {
  final String message;

  PreferencesBlocError(this.message);
}

class PreferencesState {
  final AppTheme theme;
  final sorting;
  final bool showFloatingButton;

  const PreferencesState(
      {@required this.theme,
      @required this.showFloatingButton,
      @required this.sorting});
}

class PreferencesNotifier with ChangeNotifier {
  PreferencesState _currentPrefs = PreferencesState(
    showFloatingButton: true,
    theme: AppTheme.Light,
    sorting: Sorting.Type,
  );

  bool get showFloatingButton => _currentPrefs.showFloatingButton;

  set showFloatingButton(newValue) {
    if (newValue == _currentPrefs.showFloatingButton) return;
    _currentPrefs = PreferencesState(
        showFloatingButton: newValue,
        theme: _currentPrefs.theme,
        sorting: _currentPrefs.sorting);
    notifyListeners();
    _savePreferences();
  }

  AppTheme get theme => _currentPrefs.theme;

  set theme(AppTheme newValue) {
    if (newValue == _currentPrefs.theme) return;
    _currentPrefs = PreferencesState(
        theme: newValue,
        showFloatingButton: _currentPrefs.showFloatingButton,
        sorting: _currentPrefs.sorting);
    notifyListeners();
    _savePreferences();
  }

  Sorting get sorting => _currentPrefs.sorting;

  set sorting(Sorting newValue) {
    if (newValue == _currentPrefs.sorting) return;
    _currentPrefs = PreferencesState(
        theme: _currentPrefs.theme,
        sorting: newValue,
        showFloatingButton: _currentPrefs.showFloatingButton);
    notifyListeners();
    _savePreferences();
  }

  PreferencesNotifier() {
    _loadSharedPreferences();
  }

  Future<void> _loadSharedPreferences() async {
    print("Saving preferences");
    var sharedPrefs = await SharedPreferences.getInstance();
    // '0' is the initial value
    int themeIndex = sharedPrefs.getInt('theme') ?? 0;
    int sortIndex = sharedPrefs.getInt('sort') ?? 0;
    bool showFloatingButton = sharedPrefs.getBool('showFloatingButton') ?? true;
    _currentPrefs = PreferencesState(
        theme: AppTheme.values[themeIndex],
        showFloatingButton: showFloatingButton,
        sorting: Sorting.values[sortIndex]);
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    print("Saving preferences");
    var sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setInt('theme', _currentPrefs.theme.index);
    await sharedPrefs.setInt('sort', _currentPrefs.sorting.index);
    await sharedPrefs.setBool(
        'showFloatingButton', _currentPrefs.showFloatingButton);
  }
}

enum AppTheme { Light, Gray, Dark }

enum Sorting { Type, Size, Date, Alpha, TypeDate, TypeSize }
