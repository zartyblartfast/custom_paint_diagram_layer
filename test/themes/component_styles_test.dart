import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/themes/themes.dart';

void main() {
  group('GridStyle', () {
    test('default constructor creates instance with default values', () {
      final style = GridStyle();
      
      expect(style.majorColor, equals(Colors.grey));
      expect(style.minorColor, equals(Colors.grey));
      expect(style.majorOpacity, equals(0.5));
      expect(style.minorOpacity, equals(0.2));
      expect(style.majorStrokeWidth, equals(1.0));
      expect(style.minorStrokeWidth, equals(0.5));
    });

    test('majorPaint and minorPaint create Paint objects with correct values', () {
      final style = GridStyle(
        majorColor: Colors.blue,
        minorColor: Colors.red,
        majorOpacity: 0.8,
        minorOpacity: 0.3,
      );

      expect(style.majorPaint.color.value, equals(Colors.blue.withOpacity(0.8).value));
      expect(style.minorPaint.color.value, equals(Colors.red.withOpacity(0.3).value));
    });
  });

  group('AxisStyle', () {
    test('default constructor creates instance with default values', () {
      final style = AxisStyle();
      
      expect(style.color, equals(Colors.black));
      expect(style.opacity, equals(1.0));
      expect(style.strokeWidth, equals(1.0));
      expect(style.labelStyle.color, equals(Colors.black));
      expect(style.labelStyle.fontSize, equals(10));
    });

    test('paint creates Paint object with correct values', () {
      final style = AxisStyle(
        color: Colors.blue,
        opacity: 0.7,
        strokeWidth: 2.0,
      );

      expect(style.paint.color.value, equals(Colors.blue.withOpacity(0.7).value));
      expect(style.paint.strokeWidth, equals(2.0));
    });
  });

  group('FrameStyle', () {
    test('default constructor creates instance with default values', () {
      final style = FrameStyle();
      
      expect(style.strokeColor, equals(Colors.black));
      expect(style.strokeOpacity, equals(1.0));
      expect(style.strokeWidth, equals(1.0));
      expect(style.fillColor, isNull);
      expect(style.fillOpacity, equals(0.1));
    });

    test('stroke and fill paints have correct values', () {
      final style = FrameStyle(
        strokeColor: Colors.blue,
        fillColor: Colors.red,
        strokeOpacity: 0.8,
        fillOpacity: 0.2,
      );

      expect(style.strokePaint.color.value, equals(Colors.blue.withOpacity(0.8).value));
      expect(style.fillPaint?.color.value, equals(Colors.red.withOpacity(0.2).value));
    });
  });

  group('BackgroundStyle', () {
    test('default constructor creates instance with default values', () {
      final style = BackgroundStyle();
      
      expect(style.color, isNull);
      expect(style.opacity, equals(1.0));
      expect(style.showGrid, isTrue);
    });

    test('paint is null when color is null', () {
      final style = BackgroundStyle();
      expect(style.paint, isNull);
    });

    test('paint has correct values when color is set', () {
      final style = BackgroundStyle(
        color: Colors.blue,
        opacity: 0.5,
      );

      expect(style.paint?.color.value, equals(Colors.blue.withOpacity(0.5).value));
    });
  });
}
