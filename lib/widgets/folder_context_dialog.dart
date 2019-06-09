// framework
import 'package:flutter/material.dart';

// package
import 'package:provider/provider.dart';
import 'package:share/share.dart';
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
                        model.delete(fileOrDir);
                      },
                      child: ListTile(
                          leading: Icon(Icons.delete), title: Text("Delete"))),
                  SimpleDialogOption(
                    onPressed: () {
                      OpenFile.open(fileOrDir.path);

                      Navigator.pop(context);
                    },
                    child: ListTile(
                        leading: Icon(
                          Icons.share,
                        ),
                        title: Text("Share")),
                  )
                ],
              ),
            ));
  }
}
