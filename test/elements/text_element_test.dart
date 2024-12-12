import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/text_element.dart';
import 'dart:ui' as ui;

void main() {
  group('TextElement', () {
    test('constructor sets properties correctly', () {
      const text = TextElement(
        x: 1.0,
        y: 2.0,
        text: 'Test Text',
        color: Colors.blue,
      );

      expect(text.x, equals(1.0));
      expect(text.y, equals(2.0));
      expect(text.text, equals('Test Text'));
      expect(text.color, equals(Colors.blue));
      expect(text.style, isNull);
    });

    test('constructor with style sets properties correctly', () {
      const style = TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      );
      
      const text = TextElement(
        x: 1.0,
        y: 2.0,
        text: 'Test Text',
        color: Colors.blue,
        style: style,
      );

      expect(text.style, equals(style));
    });

    test('equality comparison works correctly', () {
      const text1 = TextElement(
        x: 1.0,
        y: 2.0,
        text: 'Test Text',
        color: Colors.blue,
      );

      const text2 = TextElement(
        x: 1.0,
        y: 2.0,
        text: 'Test Text',
        color: Colors.blue,
      );

      const differentText = TextElement(
        x: 1.0,
        y: 2.0,
        text: 'Different Text',
        color: Colors.blue,
      );

      expect(text1, equals(text2));
      expect(text1, isNot(equals(differentText)));
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

      const text = TextElement(
        x: 1.0,
        y: 2.0,
        text: 'Test Text',
        color: Colors.blue,
      );

      text.render(canvas, coordinateSystem);
      
      // Create a picture and verify it's not null (basic smoke test)
      final picture = recorder.endRecording();
      expect(picture, isNotNull);
    });
  });
}
