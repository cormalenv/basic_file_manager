import 'package:basic_file_manager/screens/folders.dart';
import 'package:basic_file_manager/widgets/context_dialog.dart';
import 'package:flutter/material.dart';

class FolderWidget extends StatelessWidget {
  final fileOrDir;
  const FolderWidget({this.fileOrDir});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Folders(path: fileOrDir.path)));
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) => ContextDialog(fileOrDir: fileOrDir));
      },
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Icon(
          Icons.folder,
          size: 50.0,
        ),
        Text(
          fileOrDir.name,
          style: TextStyle(fontSize: 11.5),
          overflow: TextOverflow.ellipsis,
        )
      ]),
    ));
  }
}
