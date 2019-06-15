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
                  // floating action button
                  StreamBuilder<bool>(
                    stream:
                        preferences.showFloatingButton, //	a	Stream<int>	or	null
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasError)
                        return Text('Error:	${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text('Select	lot');
                        case ConnectionState.waiting:
                          return Center(child: Text('Awaiting	bids...'));
                        case ConnectionState.active:
                          return SwitchListTile.adaptive(
                            value: snapshot.data,
                            onChanged: (value) =>
                                preferences.setFloatingButtonEnabled(value),
                            title: Text("Show Floating Action Button"),
                          );
                        case ConnectionState.done:
                          return SwitchListTile.adaptive(
                            value: snapshot.data,
                            onChanged: (value) =>
                                preferences.setFloatingButtonEnabled(value),
                            title: Text("Show Floating Action Button"),
                          );
                      }
                      return null;
                    },
                  ),

                  Divider(),
                  SwitchListTile.adaptive(
                    value: preferences.hidden,
                    onChanged: (value) => preferences.hidden = value,
                    title: Text("Show Hidden"),
                  )
                ],
              ),
        ));
  }
}
