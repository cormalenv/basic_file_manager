import 'package:basic_file_manager/models/file_or_dir.dart';
import 'package:basic_file_manager/widgets/create_file_dialog.dart';
import 'package:basic_file_manager/widgets/file.dart';
import 'package:basic_file_manager/widgets/folder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:basic_file_manager/notifiers/core.dart';
import 'package:basic_file_manager/widgets/appbar_popup_menu.dart';
import 'package:basic_file_manager/widgets/context_dialog.dart';
import 'package:basic_file_manager/widgets/search.dart';

class Folders extends StatefulWidget {
  final String path;
  final bool home;
  const Folders({@required this.path, this.home: false}) : assert(path != null);
  @override
  _FoldersState createState() => _FoldersState();
}

class _FoldersState extends State<Folders> with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController(keepScrollOffset: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _checkHome(), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => showSearch(context: context, delegate: Search()),
        ),
        AppBarPopupMenu()
      ]),
      body: Consumer<FileManagerNotifier>(
          builder: (context, model, child) => RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(Duration(milliseconds: 100))
                      .then((_) => setState(() {}));
                },
                child: FutureBuilder<List<FileOrDir>>(
                  future: model.getSubFoldersAndFiles(widget.path),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text('Press button to start.');
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                        if (snapshot.hasError)
                          return Center(
                              child: Text('Error: ${snapshot.error}'));

                        if (snapshot.data.length != 0)
                          return GridView.builder(
                              controller: _scrollController,
                              key: PageStorageKey(widget.path),
                              padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4),
                              itemCount: snapshot.data.length,
                              addAutomaticKeepAlives: true,
                              itemBuilder: (context, index) {
                                if (snapshot.data[index].type == "Directory") {
                                  return FolderWidget(
                                      fileOrDir: snapshot.data[index]);

                                  // file
                                } else if (snapshot.data[index].type ==
                                    "File") {
                                  return FileWidget(
                                    name: snapshot.data[index].name,
                                  );
                                }
                              });
                        else
                          return Center(
                            child: Text("Empty Folder!"),
                          );
                    }
                    return null; // unreachable
                  },
                ),
              )),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Folder Here .",
        child: Icon(Icons.add),
        onPressed: () => showDialog(
            context: context, builder: (context) => CreateFileDialog()),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _checkHome() {
    if (widget.home == true)
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Basic File Manager",
              style: TextStyle(fontSize: 17.0),
            ),
            Text(widget.path)
          ]);
    else
      return Text(
        widget.path,
        style: const TextStyle(fontSize: 13.0),
      );
  }
}
