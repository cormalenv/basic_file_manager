// framework
import 'package:flutter/material.dart';

// local files
import 'package:basic_file_manager/notifiers/core.dart';
import 'package:basic_file_manager/screens/folders.dart';
import 'package:provider/provider.dart';

// packages
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

main() {
  var model = FileManagerNotifier();
  model.initialize();
  runApp(MultiProvider(
    providers: [
      ValueListenableProvider(builder: (_) => ValueNotifier(true)),
      ChangeNotifierProvider(builder: (_) => model),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(135, 137, 134, 1.0));
    return MaterialApp(
      theme: ThemeData(
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: const Color.fromRGBO(135, 137, 134, 1.0)),
          primaryColor: const Color.fromRGBO(135, 137, 134, 1.0),
          iconTheme:
              IconThemeData(color: const Color.fromRGBO(135, 137, 134, 1.0))),
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
}
