import 'package:flutter/material.dart';
import '../coordinate_system.dart';
import '../drawable_element.dart';

/// Represents a circle in the diagram.
class CircleElement extends DrawableElement {
  /// The radius of the circle
  final double radius;

  /// The width of the stroke used to draw the circle
  final double strokeWidth;

  /// The fill color of the circle. If null, the circle will not be filled.
  final Color? fillColor;

  /// The opacity of the fill, ranging from 0.0 (fully transparent) to 1.0 (fully opaque).
  /// Only used when fillColor is not null.
  final double fillOpacity;

  /// Creates a new circle element.
  /// 
  /// The circle's center is at (x, y) with the specified radius.
  /// The color parameter is used to set the circle's stroke color.
  /// The strokeWidth parameter sets the thickness of the circle's border (defaults to 1.0).
  /// The fillColor parameter, if provided, fills the circle with that color.
  /// The fillOpacity parameter controls the transparency of the fill (defaults to 1.0).
  const CircleElement({
    required double x,
    required double y,
    required this.radius,
    required Color color,
    this.strokeWidth = 1.0,
    this.fillColor,
    this.fillOpacity = 1.0,
  }) : assert(fillOpacity >= 0.0 && fillOpacity <= 1.0),
       super(x: x, y: y, color: color);

  @override
  void render(Canvas canvas, CoordinateSystem coordinateSystem) {
    final center = coordinateSystem.mapValueToDiagram(x, y);
    final scaledRadius = radius * coordinateSystem.scale;

    // Draw fill if fillColor is provided
    if (fillColor != null) {
      final fillPaint = Paint()
        ..color = fillColor!.withOpacity(fillOpacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, scaledRadius, fillPaint);
    }

    // Draw stroke
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    
    canvas.drawCircle(center, scaledRadius, strokePaint);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CircleElement &&
           other.x == x &&
           other.y == y &&
           other.radius == radius &&
           other.color == color &&
           other.strokeWidth == strokeWidth &&
           other.fillColor == fillColor &&
           other.fillOpacity == fillOpacity;
  }

  @override
  int get hashCode => Object.hash(x, y, radius, color, strokeWidth, fillColor, fillOpacity);
}
