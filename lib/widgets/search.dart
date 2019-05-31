// framework
import 'package:basic_file_manager/animations.dart';
import 'package:basic_file_manager/models/file_or_dir.dart';
import 'package:flutter/material.dart';

// local files
import 'package:basic_file_manager/models/app_model.dart';
import 'package:basic_file_manager/screens/folders.dart';
import 'package:basic_file_manager/screens/folders.dart';
import 'package:basic_file_manager/screens/folders.dart';
import 'package:provider/provider.dart';

// packages

class Search extends SearchDelegate<String> {
  final String path;
  Search({this.path});

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return null;
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<FileManagerModel>(
      builder: (context, model, child) => FutureBuilder<List<FileOrDir>>(
            future: model.search(
                path, query), // a previously-obtained Future<String> or null
            builder:
                (BuildContext context, AsyncSnapshot<List<FileOrDir>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Press button to start.');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(child: Text('Awaiting result...'));
                case ConnectionState.done:
                  if (snapshot.hasError) return Text("Error");
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data[index].type == "Directory") {
                        return ListTile(
                          leading: Icon(Icons.folder),
                          title: Text(snapshot.data[index].name),
                          onTap: () {
                            Navigator.push(
                                context,
                                AnimationlessMaterialPageRoute(
                                    builder: (context) => Folders(
                                          path: snapshot.data[index].path,
                                        )));
                          },
                        );
                      } else if (snapshot.data[index].type == "File") {
                        return ListTile(
                          leading: Icon(Icons.image),
                          title: Text(snapshot.data[index].name),
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => SubFolderScreen(
                            //               path: snapshot.data[index].path,
                            //             )));
                          },
                        );
                      }
                    },
                  );
              }
              return null; // unreachable
            },
          ),
    );
  }
}
