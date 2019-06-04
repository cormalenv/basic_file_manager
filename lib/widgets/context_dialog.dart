import 'package:basic_file_manager/models/file_or_dir.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basic_file_manager/notifiers/core.dart';


class ContextDialog extends StatelessWidget {
  final FileOrDir fileOrDir;
  const ContextDialog({Key key, @required this.fileOrDir}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FileManagerNotifier>(
      builder: (context, model, child) => SimpleDialog(
            title: Text(fileOrDir.name),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    model.delete(fileOrDir);
                    Navigator.pop(context);
                  },
                  child: Text("Delete"))
            ],
          ),
    );
  }
}
