import 'package:basic_file_manager/models/file_or_dir.dart';
import 'package:basic_file_manager/notifiers/preferences.dart';

Future<List<FileOrDir>> sort(List<FileOrDir> elements, Sorting by,
    {bool reverse: false}) async {
  switch (by) {
    case Sorting.Type:
      if (!reverse)
        return elements..sort();
      else
        return (elements..sort()).reversed;
      break;
    default:
      return elements..sort();
  }
}
