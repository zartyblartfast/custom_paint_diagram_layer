import 'package:flutter/material.dart';
import '../coordinate_system.dart';
import '../drawable_element.dart';

/// A right-angled triangle element that can be drawn on a diagram.
class RightTriangleElement extends DrawableElement {
  /// The width of the triangle's base
  final double width;

  /// The height of the triangle
  final double height;

  /// The width of the stroke used to draw the triangle
  final double strokeWidth;

  /// The fill color of the triangle. If null, the triangle will not be filled.
  final Color? fillColor;

  /// The opacity of the fill, ranging from 0.0 (fully transparent) to 1.0 (fully opaque).
  /// Only used when fillColor is not null.
  final double fillOpacity;

  /// Creates a new right triangle element.
  /// 
  /// The triangle's right angle is at (x, y), with the base extending right by [width]
  /// and the height extending up by [height].
  /// The color parameter is used to set the triangle's stroke color.
  /// The strokeWidth parameter sets the thickness of the triangle's border (defaults to 1.0).
  /// The fillColor parameter, if provided, fills the triangle with that color.
  /// The fillOpacity parameter controls the transparency of the fill (defaults to 1.0).
  const RightTriangleElement({
    required double x,
    required double y,
    required this.width,
    required this.height,
    required Color color,
    this.strokeWidth = 1.0,
    this.fillColor,
    this.fillOpacity = 1.0,
  }) : assert(fillOpacity >= 0.0 && fillOpacity <= 1.0),
       super(x: x, y: y, color: color);

  @override
  void render(Canvas canvas, CoordinateSystem coordinateSystem) {
    // Get the three points of the triangle in diagram coordinates
    final rightAnglePoint = coordinateSystem.mapValueToDiagram(x, y);
    final basePoint = coordinateSystem.mapValueToDiagram(x + width, y);
    final topPoint = coordinateSystem.mapValueToDiagram(x, y + height);

    // Create a path for the triangle
    final path = Path()
      ..moveTo(rightAnglePoint.dx, rightAnglePoint.dy)
      ..lineTo(basePoint.dx, basePoint.dy)
      ..lineTo(topPoint.dx, topPoint.dy)
      ..close();

    // Draw fill if fillColor is provided
    if (fillColor != null) {
      final fillPaint = Paint()
        ..color = fillColor!.withOpacity(fillOpacity)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
    }

    // Draw stroke
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RightTriangleElement &&
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
  int get hashCode => Object.hash(x, y, width, height, color, strokeWidth, fillColor, fillOpacity);
}
