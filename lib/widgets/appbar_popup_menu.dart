// framework
import 'package:flutter/material.dart';

// packages
import 'package:provider/provider.dart';

// local files
import 'package:basic_file_manager/screens/about.dart';
import 'package:basic_file_manager/screens/settings.dart';
import 'package:basic_file_manager/notifiers/core.dart';
import 'package:basic_file_manager/widgets/create_dialog.dart';

class AppBarPopupMenu extends StatelessWidget {
  final String path;
  const AppBarPopupMenu({Key key, @required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CoreNotifier>(
      builder: (context, model, child) => PopupMenuButton<String>(
          onSelected: (value) {
            if (value == "refresh") {
              model.refresh();
            } else if (value == "folder") {
              showDialog(
                  context: context,
                  builder: (context) => CreateFolderDialog(path: path));
            } else if (value == "settings") {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            }
            else if (value == "about") {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AboutScreen()));
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                const PopupMenuItem<String>(
                    value: 'refresh', child: Text('Refresh')),
                const PopupMenuItem<String>(
                    value: 'sort', child: Text('Sort By')),
                const PopupMenuItem<String>(
                    value: 'folder', child: Text('New Folder +')),
                const PopupMenuItem<String>(
                    value: 'settings', child: Text('Settings')),
                const PopupMenuItem<String>(
                    value: 'about', child: Text('About')),
                //...
              ]),
    );
  }
}
