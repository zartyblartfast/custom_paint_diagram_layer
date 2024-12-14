import 'dart:ui';

import '../drawable_element.dart';
import '../coordinate_system.dart';

/// A drawable ellipse element with support for stroke and fill.
class EllipseElement extends DrawableElement {
  /// The width of the ellipse (major axis)
  final double width;

  /// The height of the ellipse (minor axis)
  final double height;

  /// The width of the stroke
  final double strokeWidth;

  /// The color to fill the ellipse with
  final Color fillColor;

  /// The opacity of the fill (0.0 to 1.0)
  final double fillOpacity;

  /// Creates a new ellipse element.
  ///
  /// The [x] and [y] coordinates specify the center of the ellipse.
  /// [width] and [height] specify the size of the major and minor axes.
  /// [color] is used for the stroke color, while [fillColor] is used for the interior.
  /// [fillOpacity] controls the transparency of the fill.
  const EllipseElement({
    required double x,
    required double y,
    required this.width,
    required this.height,
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
    
    // Convert width and height to pixel coordinates
    // We multiply by scale to convert from diagram units to pixels
    final pixelWidth = width * coordinates.scale;
    final pixelHeight = height * coordinates.scale;

    // Create the ellipse bounds rectangle
    final rect = Rect.fromCenter(
      center: center,
      width: pixelWidth,
      height: pixelHeight,
    );

    // Draw fill if opacity > 0
    if (fillOpacity > 0) {
      final fillPaint = Paint()
        ..color = fillColor.withOpacity(fillOpacity)
        ..style = PaintingStyle.fill;
      canvas.drawOval(rect, fillPaint);
    }

    // Draw stroke
    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawOval(rect, strokePaint);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EllipseElement &&
        other.x == x &&
        other.y == y &&
        other.width == width &&
        other.height == height &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.fillColor == fillColor &&
        other.fillOpacity == fillOpacity;
  }

  @override
  int get hashCode => Object.hash(
        x,
        y,
        width,
        height,
        color,
        strokeWidth,
        fillColor,
        fillOpacity,
      );
}
