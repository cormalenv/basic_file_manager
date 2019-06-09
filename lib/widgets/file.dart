import 'package:basic_file_manager/models/file.dart';
import 'package:basic_file_manager/widgets/context_dialog.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class FileWidget extends StatelessWidget {
  final String name;
  final onTap;
  final MyFile myFile;
  const FileWidget({@required this.name, this.onTap, @required this.myFile});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: () {
        OpenFile.open(myFile.path);
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) => FileContextDialog(
                  myFile: myFile,
                ));
      },
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Image.asset(
          "assets/file/unknown_file_type.png",
          width: 50,
          height: 50,
        ),
        Text(
          name,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 11.5),
        )
      ]),
    ));
  }
}
