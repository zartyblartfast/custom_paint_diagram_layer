import 'package:flutter/material.dart';
import '../coordinate_system.dart';
import '../drawable_element.dart';

/// An isosceles triangle element that can be drawn on a diagram.
class IsoscelesTriangleElement extends DrawableElement {
  /// The width of the triangle's base
  final double baseWidth;

  /// The height of the triangle from base to apex
  final double height;

  /// The width of the stroke used to draw the triangle
  final double strokeWidth;

  /// The fill color of the triangle. If null, the triangle will not be filled.
  final Color? fillColor;

  /// The opacity of the fill, ranging from 0.0 (fully transparent) to 1.0 (fully opaque).
  /// Only used when fillColor is not null.
  final double fillOpacity;

  /// Creates a new isosceles triangle element.
  /// 
  /// The triangle's base center is at (x, y), with the base extending [baseWidth/2] units
  /// to either side and the apex extending up by [height].
  /// The color parameter is used to set the triangle's stroke color.
  /// The strokeWidth parameter sets the thickness of the triangle's border (defaults to 1.0).
  /// The fillColor parameter, if provided, fills the triangle with that color.
  /// The fillOpacity parameter controls the transparency of the fill (defaults to 1.0).
  const IsoscelesTriangleElement({
    required double x,
    required double y,
    required this.baseWidth,
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
    final baseCenter = coordinateSystem.mapValueToDiagram(x, y);
    final baseLeft = coordinateSystem.mapValueToDiagram(x - baseWidth/2, y);
    final baseRight = coordinateSystem.mapValueToDiagram(x + baseWidth/2, y);
    final apex = coordinateSystem.mapValueToDiagram(x, y + height);

    // Create a path for the triangle
    final path = Path()
      ..moveTo(baseLeft.dx, baseLeft.dy)
      ..lineTo(baseRight.dx, baseRight.dy)
      ..lineTo(apex.dx, apex.dy)
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
    return other is IsoscelesTriangleElement &&
           other.x == x &&
           other.y == y &&
           other.baseWidth == baseWidth &&
           other.height == height &&
           other.color == color &&
           other.strokeWidth == strokeWidth &&
           other.fillColor == fillColor &&
           other.fillOpacity == fillOpacity;
  }

  @override
  int get hashCode => Object.hash(x, y, baseWidth, height, color, strokeWidth, fillColor, fillOpacity);
}
