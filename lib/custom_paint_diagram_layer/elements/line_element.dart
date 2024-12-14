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

  /// The width of the line stroke
  final double strokeWidth;

  /// Optional dash pattern for the line.
  /// Specified as a list of numbers that alternate between dash and gap lengths.
  /// For example, [5, 5] creates a pattern of 5-pixel dashes with 5-pixel gaps.
  final List<double>? dashPattern;

  /// Creates a new line element.
  /// 
  /// The line starts at (x1, y1) and ends at (x2, y2).
  /// The color parameter is used to set the line's color.
  /// Optional [strokeWidth] sets the line thickness (defaults to 1.0).
  /// Optional [dashPattern] creates a dashed line pattern.
  const LineElement({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required Color color,
    this.strokeWidth = 1.0,
    this.dashPattern,
  }) : super(x: x1, y: y1, color: color);

  @override
  void render(Canvas canvas, CoordinateSystem coordinateSystem) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final start = coordinateSystem.mapValueToDiagram(x1, y1);
    final end = coordinateSystem.mapValueToDiagram(x2, y2);

    if (dashPattern != null) {
      // If dash pattern is specified, draw dashed line
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(end.dx, end.dy);
        
      final dashPath = Path();
      var distance = 0.0;
      final length = (end - start).distance;
      var drawn = 0.0;
      var i = 0;
      
      while (drawn < length) {
        final dashLength = dashPattern![i % dashPattern!.length];
        final nextDistance = distance + dashLength;
        
        if (i % 2 == 0) {  // Draw dash
          final startFraction = distance / length;
          final endFraction = nextDistance / length;
          final dashStart = Offset.lerp(start, end, startFraction)!;
          final dashEnd = Offset.lerp(start, end, endFraction)!;
          dashPath.moveTo(dashStart.dx, dashStart.dy);
          dashPath.lineTo(dashEnd.dx, dashEnd.dy);
        }
        
        distance = nextDistance;
        drawn += dashLength;
        i++;
      }
      
      canvas.drawPath(dashPath, paint);
    } else {
      // Draw solid line
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LineElement &&
           other.x1 == x1 &&
           other.y1 == y1 &&
           other.x2 == x2 &&
           other.y2 == y2 &&
           other.color == color &&
           other.strokeWidth == strokeWidth &&
           _dashPatternsEqual(other.dashPattern, dashPattern);
  }

  bool _dashPatternsEqual(List<double>? a, List<double>? b) {
    if (a == null) return b == null;
    if (b == null) return false;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    x1, 
    y1, 
    x2, 
    y2, 
    color, 
    strokeWidth, 
    dashPattern == null ? null : Object.hashAll(dashPattern!),
  );
}
