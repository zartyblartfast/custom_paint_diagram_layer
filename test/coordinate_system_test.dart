import 'package:flutter_test/flutter_test.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

void main() {
  group('CoordinateSystem', () {
    late CoordinateSystem coordinateSystem;

    // Define standard tolerances for different test scenarios
    const standardTolerance = 0.001;
    const extremeScaleTolerance = 1e3;
    const tinyScaleTolerance = 1e-7;
    const precisionTolerance = 1e-10;

    // Tests that constructor properly validates its parameters
    test('constructor validates parameters correctly', () {
      // Test invalid x-range
      expect(
        () => CoordinateSystem(
          origin: const Offset(0, 0),
          xRangeMin: 100,
          xRangeMax: 0, // Invalid: max < min
          yRangeMin: 0,
          yRangeMax: 100,
          scale: 1.0,
        ),
        throwsA(isA<AssertionError>()),
        reason: 'xRangeMax must be greater than xRangeMin',
      );

      // Test invalid y-range
      expect(
        () => CoordinateSystem(
          origin: const Offset(0, 0),
          xRangeMin: 0,
          xRangeMax: 100,
          yRangeMin: 50,
          yRangeMax: -50, // Invalid: max < min
          scale: 1.0,
        ),
        throwsA(isA<AssertionError>()),
        reason: 'yRangeMax must be greater than yRangeMin',
      );

      // Test invalid scale
      expect(
        () => CoordinateSystem(
          origin: const Offset(0, 0),
          xRangeMin: 0,
          xRangeMax: 100,
          yRangeMin: 0,
          yRangeMax: 100,
          scale: 0, // Invalid: scale must be > 0
        ),
        throwsA(isA<AssertionError>()),
        reason: 'Scale must be greater than zero',
      );
    });

    // Tests constructor validation with extreme inverted ranges
    test('constructor fails with extreme inverted ranges', () {
      expect(
        () => CoordinateSystem(
          origin: const Offset(0, 0),
          xRangeMin: 1e9,
          xRangeMax: -1e9, // Extremely inverted x-range
          yRangeMin: 1e9,
          yRangeMax: -1e9, // Extremely inverted y-range
          scale: 1.0,
        ),
        throwsA(isA<AssertionError>()),
        reason: 'Constructor should fail for extremely inverted ranges',
      );
    });

    // Tests that extreme scale values are handled correctly
    test('handles extreme scale values', () {
      // Test very large scale
      coordinateSystem = CoordinateSystem(
        origin: const Offset(100, 100),
        xRangeMin: 0,
        xRangeMax: 100,
        yRangeMin: 0,
        yRangeMax: 100,
        scale: 1e6,
      );

      final largeScalePoint = coordinateSystem.mapValueToDiagram(50, 50);
      // For large scales, x is scaled by 1e6 and offset by origin
      expect(largeScalePoint.dx, closeTo(50e6 + 100, extremeScaleTolerance));
      // For large scales, y is inverted, scaled by 1e6, and offset by origin
      expect(largeScalePoint.dy, closeTo(-50e6 + 100, extremeScaleTolerance));

      // Test very small scale
      coordinateSystem = CoordinateSystem(
        origin: const Offset(100, 100),
        xRangeMin: 0,
        xRangeMax: 100,
        yRangeMin: 0,
        yRangeMax: 100,
        scale: 1e-6,
      );

      final smallScalePoint = coordinateSystem.mapValueToDiagram(50, 50);
      // For tiny scales, x changes are barely perceptible
      expect(smallScalePoint.dx, closeTo(100 + 50e-6, tinyScaleTolerance));
      // For tiny scales, y changes are barely perceptible and inverted
      expect(smallScalePoint.dy, closeTo(100 - 50e-6, tinyScaleTolerance));
    });

    // Tests extreme boundary values
    test('handles extreme boundary values', () {
      coordinateSystem = CoordinateSystem(
        origin: const Offset(0, 0),
        xRangeMin: -1e9,
        xRangeMax: 1e9,
        yRangeMin: -1e9,
        yRangeMax: 1e9,
        scale: 1.0,
      );

      // Test transformation of extreme boundary values
      final extremePoint = coordinateSystem.mapValueToDiagram(-1e9, -1e9);
      expect(extremePoint.dx, closeTo(0, extremeScaleTolerance),
          reason: 'Extreme negative x should map to origin');
      expect(extremePoint.dy, closeTo(0, extremeScaleTolerance),
          reason: 'Extreme negative y should map to origin after inversion');

      // Verify round-trip transformation of extreme values
      final appPoint = coordinateSystem.mapDiagramToValue(0, 0);
      expect(appPoint.dx, closeTo(-1e9, extremeScaleTolerance),
          reason: 'Should recover extreme negative x value');
      expect(appPoint.dy, closeTo(-1e9, extremeScaleTolerance),
          reason: 'Should recover extreme negative y value');
    });

    // Tests that zero origin behaves correctly
    test('handles zero origin correctly', () {
      coordinateSystem = CoordinateSystem(
        origin: const Offset(0, 0),
        xRangeMin: 0,
        xRangeMax: 100,
        yRangeMin: 0,
        yRangeMax: 100,
        scale: 1.0,
      );

      // With zero origin, transformations should only involve scaling and y-inversion
      final diagramPoint = coordinateSystem.mapValueToDiagram(50, 50);
      expect(diagramPoint.dx, closeTo(50, standardTolerance),
          reason: 'x should only be scaled');
      expect(diagramPoint.dy, closeTo(-50, standardTolerance),
          reason: 'y should be inverted and scaled');

      // Verify round-trip transformation
      final appPoint = coordinateSystem.mapDiagramToValue(50, -50);
      expect(appPoint.dx, closeTo(50, standardTolerance),
          reason: 'x should transform back exactly');
      expect(appPoint.dy, closeTo(50, standardTolerance),
          reason: 'y should transform back exactly');
    });

    // Tests floating-point precision edge cases
    test('handles floating-point precision correctly', () {
      coordinateSystem = CoordinateSystem(
        origin: const Offset(0, 0),
        xRangeMin: 0,
        xRangeMax: 1,
        yRangeMin: 0,
        yRangeMax: 1,
        scale: 1.0,
      );

      // Test very small differences in input
      final point1 = coordinateSystem.mapValueToDiagram(0.1, 0.1);
      final point2 = coordinateSystem.mapValueToDiagram(0.1 + 1e-10, 0.1 + 1e-10);
      
      // Points should be effectively equal within reasonable precision
      expect(point1.dx, closeTo(point2.dx, precisionTolerance),
          reason: 'Small x differences should be preserved');
      expect(point1.dy, closeTo(point2.dy, precisionTolerance),
          reason: 'Small y differences should be preserved');
    });

    // Tests that boundary values are transformed correctly
    test('maps boundary values correctly', () {
      coordinateSystem = CoordinateSystem(
        origin: const Offset(100, 100),
        xRangeMin: 0,
        xRangeMax: 200,
        yRangeMin: 0,
        yRangeMax: 100,
        scale: 1.0,
      );

      // Test minimum boundaries
      final minPoint = coordinateSystem.mapValueToDiagram(0, 0);
      expect(minPoint.dx, closeTo(100, standardTolerance),
          reason: 'Should map to origin x');
      expect(minPoint.dy, closeTo(100, standardTolerance),
          reason: 'Should map to origin y');

      // Test maximum boundaries
      final maxPoint = coordinateSystem.mapValueToDiagram(200, 100);
      expect(maxPoint.dx, closeTo(300, standardTolerance),
          reason: 'Should map to max x');
      expect(maxPoint.dy, closeTo(0, standardTolerance),
          reason: 'Should map to max y');
    });

    test('maps app values to diagram space correctly', () {
      coordinateSystem = CoordinateSystem(
        origin: const Offset(100, 100),
        xRangeMin: 0,
        xRangeMax: 200,
        yRangeMin: 0,
        yRangeMax: 100,
        scale: 2.0,
      );

      final diagramPoint = coordinateSystem.mapValueToDiagram(50, 25);
      expect(diagramPoint.dx, closeTo(200, standardTolerance),
          reason: 'x should be scaled and offset by origin');
      expect(diagramPoint.dy, closeTo(50, standardTolerance),
          reason: 'y should be inverted, scaled, and offset by origin');
    });

    test('maps diagram values back to app space correctly', () {
      coordinateSystem = CoordinateSystem(
        origin: const Offset(100, 100),
        xRangeMin: 0,
        xRangeMax: 200,
        yRangeMin: 0,
        yRangeMax: 100,
        scale: 2.0,
      );

      final appPoint = coordinateSystem.mapDiagramToValue(200, 50);
      expect(appPoint.dx, closeTo(50, standardTolerance),
          reason: 'x should be unscaled and offset from origin');
      expect(appPoint.dy, closeTo(25, standardTolerance),
          reason: 'y should be unscaled, uninverted, and offset from origin');
    });

    test('handles negative ranges', () {
      coordinateSystem = CoordinateSystem(
        origin: const Offset(0, 0),
        xRangeMin: -100,
        xRangeMax: 100,
        yRangeMin: -100,
        yRangeMax: 100,
        scale: 1.0,
      );

      final diagramPoint = coordinateSystem.mapValueToDiagram(-50, -50);
      expect(diagramPoint.dx, closeTo(50, standardTolerance),
          reason: 'Negative x should map to positive diagram space');
      expect(diagramPoint.dy, closeTo(-50, standardTolerance),
          reason: 'Negative y should map to negative diagram space after inversion');

      final appPoint = coordinateSystem.mapDiagramToValue(50, -50);
      expect(appPoint.dx, closeTo(-50, standardTolerance),
          reason: 'Positive diagram x should map to negative app space');
      expect(appPoint.dy, closeTo(-50, standardTolerance),
          reason: 'Negative diagram y should map to negative app space');
    });

    test('handles standard coordinate transformations', () {
      coordinateSystem = CoordinateSystem(
        origin: const Offset(150, 300),  // Bottom-center of canvas
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: 0,
        yRangeMax: 20,
        scale: 10,
      );

      // Test point at origin
      final originPoint = coordinateSystem.mapValueToDiagram(0, 0);
      expect(originPoint.dx, equals(150));  // Center x
      expect(originPoint.dy, equals(300));  // Bottom y

      // Test point at (5, 10)
      final point = coordinateSystem.mapValueToDiagram(5, 10);
      expect(point.dx, equals(200));  // 150 + (5 * 10)
      expect(point.dy, equals(200));  // 300 - (10 * 10)
    });
  });
}
