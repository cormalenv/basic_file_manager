// framework
import 'package:basic_file_manager/models/theme.dart';
import 'package:basic_file_manager/notifiers/preferences.dart';
import 'package:flutter/material.dart';

// local files
import 'package:basic_file_manager/notifiers/core.dart';
import 'package:basic_file_manager/screens/folders.dart';
import 'package:provider/provider.dart';

// packages
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

main() {
  var core = FileManagerNotifier();
  core.initialize();
  runApp(MultiProvider(
    providers: [
      ValueListenableProvider(builder: (context) => ValueNotifier(true)),
      ChangeNotifierProvider(builder: (context) => core),
      ChangeNotifierProvider(builder: (context) => PreferencesNotifier()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(_statusBarColor(context));
    return MaterialApp(
      theme: _appTheme(context),
      home: FutureBuilder<String>(
        future: Provider.of<FileManagerNotifier>(context).getRoot(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              return Folders(
                home: true,
                path: snapshot.data,
              );
          }
          return null;
        },
      ),
    );
  }

  _appTheme(context) {
    final preferences = Provider.of<PreferencesNotifier>(context);

    switch (preferences.theme) {
      case AppTheme.Light:
        return ThemeData(
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
                foregroundColor: const Color.fromRGBO(55, 55, 55, 1.0)),
            appBarTheme: AppBarTheme(
                color: const Color.fromRGBO(255, 255, 255, 1.0),
                textTheme: TextTheme(
                    title: TextStyle(
                        color: const Color.fromRGBO(55, 55, 55, 1.0))),
                iconTheme: IconThemeData()),
            primaryColor: const Color.fromRGBO(255, 255, 255, 1.0),
            iconTheme:
                IconThemeData(color: const Color.fromRGBO(170, 170, 170, 1.0)));
        break;
      case AppTheme.Gray:
        return ThemeData(
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: const Color.fromRGBO(135, 137, 134, 1.0)),
            primaryColor: const Color.fromRGBO(135, 137, 134, 1.0),
            iconTheme:
                IconThemeData(color: const Color.fromRGBO(135, 137, 134, 1.0)));
        break;

      case AppTheme.Dark:
        return ThemeData(
            scaffoldBackgroundColor: Color.fromRGBO(50, 50, 50, 1.0),
            textTheme: TextTheme(
                // display: TextStyle(color: Color.fromRGBO(255, 255, 255, 1.0)),
                //   body1: TextStyle(color: Color.fromRGBO(255, 255, 255, 1.0)),
                ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: const Color.fromRGBO(55, 55, 55, 1.0),
                foregroundColor: const Color.fromRGBO(255, 255, 255, 1.0)),
            appBarTheme: AppBarTheme(
                color: const Color.fromRGBO(55, 55, 55, 1.0),
                textTheme: TextTheme(
                    title: TextStyle(
                        color: const Color.fromRGBO(255, 255, 255, 1.0))),
                iconTheme: IconThemeData(
                    color: const Color.fromRGBO(255, 255, 255, 1.0))),
            primaryColor: const Color.fromRGBO(55, 55, 55, 1.0),
            iconTheme:
                IconThemeData(color: const Color.fromRGBO(200, 200, 200, 1.0)));
        break;

      // Add more themes here ...
      default:
        return null;
    }
  }

  Color _statusBarColor(context) {
    final preferences = Provider.of<PreferencesNotifier>(context);

    switch (preferences.theme) {
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
}
