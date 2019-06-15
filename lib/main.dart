// framework
import 'package:basic_file_manager/notifiers/preferences.dart';
import 'package:flutter/material.dart';

// local files
import 'package:basic_file_manager/notifiers/core.dart';
import 'package:basic_file_manager/screens/folders.dart';
import 'package:basic_file_manager/themes.dart';
// packages
import 'package:provider/provider.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

main() {
  CoreNotifier core = CoreNotifier();
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
    final preferences = Provider.of<PreferencesNotifier>(context);
    FlutterStatusbarcolor.setStatusBarColor(getMainColor(preferences.theme));
    print("Main");
    return MaterialApp(
      theme: appThemeData(preferences.theme),
      home: FutureBuilder<String>(
        future: Provider.of<CoreNotifier>(context, listen: false).getRootPath(),
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
}
