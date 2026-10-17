import 'dart:io';

void main() {
  final libDir = Directory('lib');
  final files = libDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  final importRegex = RegExp(r'''^(import|export)\s+(['"])(.+?)\2(.*);''', multiLine: true);

  for (final file in files) {
    var content = file.readAsStringSync();
    var modified = false;

    content = content.replaceAllMapped(importRegex, (match) {
      final keyword = match.group(1);
      final quote = match.group(2);
      final importPath = match.group(3)!;
      final suffix = match.group(4);

      if (importPath.startsWith('.')) {
        // Just convert any relative import that ends up in generated or i18n
        if (importPath.contains('generated/')) {
          final newPath = 'package:doctor_hunt/shared/generated/' + importPath.split('generated/').last;
          modified = true;
          return "$keyword $quote$newPath$quote$suffix;";
        }
        if (importPath.contains('i18n/')) {
          final newPath = 'package:doctor_hunt/shared/i18n/' + importPath.split('i18n/').last;
          modified = true;
          return "$keyword $quote$newPath$quote$suffix;";
        }
        // If there are relative imports to core or shared, they might be broken because the files moved!
      }
      return match.group(0)!;
    });

    if (modified) {
      file.writeAsStringSync(content);
    }
  }
}
