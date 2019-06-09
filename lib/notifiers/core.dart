// dart
import 'dart:async';
import 'dart:io';

// framework
import 'package:basic_file_manager/models/file.dart';
import 'package:basic_file_manager/models/folder.dart';
import 'package:flutter/foundation.dart';

// packages
import 'package:path/path.dart' as p;
import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';

// local files
import 'package:basic_file_manager/notifiers/preferences.dart';
import 'package:basic_file_manager/utils.dart' as utils;

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

  Future<List<dynamic>> getSubFoldersAndFiles(String path,
      {changeCurrentPath: true,
      Sorting sortedBy: Sorting.Type,
      reverse: false,
      recursive: false}) async {
    Directory _path = Directory(path);

    int start = DateTime.now().millisecondsSinceEpoch;
    print("Current directory at: ${p.join(_path.absolute.path, path)}");
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
    } catch (e) {
      print(e);
      return [];
    }

    if (sortedBy != null) {
      return utils.sort(_files, sortedBy, reverse: reverse);
    }
    int end = DateTime.now().millisecondsSinceEpoch;
    print("Time: ${end - start}ms");
    return _files;
  }

  Future<List<dynamic>> search(String path, String query,
      {bool matchCase: false, regex: false, recursive: true}) async {
    int start = DateTime.now().millisecondsSinceEpoch;

    List<dynamic> files =
        await getSubFoldersAndFiles(path, recursive: recursive)
          ..retainWhere(
              (test) => test.name.toLowerCase().contains(query.toLowerCase()));

    int end = DateTime.now().millisecondsSinceEpoch;
    print("Search time: ${end - start}ms");
    return files;
  }

  Future<void> delete(path) async {
    try {
      if (path.type == "File") {
        print("Deleting file @ ${path.path}");
        await File(path.path).delete(recursive: true);
      } else {
        print("Deleting folder @ ${path.path}");

        await Directory(path.path).delete(recursive: true);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<Directory> createFolderByPath(String path, String folderName) async {
    print("Creating folder: $folderName @ $path");
    var _directory = Directory(p.join(path, folderName));
    if (!_directory.existsSync()) {
      _directory.create();
      notifyListeners();
    } else {
      return null;
    }
    return _directory;
  }

  Future<void> refresh() async {
    notifyListeners();
  }
}
