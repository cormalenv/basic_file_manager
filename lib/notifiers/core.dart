// dart
import 'dart:io';

// packages
import 'package:basic_file_manager/models/file_or_dir.dart';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:path/path.dart' as p;

class FileManagerNotifier extends ChangeNotifier {
  Directory currentPath;

  Future<String> getRoot() async {
    return (await getExternalStorageDirectory()).absolute.path;
  }

  List<FileOrDir> folders = [];
  List<FileOrDir> subFolders = [];

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

  Future<List<FileOrDir>> getFoldersAndFiles({changeCurrentPath: true}) async {
    Directory _path = await getExternalStorageDirectory();
    if (changeCurrentPath) {
      currentPath = _path;
    }
    int start = DateTime.now().millisecondsSinceEpoch;
    List<FileOrDir> _folders = [];
    try {
      _folders = (await _path.list().toList())
          .map((path) => FileOrDir(
              name: p.split(path.absolute.path).last,
              path: path.absolute.path,
              type: path.runtimeType.toString().replaceFirst("_", "")))
          .toList()
            ..sort((FileOrDir f1, FileOrDir f2) => f1.type.compareTo(f2.type));
    } catch (error) {
      print(error);
      return [];
    }
    int end = DateTime.now().millisecondsSinceEpoch;
    print("Time: ${end - start}ms");
    folders = _folders;
    return _folders;
  }

  Future<List<FileOrDir>> getSubFoldersAndFiles(String path,
      {changeCurrentPath: true}) async {
    Directory _path = Directory(path);
    if (changeCurrentPath) {
      currentPath = _path;
    }
    int start = DateTime.now().millisecondsSinceEpoch;
    print("Current directory at: ${p.join(_path.absolute.path, path)}");
    List<FileOrDir> _folders = [];
    try {
      _folders = (await _path.list().toList())
          .map((path) => FileOrDir(
              name: p.split(path.absolute.path).last,
              path: path.absolute.path,
              type: path.runtimeType.toString().replaceFirst("_", "")))
          .toList()
            ..sort((FileOrDir f1, FileOrDir f2) => f1.type.compareTo(f2.type));
    } catch (e) {
      print(e);
      return [];
    }

    int end = DateTime.now().millisecondsSinceEpoch;
    print("Time: ${end - start}ms");

    return _folders;
  }

  Future<List<FileOrDir>> search(String path, String query) async {
    Directory _path;
    if (path == null) {
      _path = await getExternalStorageDirectory();
    } else {
      _path = Directory(path);
    }

    int start = DateTime.now().millisecondsSinceEpoch;
    var _fileorDir = (await _path
        .list(recursive: true, followLinks: true)
        .toList())
      ..retainWhere((test) =>
          p.split(test.absolute.path).last.toLowerCase().contains(query));

    List<FileOrDir> _fileOrDirList = _fileorDir
        .map((path) => FileOrDir(
            name: p.split(path.absolute.path).last,
            path: path.absolute.path,
            type: path.runtimeType.toString().replaceFirst("_", "")))
        .toList();

    int end = DateTime.now().millisecondsSinceEpoch;
    print("Time: ${end - start}ms");
    return _fileOrDirList;
  }

  Future<void> delete(FileOrDir fileOrDir) async {
    if (fileOrDir.type == "File") {
      File(fileOrDir.path).delete(recursive: true);
    } else {
      Directory(fileOrDir.path).delete(recursive: true);
    }
    notifyListeners();
  }

  Future<Directory> createFolderByPath(String path) {
    var _path = Directory(p.join(currentPath.path, path)).create();
    notifyListeners();
    return _path;
  }

  Future<void> refresh() async {
    notifyListeners();
  }
}
