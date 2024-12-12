import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/rectangle_element.dart';
import 'dart:ui' as ui;

void main() {
  group('RectangleElement', () {
    test('constructor sets properties correctly', () {
      const rect = RectangleElement(
        x: 1.0,
        y: 2.0,
        width: 3.0,
        height: 4.0,
        color: Colors.blue,
      );

      expect(rect.x, equals(1.0));
      expect(rect.y, equals(2.0));
      expect(rect.width, equals(3.0));
      expect(rect.height, equals(4.0));
      expect(rect.color, equals(Colors.blue));
    });

    test('equality comparison works correctly', () {
      const rect1 = RectangleElement(
        x: 1.0,
        y: 2.0,
        width: 3.0,
        height: 4.0,
        color: Colors.blue,
      );

      const rect2 = RectangleElement(
        x: 1.0,
        y: 2.0,
        width: 3.0,
        height: 4.0,
        color: Colors.blue,
      );

      const differentRect = RectangleElement(
        x: 5.0,
        y: 2.0,
        width: 3.0,
        height: 4.0,
        color: Colors.blue,
      );

      expect(rect1, equals(rect2));
      expect(rect1, isNot(equals(differentRect)));
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

      const rect = RectangleElement(
        x: 1.0,
        y: 2.0,
        width: 3.0,
        height: 4.0,
        color: Colors.blue,
      );

      rect.render(canvas, coordinateSystem);
      
      // Create a picture and verify it's not null (basic smoke test)
      final picture = recorder.endRecording();
      expect(picture, isNotNull);
    });
  });
}
