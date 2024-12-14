import 'dart:ui';
import 'dart:math' as math;

import '../drawable_element.dart';
import '../coordinate_system.dart';

/// A drawable star element.
class StarElement extends DrawableElement {
  /// Number of points in the star
  final int points;

  /// Outer radius of the star
  final double outerRadius;

  /// Inner radius of the star (between points)
  final double innerRadius;

  /// Rotation angle in radians
  final double rotation;

  /// The width of the stroke
  final double strokeWidth;

  /// The fill color
  final Color? fillColor;

  /// The opacity of the fill (0.0 to 1.0)
  final double fillOpacity;

  /// Whether the star is regular (equal angles)
  final bool regular;

  /// Random variations for irregular stars (0.0 to 1.0)
  final double irregularity;

  /// Creates a new star element.
  ///
  /// [x] and [y] specify the center point.
  /// [points] determines how many points the star has.
  /// [outerRadius] is the radius to the points.
  /// [innerRadius] is the radius between points.
  /// [rotation] rotates the entire star.
  /// [regular] determines if points are equally spaced.
  /// [irregularity] adds random variations to points (if not regular).
  const StarElement({
    required double x,
    required double y,
    required this.points,
    required this.outerRadius,
    required this.innerRadius,
    this.rotation = 0,
    Color color = const Color(0xFF000000),
    this.strokeWidth = 1.0,
    this.fillColor,
    this.fillOpacity = 0.3,
    this.regular = true,
    this.irregularity = 0.3,
  })  : assert(points >= 3, 'Star must have at least 3 points'),
        assert(outerRadius > innerRadius, 'Outer radius must be greater than inner radius'),
        assert(outerRadius > 0, 'Outer radius must be positive'),
        assert(innerRadius > 0, 'Inner radius must be positive'),
        assert(fillOpacity >= 0 && fillOpacity <= 1,
            'Fill opacity must be between 0.0 and 1.0'),
        assert(irregularity >= 0 && irregularity <= 1,
            'Irregularity must be between 0.0 and 1.0'),
        super(
          x: x,
          y: y,
          color: color,
        );

  @override
  void render(Canvas canvas, CoordinateSystem coordinates) {
    final center = coordinates.mapValueToDiagram(x, y);
    final path = Path();
    final random = math.Random(points); // Consistent randomness for same parameters

    // Calculate points of the star
    final totalPoints = points * 2; // Including inner points
    var firstPoint = true;

    for (var i = 0; i < totalPoints; i++) {
      // Alternate between outer and inner radius
      final radius = i.isEven ? outerRadius : innerRadius;
      
      // Calculate base angle for this point
      final baseAngle = (i * math.pi / points) + rotation;
      
      // Add irregularity if not regular
      final angle = regular
          ? baseAngle
          : baseAngle +
              (random.nextDouble() - 0.5) * irregularity * (2 * math.pi / totalPoints);

      // Add random radius variation if not regular
      final adjustedRadius = regular
          ? radius
          : radius * (1 + (random.nextDouble() - 0.5) * irregularity);

      // Convert to cartesian coordinates
      final dx = adjustedRadius * math.cos(angle);
      final dy = adjustedRadius * math.sin(angle);
      
      // Map to diagram coordinates
      final point = coordinates.mapValueToDiagram(x + dx, y + dy);

      if (firstPoint) {
        path.moveTo(point.dx, point.dy);
        firstPoint = false;
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();

    // Draw fill if specified
    if (fillColor != null) {
      final fillPaint = Paint()
        ..color = fillColor!.withOpacity(fillOpacity)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
    }

    // Draw stroke
    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StarElement &&
        other.x == x &&
        other.y == y &&
        other.points == points &&
        other.outerRadius == outerRadius &&
        other.innerRadius == innerRadius &&
        other.rotation == rotation &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.fillColor == fillColor &&
        other.fillOpacity == fillOpacity &&
        other.regular == regular &&
        other.irregularity == irregularity;
  }

  @override
  int get hashCode => Object.hash(
        x,
        y,
        points,
        outerRadius,
        innerRadius,
        rotation,
        color,
        strokeWidth,
        fillColor,
        fillOpacity,
        regular,
        irregularity,
      );
}
