class FileOrDir implements Comparable<FileOrDir> {
  final String path;
  final String name;
  bool selected;

  /// directory or file
  final String type;

  FileOrDir({this.path, this.name, this.type, this.selected: false});

  @override
  int compareTo(other) {
    return type.compareTo(other.type);
  }
}
