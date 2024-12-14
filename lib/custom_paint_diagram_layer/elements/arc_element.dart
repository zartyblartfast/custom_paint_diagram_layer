import 'dart:math' as math;
import 'dart:ui';

import '../drawable_element.dart';
import '../coordinate_system.dart';

/// A drawable arc element that can render circular arcs with stroke and fill.
class ArcElement extends DrawableElement {
  /// The radius of the arc
  final double radius;

  /// The starting angle in radians
  final double startAngle;

  /// The ending angle in radians
  final double endAngle;

  /// Whether to use the larger arc when the angle difference is more than π
  final bool useCenter;

  /// The width of the stroke
  final double strokeWidth;

  /// The color to fill the arc with (when useCenter is true)
  final Color fillColor;

  /// The opacity of the fill (0.0 to 1.0)
  final double fillOpacity;

  /// Creates a new arc element.
  ///
  /// [x] and [y] specify the center point of the arc.
  /// [radius] specifies the distance from center to arc.
  /// [startAngle] and [endAngle] define the arc's extent in radians.
  /// [useCenter] if true, draws lines from the arc's endpoints to the center.
  /// [color] is used for the stroke color, while [fillColor] is used for the interior.
  /// [fillOpacity] controls the transparency of the fill when useCenter is true.
  const ArcElement({
    required double x,
    required double y,
    required this.radius,
    required this.startAngle,
    required this.endAngle,
    this.useCenter = false,
    Color color = const Color(0xFF000000),
    this.strokeWidth = 1.0,
    this.fillColor = const Color(0xFF000000),
    this.fillOpacity = 0.0,
  }) : super(
          x: x,
          y: y,
          color: color,
        );

  @override
  void render(Canvas canvas, CoordinateSystem coordinates) {
    // Convert center point to pixel coordinates
    final center = coordinates.mapValueToDiagram(x, y);
    
    // Convert radius to pixel coordinates
    final pixelRadius = radius * coordinates.scale;

    // Create the rect that bounds the arc
    final rect = Rect.fromCircle(
      center: center,
      radius: pixelRadius,
    );

    // Create the path for the arc
    final path = Path();
    if (useCenter) {
      // Move to center for filled arc
      path.moveTo(center.dx, center.dy);
      // Line to start of arc
      path.lineTo(
        center.dx + pixelRadius * math.cos(startAngle),
        center.dy + pixelRadius * math.sin(startAngle),
      );
    } else {
      // Move to start of arc
      path.moveTo(
        center.dx + pixelRadius * math.cos(startAngle),
        center.dy + pixelRadius * math.sin(startAngle),
      );
    }

    // Add the arc
    path.arcTo(
      rect,
      startAngle,
      endAngle - startAngle,
      false,
    );

    if (useCenter) {
      // Close the path back to center for filled arc
      path.close();
    }

    // Draw fill if opacity > 0 and useCenter is true
    if (fillOpacity > 0 && useCenter) {
      final fillPaint = Paint()
        ..color = fillColor.withOpacity(fillOpacity)
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
    return other is ArcElement &&
        other.x == x &&
        other.y == y &&
        other.radius == radius &&
        other.startAngle == startAngle &&
        other.endAngle == endAngle &&
        other.useCenter == useCenter &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.fillColor == fillColor &&
        other.fillOpacity == fillOpacity;
  }

  @override
  int get hashCode => Object.hash(
        x,
        y,
        radius,
        startAngle,
        endAngle,
        useCenter,
        color,
        strokeWidth,
        fillColor,
        fillOpacity,
      );
}
