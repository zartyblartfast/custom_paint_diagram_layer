import 'package:flutter/material.dart';
import '../coordinate_system.dart';
import '../drawable_element.dart';

/// Represents a rectangle in the diagram.
class RectangleElement extends DrawableElement {
  /// The width of the rectangle
  final double width;

  /// The height of the rectangle
  final double height;

  /// The width of the stroke used to draw the rectangle
  final double strokeWidth;

  /// The fill color of the rectangle. If null, the rectangle will not be filled.
  final Color? fillColor;

  /// The opacity of the fill, ranging from 0.0 (fully transparent) to 1.0 (fully opaque).
  /// Only used when fillColor is not null.
  final double fillOpacity;

  /// Creates a new rectangle element.
  /// 
  /// The rectangle's top-left corner is at (x, y) with the specified width and height.
  /// The color parameter is used to set the rectangle's stroke color.
  /// The strokeWidth parameter sets the thickness of the rectangle's border (defaults to 1.0).
  /// The fillColor parameter, if provided, fills the rectangle with that color.
  /// The fillOpacity parameter controls the transparency of the fill (defaults to 1.0).
  const RectangleElement({
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
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Get the top-left corner in diagram coordinates
    final topLeft = coordinateSystem.mapValueToDiagram(x, y);
    
    // Calculate the bottom-right point in value coordinates
    final bottomRight = coordinateSystem.mapValueToDiagram(
      x + width,
      y + height,  // Add height because we want bottom = top + height
    );

    // Create the rectangle from the two points
    final rect = Rect.fromPoints(topLeft, bottomRight);

    // Draw fill if fillColor is provided
    if (fillColor != null) {
      final fillPaint = Paint()
        ..color = fillColor!.withOpacity(fillOpacity)
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect, fillPaint);
    }
    
    // Draw stroke
    canvas.drawRect(rect, paint);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RectangleElement &&
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
