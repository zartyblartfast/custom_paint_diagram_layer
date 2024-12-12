import 'package:flutter/material.dart';
import '../coordinate_system.dart';
import '../drawable_element.dart';

/// Represents a rectangle in the diagram.
class RectangleElement extends DrawableElement {
  /// The width of the rectangle
  final double width;

  /// The height of the rectangle
  final double height;

  /// Creates a new rectangle element.
  /// 
  /// The rectangle's top-left corner is at (x, y) with the specified width and height.
  /// The color parameter is used to set the rectangle's color.
  const RectangleElement({
    required double x,
    required double y,
    required this.width,
    required this.height,
    required Color color,
  }) : super(x: x, y: y, color: color);

  @override
  void render(Canvas canvas, CoordinateSystem coordinateSystem) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Get the top-left corner in diagram coordinates
    final topLeft = coordinateSystem.mapValueToDiagram(x, y);
    
    // Calculate the bottom-right point in value coordinates
    final bottomRight = coordinateSystem.mapValueToDiagram(
      x + width,
      y - height, // Subtract height because y-axis points up
    );

    // Create the rectangle from the two points
    final rect = Rect.fromPoints(topLeft, bottomRight);
    
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
           other.color == color;
  }

  @override
  int get hashCode => Object.hash(x, y, width, height, color);
}
