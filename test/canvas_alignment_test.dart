import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

void main() {
  group('CanvasAlignment', () {
    late CoordinateSystem coordinateSystem;
    late Size canvasSize;
    late CanvasAlignment alignment;

    setUp(() {
      coordinateSystem = CoordinateSystem(
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: -10,
        yRangeMax: 10,
        scale: 1.0,
        origin: const Offset(0, 0),
      );
      canvasSize = const Size(200, 200);
      alignment = CanvasAlignment(
        canvasSize: canvasSize,
        coordinateSystem: coordinateSystem,
      );
    });

    test('alignCenter sets origin to canvas center', () {
      alignment.alignCenter();
      expect(coordinateSystem.origin, equals(const Offset(100, 100)));
    });

    test('alignBottomCenter sets origin to bottom center', () {
      alignment.alignBottomCenter();
      expect(coordinateSystem.origin, equals(const Offset(100, 200)));
    });

    test('updateScale adjusts scale based on canvas size and coordinate range', () {
      alignment.updateScale();
      // Expected scale: min(200/20, 200/20) = 10
      expect(coordinateSystem.scale, equals(10.0));
    });
  });
}
