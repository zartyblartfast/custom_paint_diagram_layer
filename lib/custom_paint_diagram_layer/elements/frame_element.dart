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

  /// The fill color of the frame. If null, the frame will not be filled.
  final Color? fillColor;

  /// The opacity of the frame, ranging from 0.0 (fully transparent) to 1.0 (fully opaque).
  final double opacity;

  /// Creates a new frame element.
  /// 
  /// The frame will be drawn around the entire diagram area.
  /// The color parameter sets the frame's stroke color.
  /// The strokeWidth parameter sets the thickness of the frame's border (defaults to 1.0).
  /// The fillColor parameter, if provided, fills the frame with that color.
  /// The opacity parameter controls the transparency of both stroke and fill (defaults to 1.0).
  const FrameElement({
    required Color color,
    this.strokeWidth = 1.0,
    this.fillColor,
    this.opacity = 1.0,
  }) : assert(opacity >= 0.0 && opacity <= 1.0),
       super(x: 0, y: 0, color: color);  // x,y are not used for frame

  @override
  void render(Canvas canvas, CoordinateSystem coordinateSystem) {
    // Calculate frame bounds in canvas coordinates
    final xMin = coordinateSystem.mapValueToDiagram(coordinateSystem.xRangeMin, 0).dx;
    final xMax = coordinateSystem.mapValueToDiagram(coordinateSystem.xRangeMax, 0).dx;
    final yMin = coordinateSystem.mapValueToDiagram(0, coordinateSystem.yRangeMin).dy;
    final yMax = coordinateSystem.mapValueToDiagram(0, coordinateSystem.yRangeMax).dy;

    final rect = Rect.fromLTRB(xMin, yMin, xMax, yMax);

    // Draw fill if specified
    if (fillColor != null) {
      final fillPaint = Paint()
        ..color = fillColor!.withOpacity(opacity)
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect, fillPaint);
    }

    // Draw stroke
    final strokePaint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawRect(rect, strokePaint);
  }
}
