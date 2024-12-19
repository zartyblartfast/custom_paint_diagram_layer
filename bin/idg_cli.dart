import 'dart:io';
import 'package:args/args.dart';
import 'package:custom_paint_diagram_layer/src/diagram_exporter.dart';
import 'package:custom_paint_diagram_layer/src/diagram_loader.dart';
import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('export',
        abbr: 'e',
        help: 'Export a diagram file to IDG format',
        valueHelp: 'diagram_file.dart')
    ..addOption('import',
        abbr: 'i',
        help: 'Import an IDG file to create a new diagram',
        valueHelp: 'diagram.idg')
    ..addOption('output',
        abbr: 'o',
        help: 'Output file path',
        valueHelp: 'output_file')
    ..addFlag('help',
        abbr: 'h',
        negatable: false,
        help: 'Show this help message');

  try {
    final results = parser.parse(arguments);

    if (results['help'] as bool) {
      print('IDG CLI Tool - Export/Import Interactive Diagram Graphics');
      print(parser.usage);
      return;
    }

    if (results['export'] != null) {
      final inputFile = results['export'] as String;
      final outputFile = results['output'] as String? ?? '$inputFile.idg';
      await exportDiagram(inputFile, outputFile);
    } else if (results['import'] != null) {
      final inputFile = results['import'] as String;
      final outputFile = results['output'] as String? ?? 'imported_diagram.dart';
      await importDiagram(inputFile, outputFile);
    } else {
      print('Please specify either --export or --import');
      print(parser.usage);
    }
  } catch (e) {
    print('Error: $e');
    print(parser.usage);
    exit(1);
  }
}

Future<void> exportDiagram(String inputPath, String outputPath) async {
  // Read the input file
  final file = File(inputPath);
  if (!file.existsSync()) {
    throw FileSystemException('Input file not found', inputPath);
  }

  // Create a basic diagram for testing
  // TODO: In the future, we should parse the actual Dart file to extract the diagram
  final diagram = BasicDiagramLayer(
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
  );

  // Export to IDG format
  final idgContent = DiagramExporter.exportToIDG(
    'Test Diagram',
    diagram.coordinateSystem,
    diagram.elements,
    {}, // No controls for now
  );

  // Write to output file
  await File(outputPath).writeAsString(idgContent);
}

Future<void> importDiagram(String inputPath, String outputPath) async {
  try {
    // Read the IDG file
    final file = File(inputPath);
    if (!file.existsSync()) {
      throw FileSystemException('Input file not found', inputPath);
    }

    print('Reading IDG file: $inputPath');
    final idgContent = await file.readAsString();
    print('IDG content length: ${idgContent.length}');
    print('First 100 chars of IDG content: ${idgContent.substring(0, idgContent.length > 100 ? 100 : idgContent.length)}');
    
    print('Loading IDG content with DiagramLoader');
    final result = DiagramLoader.loadFromIDG(idgContent);
    print('Loaded IDG content: $result');

    // Generate Dart code
    print('Generating Dart code');
    final code = '''
import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

class ImportedDiagram extends StatelessWidget {
  const ImportedDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomPaintRenderer(
        BasicDiagramLayer(
          coordinateSystem: CoordinateSystem(
            origin: Offset(${result.coords.origin.dx}, ${result.coords.origin.dy}),
            scale: ${result.coords.scale},
            xRangeMin: ${result.coords.xRangeMin},
            xRangeMax: ${result.coords.xRangeMax},
            yRangeMin: ${result.coords.yRangeMin},
            yRangeMax: ${result.coords.yRangeMax},
          ),
          elements: ${_generateElementsList(result.elements)},
        ),
      ),
    );
  }
}
''';

    print('Writing output file: $outputPath');
    await File(outputPath).writeAsString(code);
    print('Done writing output file');
  } catch (e, stackTrace) {
    print('Error in importDiagram: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
}

String _generateElementsList(List<DrawableElement> elements) {
  final buffer = StringBuffer();
  buffer.write('[\n');
  
  for (final element in elements) {
    if (element is LineElement) {
      buffer.write('''
        LineElement(
          x1: ${element.x1},
          y1: ${element.y1},
          x2: ${element.x2},
          y2: ${element.y2},
          color: Color(0x${element.color.value.toRadixString(16).padLeft(8, '0')}),
          strokeWidth: ${element.strokeWidth},
        ),
''');
    }
    // Add more element types as needed
  }
  
  buffer.write('      ]');
  return buffer.toString();
}
