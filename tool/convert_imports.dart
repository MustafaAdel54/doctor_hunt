import 'dart:io';
import 'package:path/path.dart' as p;

void main() {
  final libDir = Directory('lib');
  final files = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  final importRegex = RegExp(r'''^(import|export)\s+(['"])(.+?)\2(.*);''', multiLine: true);

  for (final file in files) {
    var content = file.readAsStringSync();
    var modified = false;
    
    // Normalize path separators to POSIX (forward slashes)
    final filePath = file.path.replaceAll(r'\', '/');

    content = content.replaceAllMapped(importRegex, (match) {
      final keyword = match.group(1);
      final quote = match.group(2);
      final importPath = match.group(3)!;
      final suffix = match.group(4);

      if (importPath.startsWith('.')) {
        // It's a relative import. Resolve it.
        // e.g., filePath = lib/apps/main/app.dart
        // dir = lib/apps/main
        final fileDir = p.posix.dirname(filePath);
        final resolved = p.posix.normalize(p.posix.join(fileDir, importPath));
        
        // resolved starts with 'lib/'. We want to change it to 'package:doctor_hunt/...'
        if (resolved.startsWith('lib/')) {
          final packagePath = 'package:doctor_hunt/' + resolved.substring(4);
          modified = true;
          return "$keyword $quote$packagePath$quote$suffix;";
        }
      }
      return match.group(0)!;
    });

    if (modified) {
      file.writeAsStringSync(content);
    }
  }
}
