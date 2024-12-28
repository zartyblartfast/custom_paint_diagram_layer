import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/themes/themes.dart';

void main() {
  group('ElementStyles', () {
    test('default constructor creates instance with default values', () {
      final styles = ElementStyles();
      
      expect(styles.defaultPaint.color.value, equals(Colors.black.value));
      expect(styles.defaultPaint.style, equals(PaintingStyle.stroke));
      expect(styles.defaultPaint.strokeWidth, equals(1.0));
      
      expect(styles.labelStyle.color, equals(Colors.black));
      expect(styles.labelStyle.fontSize, equals(12));
    });

    test('constructor with parameters creates instance with custom values', () {
      final customPaint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 2.0;
      final customLabelStyle = TextStyle(
        color: Colors.red,
        fontSize: 14,
      );

      final styles = ElementStyles(
        defaultPaint: customPaint,
        labelStyle: customLabelStyle,
      );

      expect(styles.defaultPaint.color.value, equals(Colors.blue.value));
      expect(styles.defaultPaint.strokeWidth, equals(2.0));
      expect(styles.labelStyle.color, equals(Colors.red));
      expect(styles.labelStyle.fontSize, equals(14));
    });

    test('copyWith creates new instance with specified changes', () {
      final original = ElementStyles();
      final newPaint = Paint()..color = Colors.green;
      final newLabelStyle = TextStyle(fontSize: 16);

      final modified = original.copyWith(
        defaultPaint: newPaint,
        labelStyle: newLabelStyle,
      );

      expect(modified.defaultPaint.color.value, equals(Colors.green.value));
      expect(modified.labelStyle.fontSize, equals(16));
      expect(modified.defaultPaint, isNot(same(original.defaultPaint)));
      expect(modified.labelStyle, isNot(same(original.labelStyle)));
    });
  });
}
