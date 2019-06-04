import 'package:flutter/material.dart';
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
                  child: FutureBuilder(
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
                                  if (snapshot.data[index].type ==
                                      "Directory") {
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(40.0),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Folders(
                                                      path: snapshot
                                                          .data[index].path,
                                                    )));
                                      },
                                      onLongPress: () {
                                        print("Context menu");
                                        showDialog(
                                            context: context,
                                            builder: (context) => ContextDialog(
                                                fileOrDir:
                                                    snapshot.data[index]));
                                      },
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons.folder,
                                              size: 50.0,
                                            ),
                                            Text(
                                              snapshot.data[index].name,
                                              style: TextStyle(fontSize: 11.5),
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ]),
                                    );

                                    // file
                                  } else if (snapshot.data[index].type ==
                                      "File") {
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(40.0),
                                      onTap: () {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) => Folders(
                                        //               path: snapshot
                                        //                   .data[index].path,
                                        //             )));
                                      },
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(
                                              "assets/file/unknown_file_type.png",
                                              width: 50,
                                              height: 50,
                                            ),
                                            Text(
                                              snapshot.data[index].name,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 11.5),
                                            )
                                          ]),
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
                )));
  }

  @override
  bool get wantKeepAlive => true;

  _checkHome() {
    if (widget.home == true)
      return RichText(
        text: TextSpan(
          text: 'Basic File Manager ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          children: <TextSpan>[
            TextSpan(text: widget.path, style: const TextStyle(fontSize: 13.0)),
          ],
        ),
      );
    else
      return Text(
        widget.path,
        style: const TextStyle(fontSize: 13.0),
      );
  }
}
