import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:custom_paint_diagram_layer/src/diagram_compliance_checker.dart';

void main(List<String> args) async {
  if (args.isEmpty) {
    print('''
Diagram Layer (DL) Compliance Checker
Usage: dart run bin/check_diagram_compliance.dart <file_or_directory_path>

Examples:
  Check single file:
    dart run bin/check_diagram_compliance.dart devtest/demos/engineering_coords_test.dart
  
  Check all demos:
    dart run bin/check_diagram_compliance.dart devtest/demos
''');
    return;
  }

  // Convert relative path to absolute path
  final target = path.normalize(path.absolute(args[0]));
  
  try {
    if (FileSystemEntity.isDirectorySync(target)) {
      print('Checking all diagrams in directory: $target\n');
      final results = await DiagramComplianceChecker.checkDirectory(target);
      
      int compliant = 0;
      int nonCompliant = 0;
      
      for (final result in results) {
        print('\n${result.toString()}');
        result.isCompliant ? compliant++ : nonCompliant++;
      }
      
      print('\nSummary:');
      print(' Compliant: $compliant');
      print(' Non-compliant: $nonCompliant');
      print('Total: ${compliant + nonCompliant}');
      
    } else {
      print('Checking file: $target\n');
      final result = await DiagramComplianceChecker.checkFile(target);
      print(result.toString());
    }
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
}
