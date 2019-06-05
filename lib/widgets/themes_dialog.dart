import 'package:basic_file_manager/models/theme.dart';
import 'package:basic_file_manager/notifiers/preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemesDialog extends StatelessWidget {
  const ThemesDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final preferences = Provider.of<PreferencesNotifier>(context);

    return Consumer<PreferencesNotifier>(
      builder: (context, model, child) => SimpleDialog(
          children: AppTheme.values
              .map((theme) => SimpleDialogOption(
                    child: Row(
                      children: <Widget>[
                        Radio(
                          value: theme,
                          onChanged: (value) {
                            model.theme = value;
                          },
                          groupValue: preferences.theme,
                        ),
                        Text(theme.toString()),
                      ],
                    ),
                  ))
              .toList()),
    );
  }
}
