import 'dart:ui';

import '../drawable_element.dart';
import '../coordinate_system.dart';

/// A point in 2D space
class Point2D {
  final double x;
  final double y;

  const Point2D(this.x, this.y);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Point2D && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);
}

/// A drawable polygon element that can render any number of points with stroke and fill.
class PolygonElement extends DrawableElement {
  /// The list of points that make up the polygon
  final List<Point2D> points;

  /// The width of the stroke
  final double strokeWidth;

  /// The color to fill the polygon with
  final Color fillColor;

  /// The opacity of the fill (0.0 to 1.0)
  final double fillOpacity;

  /// Whether to close the polygon path (connect last point to first)
  final bool closed;

  /// Creates a new polygon element.
  ///
  /// [points] defines the vertices of the polygon.
  /// [x] and [y] define the reference point (usually the first point).
  /// [closed] determines if the polygon should be closed (last point connects to first).
  /// [color] is used for the stroke color, while [fillColor] is used for the interior.
  /// [fillOpacity] controls the transparency of the fill.
  const PolygonElement({
    required this.points,
    required double x,
    required double y,
    this.closed = true,
    Color color = const Color(0xFF000000),
    this.strokeWidth = 1.0,
    this.fillColor = const Color(0xFF000000),
    this.fillOpacity = 0.0,
  })  : assert(points.length >= 2, 'Polygon must have at least 2 points'),
        super(
          x: x,
          y: y,
          color: color,
        );

  @override
  void render(Canvas canvas, CoordinateSystem coordinates) {
    if (points.isEmpty) return;

    // Convert all points to pixel coordinates
    final pixelPoints = points.map((point) {
      return coordinates.mapValueToDiagram(point.x, point.y);
    }).toList();

    // Create the polygon path
    final path = Path();
    path.moveTo(pixelPoints[0].dx, pixelPoints[0].dy);
    
    for (var i = 1; i < pixelPoints.length; i++) {
      path.lineTo(pixelPoints[i].dx, pixelPoints[i].dy);
    }

    if (closed) {
      path.close();
    }

    // Draw fill if opacity > 0 and polygon is closed
    if (fillOpacity > 0 && closed) {
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
    return other is PolygonElement &&
        _listEquals(other.points, points) &&
        other.x == x &&
        other.y == y &&
        other.closed == closed &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.fillColor == fillColor &&
        other.fillOpacity == fillOpacity;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(points),
        x,
        y,
        closed,
        color,
        strokeWidth,
        fillColor,
        fillOpacity,
      );
}

/// Helper function to compare lists
bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
