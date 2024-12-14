import 'dart:ui';
import 'dart:math' as math;

import '../drawable_element.dart';
import '../coordinate_system.dart';

/// Type of spiral to draw
enum SpiralType {
  /// Archimedean spiral (constant spacing between arms)
  archimedean,
  /// Logarithmic spiral (exponential growth)
  logarithmic,
  /// Fermat's spiral (square root growth)
  fermat,
  /// Golden spiral (based on golden ratio)
  golden
}

/// A drawable spiral element.
class SpiralElement extends DrawableElement {
  /// The type of spiral
  final SpiralType type;

  /// Number of full rotations
  final double rotations;

  /// Growth rate of the spiral
  final double growthRate;

  /// Starting radius
  final double startRadius;

  /// The width of the stroke
  final double strokeWidth;

  /// Whether to draw in clockwise direction
  final bool clockwise;

  /// Creates a new spiral element.
  ///
  /// [x] and [y] specify the center point.
  /// [type] determines the type of spiral.
  /// [rotations] specifies how many full turns to make.
  /// [growthRate] affects how quickly the spiral grows.
  /// [startRadius] is the initial radius.
  const SpiralElement({
    required double x,
    required double y,
    required this.type,
    this.rotations = 3,
    this.growthRate = 0.2,
    this.startRadius = 0.1,
    Color color = const Color(0xFF000000),
    this.strokeWidth = 1.0,
    this.clockwise = true,
  })  : assert(rotations > 0, 'Rotations must be positive'),
        assert(growthRate > 0, 'Growth rate must be positive'),
        assert(startRadius >= 0, 'Start radius must be non-negative'),
        super(
          x: x,
          y: y,
          color: color,
        );

  @override
  void render(Canvas canvas, CoordinateSystem coordinates) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    final center = coordinates.mapValueToDiagram(x, y);

    // Number of points to generate (more points = smoother curve)
    final numPoints = (rotations * 100).toInt();
    var firstPoint = true;

    for (var i = 0; i <= numPoints; i++) {
      // Angle from 0 to 2π * rotations
      final t = (i / numPoints) * rotations * 2 * math.pi;
      // Multiply by -1 if counter-clockwise
      final angle = clockwise ? t : -t;

      // Calculate radius based on spiral type
      final radius = _calculateRadius(t);

      // Convert polar coordinates to Cartesian
      final dx = radius * math.cos(angle);
      final dy = radius * math.sin(angle);

      // Map to diagram coordinates
      final point = coordinates.mapValueToDiagram(x + dx, y + dy);

      if (firstPoint) {
        path.moveTo(point.dx, point.dy);
        firstPoint = false;
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  /// Calculates the radius at a given angle based on spiral type
  double _calculateRadius(double t) {
    switch (type) {
      case SpiralType.archimedean:
        // r = a + bθ
        return startRadius + growthRate * t;

      case SpiralType.logarithmic:
        // r = ae^(bθ)
        return startRadius * math.exp(growthRate * t);

      case SpiralType.fermat:
        // r = a√θ
        return startRadius + growthRate * math.sqrt(t);

      case SpiralType.golden:
        // r = ae^(bθ) where b is based on golden ratio
        final goldenRatio = (1 + math.sqrt(5)) / 2;
        return startRadius * math.exp(math.log(goldenRatio) * t / (2 * math.pi));
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SpiralElement &&
        other.x == x &&
        other.y == y &&
        other.type == type &&
        other.rotations == rotations &&
        other.growthRate == growthRate &&
        other.startRadius == startRadius &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.clockwise == clockwise;
  }

  @override
  int get hashCode => Object.hash(
        x,
        y,
        type,
        rotations,
        growthRate,
        startRadius,
        color,
        strokeWidth,
        clockwise,
      );
}
