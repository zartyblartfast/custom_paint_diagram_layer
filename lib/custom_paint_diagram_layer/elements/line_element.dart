import 'package:flutter/material.dart';
import '../coordinate_system.dart';
import '../drawable_element.dart';

/// Represents a line in the diagram.
class LineElement extends DrawableElement {
  /// The x-coordinate of the line's start point
  final double x1;

  /// The y-coordinate of the line's start point
  final double y1;

  /// The x-coordinate of the line's end point
  final double x2;

  /// The y-coordinate of the line's end point
  final double y2;

  /// Creates a new line element.
  /// 
  /// The line starts at (x1, y1) and ends at (x2, y2).
  /// The color parameter is used to set the line's color.
  const LineElement({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required Color color,
  }) : super(x: x1, y: y1, color: color);

  @override
  void render(Canvas canvas, CoordinateSystem coordinateSystem) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final start = coordinateSystem.mapValueToDiagram(x1, y1);
    final end = coordinateSystem.mapValueToDiagram(x2, y2);

    canvas.drawLine(start, end, paint);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LineElement &&
           other.x1 == x1 &&
           other.y1 == y1 &&
           other.x2 == x2 &&
           other.y2 == y2 &&
           other.color == color;
  }

  @override
  int get hashCode => Object.hash(x1, y1, x2, y2, color);
}
