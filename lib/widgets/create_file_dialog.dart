import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basic_file_manager/notifiers/core.dart';

class CreateFileDialog extends StatefulWidget {

  @override
  _CreateFileDialogState createState() => _CreateFileDialogState();
}

class _CreateFileDialogState extends State<CreateFileDialog> {
  TextEditingController _textEditingController;
  bool _allowedFolderName = true;
  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FileManagerNotifier>(
        builder: (context, model, child) => ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: SimpleDialog(
              title: Text("Add New Folder"),
              contentPadding: EdgeInsets.all(20),
              children: <Widget>[
                // album textfield
                Row(
                  children: <Widget>[
                    Flexible(
                        child: TextField(
                      controller: _textEditingController,
                      onChanged: (data) {
                        // Not allowed characters for album name, since we are creating real
                        // folder in linux
                        if (data.contains("/") ||
                            data.contains(r"\") ||
                            data.contains(">") ||
                            data.contains("<") ||
                            data.contains("|") ||
                            data.contains(":") ||
                            data.contains(":") ||
                            data.contains("&")) {
                          if (_allowedFolderName == true) {
                            setState(() {
                              _allowedFolderName = false;
                            });
                          }
                        } else {
                          if (_allowedFolderName == false) {
                            setState(() {
                              _allowedFolderName = true;
                            });
                          }
                        }
                      },
                      decoration: InputDecoration(
                          helperText: "Not Allowed: / > < | : &",
                          helperStyle: !_allowedFolderName
                              ? TextStyle(color: Colors.red)
                              : TextStyle(),
                          hintText: "Folder Name"),
                    ))
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // cancel
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                    ),
                    // add - confirm button
                    FlatButton(
                      onPressed: _allowedFolderName
                          ? () {
                              model.createFolderByPath(_textEditingController.text);
                              // leaving dialog
                              Navigator.of(context).pop();
                            }
                          : null,
                      child: Text(
                        "Create",
                      ),
                    ),
                  ],
                )
              ],
            )));
  }
}
