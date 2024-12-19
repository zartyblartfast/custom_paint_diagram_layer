import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../custom_paint_diagram_layer.dart';
import 'diagram_exporter.dart';
import 'idg_format.dart';
import 'dart:convert';

void main() {
  test('Export basic diagram with coordinate system', () {
    final coords = CoordinateSystem(
      origin: const Offset(400, 300),
      scale: 1.0,
      xRangeMin: -400,
      xRangeMax: 400,
      yRangeMin: -300,
      yRangeMax: 300,
    );

    final result = DiagramExporter.exportToIDG(
      'Test Diagram',
      coords,
      [],
      {},
    );

    final json = jsonDecode(result);
    expect(json['format'], equals('idg-1.0'));
    expect(json['metadata']['name'], equals('Test Diagram'));
    expect(json['canvas']['coordinateSystem']['origin']['x'], equals(400));
    expect(json['canvas']['coordinateSystem']['origin']['y'], equals(300));
    expect(json['canvas']['coordinateSystem']['scale'], equals(1.0));
  });

  test('Export diagram with line element', () {
    final coords = CoordinateSystem(
      origin: const Offset(0, 0),
      scale: 1.0,
      xRangeMin: -400,
      xRangeMax: 400,
      yRangeMin: -300,
      yRangeMax: 300,
    );
    final line = LineElement(
      x1: 0,
      y1: 0,
      x2: 100,
      y2: 100,
      color: Colors.black,
      strokeWidth: 2,
    );

    final result = DiagramExporter.exportToIDG(
      'Line Test',
      coords,
      [line],
      {},
    );

    final json = jsonDecode(result);
    final element = json['elements'][0];
    expect(element['type'], equals('line'));
    expect(element['x1'], equals(0));
    expect(element['y1'], equals(0));
    expect(element['x2'], equals(100));
    expect(element['y2'], equals(100));
    expect(element['style']['color'], equals('FF000000'));
    expect(element['style']['strokeWidth'], equals(2));
  });

  test('Export diagram with polygon element', () {
    final coords = CoordinateSystem(
      origin: const Offset(0, 0),
      scale: 1.0,
      xRangeMin: -400,
      xRangeMax: 400,
      yRangeMin: -300,
      yRangeMax: 300,
    );
    final polygon = PolygonElement(
      points: [
        const Point2D(0, 0),
        const Point2D(100, 0),
        const Point2D(100, 100),
      ],
      x: 0,
      y: 0,
      closed: true,
      color: Colors.blue,
      strokeWidth: 1,
    );

    final result = DiagramExporter.exportToIDG(
      'Polygon Test',
      coords,
      [polygon],
      {},
    );

    final json = jsonDecode(result);
    final element = json['elements'][0];
    expect(element['type'], equals('polygon'));
    expect(element['points'].length, equals(3));
    expect(element['points'][0]['x'], equals(0));
    expect(element['points'][0]['y'], equals(0));
    expect(element['closed'], isTrue);
    expect(element['style']['color'], equals('FF2196F3')); // Material blue color
  });

  test('Export diagram with controls', () {
    final coords = CoordinateSystem(
      origin: const Offset(0, 0),
      scale: 1.0,
      xRangeMin: -400,
      xRangeMax: 400,
      yRangeMin: -300,
      yRangeMax: 300,
    );
    final controls = {
      'timeRange': {'min': 0, 'max': 10},
      'amplitude': 1.0,
    };

    final result = DiagramExporter.exportToIDG(
      'Controls Test',
      coords,
      [],
      controls,
    );

    final json = jsonDecode(result);
    expect(json['controls'], equals(controls));
  });
}
