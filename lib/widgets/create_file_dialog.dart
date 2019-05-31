import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basic_file_manager/models/app_model.dart';

class CreateFileDialog extends StatefulWidget {
  @override
  _CreateFileDialogState createState() => _CreateFileDialogState();
}

class _CreateFileDialogState extends State<CreateFileDialog> {
  TextEditingController _textEditingController;
  bool _allowedAlbumName = true;
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
    return Consumer<FileManagerModel>(
        builder: (context, model, child) => ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: SimpleDialog(
              title: Text("Add new album"),
              contentPadding: EdgeInsets.all(20),
              children: <Widget>[
                // album textfield
                Row(
                  children: <Widget>[
                    Flexible(
                        child: TextField(
                      controller: _textEditingController,
                      maxLength: 50,
                      onChanged: (data) {
                        // Not allowed characters for album name, since we are creating real
                        // folder name in linux
                        if (data.contains("/") ||
                            data.contains(r"\") ||
                            data.contains(">") ||
                            data.contains("<") ||
                            data.contains("|") ||
                            data.contains(":") ||
                            data.contains(":") ||
                            data.contains("&")) {
                          if (_allowedAlbumName == true) {
                            setState(() {
                              _allowedAlbumName = false;
                            });
                          }
                        } else {
                          if (_allowedAlbumName == false) {
                            setState(() {
                              _allowedAlbumName = true;
                            });
                          }
                        }
                      },
                      decoration: InputDecoration(
                          helperText: "Not allowed: / > < | : &",
                          helperStyle: !_allowedAlbumName
                              ? TextStyle(color: Colors.red)
                              : TextStyle(),
                          hintText: "Album Name"),
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
                      onPressed: _allowedAlbumName
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
