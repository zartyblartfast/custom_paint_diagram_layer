import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/line_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/coordinate_system.dart';
import 'dart:ui' as ui;

void main() {
  group('LineElement', () {
    test('constructor sets properties correctly', () {
      const line = LineElement(
        x1: 1.0,
        y1: 2.0,
        x2: 3.0,
        y2: 4.0,
        color: Colors.blue,
      );

      expect(line.x1, equals(1.0));
      expect(line.y1, equals(2.0));
      expect(line.x2, equals(3.0));
      expect(line.y2, equals(4.0));
      expect(line.color, equals(Colors.blue));
    });

    test('equality comparison works correctly', () {
      const line1 = LineElement(
        x1: 1.0,
        y1: 2.0,
        x2: 3.0,
        y2: 4.0,
        color: Colors.blue,
      );

      const line2 = LineElement(
        x1: 1.0,
        y1: 2.0,
        x2: 3.0,
        y2: 4.0,
        color: Colors.blue,
      );

      const differentLine = LineElement(
        x1: 5.0,
        y1: 2.0,
        x2: 3.0,
        y2: 4.0,
        color: Colors.blue,
      );

      expect(line1, equals(line2));
      expect(line1, isNot(equals(differentLine)));
    });

    test('render uses coordinate system correctly', () {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      final coordinateSystem = CoordinateSystem(
        origin: const Offset(100, 100),
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: -10,
        yRangeMax: 10,
        scale: 10.0,
      );

      const line = LineElement(
        x1: 1.0,
        y1: 2.0,
        x2: 3.0,
        y2: 4.0,
        color: Colors.blue,
      );

      line.render(canvas, coordinateSystem);
      
      // Create a picture and verify it's not null (basic smoke test)
      final picture = recorder.endRecording();
      expect(picture, isNotNull);
    });
  });
}
