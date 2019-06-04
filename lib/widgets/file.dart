import 'package:flutter/material.dart';

class FileWidget extends StatelessWidget {
  final String name;
  final onTap;
  const FileWidget({@required this.name, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
      borderRadius: BorderRadius.circular(40.0),
      onTap: onTap,
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
