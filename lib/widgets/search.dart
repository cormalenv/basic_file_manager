// framework
import 'package:basic_file_manager/animations.dart';
import 'package:basic_file_manager/models/file_or_dir.dart';
import 'package:flutter/material.dart';

// local files
import 'package:basic_file_manager/notifiers/core.dart';
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
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        // clearing query
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer<CoreNotifier>(
      builder: (context, model, child) =>
          new _Results(future: model.search(path, query)),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<CoreNotifier>(
        builder: (context, model, child) => _Results(
              future: model.search(path, query),
            ));
  }
}

// note(Naga): is the right way of doing things here?
class _Results extends StatelessWidget {
  const _Results({
    Key key,
    @required this.future,
  }) : super(key: key);

  final Future<dynamic> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FileOrDir>>(
      future: future, // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<List<FileOrDir>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('Press button to start.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 23.0),
                  ),
                  Text('Searching...')
                ]));
          case ConnectionState.done:
            if (snapshot.hasError) return Center(child: Text("Error"));

            if (snapshot.data.length != 0) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                addAutomaticKeepAlives: true,
                key: key,
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
                      onTap: () {},
                    );
                  }
                },
              );
            } else
              return Center(
                child: Text("Nothing was Found!"),
              );
        }
        return null; // unreachable
      },
    );
  }
}
