import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'dart:convert'; // Import jsonDecode
import 'package:path/path.dart' as path;
import 'package:custom_paint_diagram_layer/src/diagram_exporter.dart';
import 'package:custom_paint_diagram_layer/src/diagram_loader.dart';
import 'package:custom_paint_diagram_layer/src/idg_format.dart';
import '../bin/idg_cli.dart' as cli;

void main() {
  late Directory tempDir;

  setUp(() {
    // Create a fixed temp directory for easier debugging
    tempDir = Directory(path.join(Directory.systemTemp.path, 'idg_test_fixed'));
    if (!tempDir.existsSync()) {
      tempDir.createSync();
    }
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  test('CLI tool exports diagram correctly', () async {
    // Create a test diagram file
    final testDiagramPath = path.join(tempDir.path, 'test_diagram.dart');
    final testOutputPath = path.join(tempDir.path, 'output.idg');

    File(testDiagramPath).writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

class TestDiagram extends StatelessWidget {
  const TestDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomPaintRenderer(
        BasicDiagramLayer(
          coordinateSystem: CoordinateSystem(
            origin: const Offset(400, 300),
            scale: 1.0,
            xRangeMin: -400,
            xRangeMax: 400,
            yRangeMin: -300,
            yRangeMax: 300,
          ),
          elements: [
            LineElement(
              x1: 0,
              y1: 0,
              x2: 100,
              y2: 100,
              color: Colors.black,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
''');

    // Run export command
    final args = ['--export', testDiagramPath, '--output', testOutputPath];
    await cli.main(args);

    // Verify output exists and is valid IDG format
    expect(File(testOutputPath).existsSync(), isTrue);
    final content = File(testOutputPath).readAsStringSync();
    
    // Parse and verify JSON structure instead of string matching
    final json = jsonDecode(content);
    expect(json['format'], equals('idg-1.0'));
    expect(json['elements'], isList);
    expect(json['elements'], hasLength(1));
    expect(json['elements'][0]['type'], equals('line'));
  });

  test('CLI tool imports diagram correctly', () async {
    try {
      final testIdgPath = path.join(tempDir.path, 'test.idg');
      final testOutputPath = path.join(tempDir.path, 'output_diagram.dart');

      print('Writing test IDG file to: $testIdgPath');
      File(testIdgPath).writeAsStringSync('''{
        "format": "idg-1.0",
        "metadata": {
          "name": "Test Diagram",
          "created": "2024-01-01T00:00:00.000Z"
        },
        "canvas": {
          "width": 800.0,
          "height": 600.0,
          "coordinateSystem": {
            "origin": {"x": 400.0, "y": 300.0},
            "scale": 1.0,
            "xRange": {"min": -400.0, "max": 400.0},
            "yRange": {"min": -300.0, "max": 300.0}
          }
        },
        "elements": [
          {
            "type": "line",
            "x1": 0.0,
            "y1": 0.0,
            "x2": 100.0,
            "y2": 100.0,
            "style": {
              "color": "ff000000",
              "strokeWidth": 2.0
            }
          }
        ],
        "controls": {}
      }''');

      print('Running import command...');
      final args = ['--import', testIdgPath, '--output', testOutputPath];
      try {
        await cli.main(args);
      } catch (e, stack) {
        print('Error in cli.main: $e');
        print('Stack trace: $stack');
        rethrow;
      }

      print('Verifying output...');
      expect(File(testOutputPath).existsSync(), isTrue, reason: 'Output file should exist');
      final content = await File(testOutputPath).readAsString();
      print('Output file content: $content');
      
      // Check for required imports
      expect(content, contains("import 'package:flutter/material.dart'"),
          reason: 'Should contain Flutter material import');
      expect(content, contains("import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart'"),
          reason: 'Should contain package import');
      
      // Check for widget class
      expect(content, contains('class ImportedDiagram extends StatelessWidget'),
          reason: 'Should contain widget class definition');
      expect(content, contains('CustomPaint('),
          reason: 'Should contain CustomPaint widget');
      expect(content, contains('CustomPaintRenderer('),
          reason: 'Should contain CustomPaintRenderer');
      expect(content, contains('BasicDiagramLayer('),
          reason: 'Should contain BasicDiagramLayer');
      
      // Check for diagram elements
      expect(content, contains('LineElement('),
          reason: 'Should contain LineElement');
      expect(content, contains('x1: 0'),
          reason: 'Should contain x1 coordinate');
      expect(content, contains('y1: 0'),
          reason: 'Should contain y1 coordinate');
      expect(content, contains('x2: 100'),
          reason: 'Should contain x2 coordinate');
      expect(content, contains('y2: 100'),
          reason: 'Should contain y2 coordinate');
    } catch (e, stack) {
      print('FATAL ERROR IN TEST:');
      print('Error: $e');
      print('Stack trace: $stack');
      rethrow;
    }
  });
}
