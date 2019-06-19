// dart
import 'dart:async';
import 'dart:io';

// framework
import 'package:flutter/foundation.dart';

// packages
import 'package:path/path.dart' as p;
import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';

// local files
import 'package:basic_file_manager/notifiers/preferences.dart';
import 'package:basic_file_manager/utils.dart' as utils;
import 'package:basic_file_manager/models/file.dart';
import 'package:basic_file_manager/models/folder.dart';

class CoreNotifier extends ChangeNotifier {
  Directory currentPath;

  Future<String> getRootPath() async {
    return (await getExternalStorageDirectory()).absolute.path;
  }

  List<dynamic> folders = [];
  List<dynamic> subFolders = [];

  Future<void> initialize() async {
    print("Initializing");
    // requesting permisssions
    currentPath = await getExternalStorageDirectory();
    if (!await SimplePermissions.checkPermission(
            Permission.ReadExternalStorage) ||
        !await SimplePermissions.checkPermission(
            Permission.WriteExternalStorage)) {
      await SimplePermissions.requestPermission(Permission.ReadExternalStorage)
          .then((_) async => await SimplePermissions.requestPermission(
              Permission.WriteExternalStorage));

      notifyListeners();
    }
  }

  Future<List<dynamic>> getFoldersAndFiles(String path,
      {changeCurrentPath: true,
      Sorting sortedBy: Sorting.Type,
      reverse: false,
      recursive: false,
      showHidden: false}) async {
    Directory _path = Directory(path);

    int start = DateTime.now().millisecondsSinceEpoch;

    List<dynamic> _files;
    try {
      _files = (await _path.list(recursive: recursive).toList()).map((path) {
        if (FileSystemEntity.isDirectorySync(path.path))
          return MyFolder(
              name: p.split(path.absolute.path).last,
              path: path.absolute.path,
              type: "Directory");
        else
          return MyFile(
              name: p.split(path.absolute.path).last,
              path: path.absolute.path,
              type: "File");
      }).toList();

      // Removing hidden files & folders from the list
      if (showHidden) {
        print("Core: excluding hidden");
        _files.removeWhere((test) {
          print("\tfiltering: " + test.name);
          return test.name.startsWith('.') == true;
        });
      }
    } catch (e) {
      CoreNotifierError(e);
    }

    int end = DateTime.now().millisecondsSinceEpoch;
    print("\nElapsed time [Core]: ${end - start}ms");
    return utils.sort(_files, sortedBy, reverse: reverse);
  }

  Future<List<dynamic>> search(String path, String query,
      {bool matchCase: false,
      regex: false,
      recursive: true,
      bool hidden: false}) async {
    int start = DateTime.now().millisecondsSinceEpoch;

    List<dynamic> files =
        await getFoldersAndFiles(path, recursive: recursive, showHidden: hidden)
          ..retainWhere(
              (test) => test.name.toLowerCase().contains(query.toLowerCase()));

    int end = DateTime.now().millisecondsSinceEpoch;
    print("Search time: ${end - start}ms");
    return files;
  }

  Future<void> delete(path, String type) async {
    try {
      if (type == "File") {
        print("Deleting file @ ${path.path}");
        await File(path.path).delete();
        notifyListeners();
      } else if (type == "Directory") {
        print("Deleting folder @ ${path.path}");
        await Directory(path.path)
            .delete(recursive: true)
            .then((_) => notifyListeners());
      }
      notifyListeners();
    } catch (e) {
      CoreNotifierError(e.toString());
    }
  }

  Future<Directory> createFolderByPath(String path, String folderName) async {
    print("Creating folder: $folderName @ $path");
    var _directory = Directory(p.join(path, folderName));
    try {
      if (!_directory.existsSync()) {
        _directory.create();
        notifyListeners();
      } else {
        CoreNotifierError("File already exists");
      }
      return _directory;
    } catch (e) {
      CoreNotifierError(e);
    }
    return _directory;
  }

  Future<void> refresh() async {
    notifyListeners();
  }
}

class CoreNotifierError extends Error {
  final String message;
  CoreNotifierError(this.message);
}
