import 'package:flutter/material.dart';
import '../coordinate_system.dart';
import '../drawable_element.dart';

/// Represents a frame around the diagram.
/// 
/// This element draws a rectangle frame around the entire diagram area,
/// using canvas coordinates rather than diagram coordinates.
class FrameElement extends DrawableElement {
  /// The width of the stroke used to draw the frame
  final double strokeWidth;

  /// Creates a new frame element.
  /// 
  /// The frame will be drawn around the entire diagram area.
  /// The color parameter sets the frame's stroke color.
  /// The strokeWidth parameter sets the thickness of the frame's border (defaults to 1.0).
  const FrameElement({
    required Color color,
    this.strokeWidth = 1.0,
  }) : super(x: 0, y: 0, color: color);  // x,y are not used for frame

  @override
  void render(Canvas canvas, CoordinateSystem coordinateSystem) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Calculate frame bounds in canvas coordinates
    final xMin = coordinateSystem.mapValueToDiagram(coordinateSystem.xRangeMin, 0).dx;
    final xMax = coordinateSystem.mapValueToDiagram(coordinateSystem.xRangeMax, 0).dx;
    final yMin = coordinateSystem.mapValueToDiagram(0, coordinateSystem.yRangeMin).dy;
    final yMax = coordinateSystem.mapValueToDiagram(0, coordinateSystem.yRangeMax).dy;

    // Draw frame rectangle
    canvas.drawRect(
      Rect.fromLTRB(xMin, yMin, xMax, yMax),
      paint,
    );
  }
}
