import 'dart:ui';
import 'dart:math' as math;

import '../drawable_element.dart';
import '../coordinate_system.dart';

/// A drawable parallelogram element.
class ParallelogramElement extends DrawableElement {
  /// The width of the parallelogram
  final double width;

  /// The height of the parallelogram
  final double height;

  /// The skew angle in radians (0 makes it a rectangle)
  final double skewAngle;

  /// The width of the stroke
  final double strokeWidth;

  /// The fill color
  final Color? fillColor;

  /// The opacity of the fill (0.0 to 1.0)
  final double fillOpacity;

  /// Creates a new parallelogram element.
  ///
  /// [x] and [y] specify the bottom-left corner.
  /// [width] and [height] specify the size.
  /// [skewAngle] determines how much the parallelogram is skewed (in radians).
  /// Positive angles skew right, negative angles skew left.
  const ParallelogramElement({
    required double x,
    required double y,
    required this.width,
    required this.height,
    this.skewAngle = math.pi / 6, // 30 degrees by default
    Color color = const Color(0xFF000000),
    this.strokeWidth = 1.0,
    this.fillColor,
    this.fillOpacity = 0.3,
  })  : assert(width > 0, 'Width must be positive'),
        assert(height > 0, 'Height must be positive'),
        assert(
          fillOpacity >= 0 && fillOpacity <= 1,
          'Fill opacity must be between 0.0 and 1.0',
        ),
        super(
          x: x,
          y: y,
          color: color,
        );

  @override
  void render(Canvas canvas, CoordinateSystem coordinates) {
    // Calculate the horizontal offset based on the skew angle
    final horizontalOffset = height * math.tan(skewAngle);

    // Calculate the four corners in diagram coordinates
    final bottomLeft = coordinates.mapValueToDiagram(x, y);
    final bottomRight = coordinates.mapValueToDiagram(x + width, y);
    final topLeft = coordinates.mapValueToDiagram(
      x + horizontalOffset,
      y + height,
    );
    final topRight = coordinates.mapValueToDiagram(
      x + width + horizontalOffset,
      y + height,
    );

    // Create the path
    final path = Path()
      ..moveTo(bottomLeft.dx, bottomLeft.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..lineTo(topLeft.dx, topLeft.dy)
      ..close();

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
    return other is ParallelogramElement &&
        other.x == x &&
        other.y == y &&
        other.width == width &&
        other.height == height &&
        other.skewAngle == skewAngle &&
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
        skewAngle,
        color,
        strokeWidth,
        fillColor,
        fillOpacity,
      );
}
