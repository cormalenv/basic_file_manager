class FileOrDir {
  final String path;
  final String name;
  bool selected;

  /// directory or file
  final String type;

  FileOrDir({this.path, this.name, this.type, this.selected: false});
}
