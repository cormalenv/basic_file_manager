import 'package:basic_file_manager/notifiers/preferences.dart';
import 'package:basic_file_manager/widgets/themes_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final preferences = Provider.of<PreferencesNotifier>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Consumer<PreferencesNotifier>(
          builder: (context, model, child) => ListView(
                padding: EdgeInsets.all(10.0),
                children: <Widget>[
                  ListTile(
                    leading: Text(
                      "Theme",
                    ),
                    title: Text(
                      "${preferences.theme.toString().split('.')[1]}",
                    ),
                    onTap: () => showDialog(
                        context: context, builder: (context) => ThemesDialog()),
                    dense: true,
                  ),
                  Divider(),
                  SwitchListTile.adaptive(
                    value: preferences.showFloatingButton,
                    onChanged: (value) {
                      preferences.showFloatingButton = value;
                    },
                    title: Text("Show Floating Action Button"),
                  ),
                  Divider()
                ],
              ),
        ));
  }
}
