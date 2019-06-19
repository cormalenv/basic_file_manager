// framework
import 'dart:io';

import 'package:flutter/material.dart';

// package
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';

// local
import 'package:basic_file_manager/notifiers/core.dart';

class FolderContextDialog extends StatelessWidget {
  final fileOrDir;
  const FolderContextDialog({Key key, @required this.fileOrDir})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CoreNotifier>(
        builder: (context, model, child) => ClipRect(
              child: SimpleDialog(
                title: Text(fileOrDir.name),
                children: <Widget>[
                  SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        model.delete(fileOrDir, 'Directory');
                      },
                      child: ListTile(
                          leading: Icon(Icons.delete), title: Text('Delete'))),
                ],
              ),
            ));
  }
}

class FileContextDialog extends StatelessWidget {
  final String path;
  final String name;
  const FileContextDialog({Key key, @required this.path, @required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CoreNotifier>(
        builder: (context, model, child) => ClipRect(
              child: SimpleDialog(
                title: Text(name),
                children: <Widget>[
                  // open option
                  SimpleDialogOption(
                    onPressed: () async {
                      OpenFile.open(path);
                      Navigator.pop(context);
                    },
                    child: ListTile(
                        leading: Icon(Icons.launch), title: Text('Open')),
                  ),
                  SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        model.delete(path, 'File');
                      },
                      child: ListTile(
                          leading: Icon(Icons.delete), title: Text('Delete'))),
                  SimpleDialogOption(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: ListTile(
                        leading: Icon(
                          Icons.share,
                        ),
                        title: Text('Share')),
                  )
                ],
              ),
            ));
  }
}
