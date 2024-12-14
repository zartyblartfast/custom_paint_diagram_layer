import 'dart:ui';
import 'dart:math' as math;

import '../drawable_element.dart';
import '../coordinate_system.dart';

/// Pattern type for the dotted/dashed line
enum DashPattern {
  /// Regular dots (...)
  dotted,
  /// Regular dashes (---)
  dashed,
  /// Dash-dot pattern (-.-.)
  dashDot,
  /// Custom pattern based on provided list of lengths
  custom
}

/// A drawable element that renders dotted or dashed lines.
class DottedLineElement extends DrawableElement {
  /// The end point x-coordinate
  final double endX;

  /// The end point y-coordinate
  final double endY;

  /// The width of the stroke
  final double strokeWidth;

  /// The pattern type for the line
  final DashPattern pattern;

  /// Custom dash pattern (list of dash and gap lengths)
  final List<double>? customPattern;

  /// The spacing between dashes/dots
  final double spacing;

  /// Creates a new dotted line element.
  ///
  /// [x] and [y] specify the start point.
  /// [endX] and [endY] specify the end point.
  /// [pattern] determines the type of dash pattern.
  /// [customPattern] is used when pattern is DashPattern.custom.
  /// [spacing] determines the space between dashes/dots.
  DottedLineElement({
    required double x,
    required double y,
    required this.endX,
    required this.endY,
    Color color = const Color(0xFF000000),
    this.strokeWidth = 1.0,
    this.pattern = DashPattern.dotted,
    this.customPattern,
    this.spacing = 5.0,
  })  : assert(
          pattern != DashPattern.custom || (customPattern != null && customPattern.isNotEmpty),
          'Custom pattern requires a non-empty customPattern list',
        ),
        super(
          x: x,
          y: y,
          color: color,
        );

  @override
  void render(Canvas canvas, CoordinateSystem coordinates) {
    final startPoint = coordinates.mapValueToDiagram(x, y);
    final endPoint = coordinates.mapValueToDiagram(endX, endY);

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Calculate the total length of the line
    final dx = endPoint.dx - startPoint.dx;
    final dy = endPoint.dy - startPoint.dy;
    final length = math.sqrt(dx * dx + dy * dy);

    // Calculate the unit vector for the line direction
    final unitX = dx / length;
    final unitY = dy / length;

    // Get the dash pattern based on the selected type
    final List<double> dashPattern = _getDashPattern();
    
    // Draw the dashed/dotted line
    double distance = 0;
    int patternIndex = 0;
    bool drawing = true; // Start with a dash/dot

    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);

    while (distance < length) {
      final segmentLength = math.min(dashPattern[patternIndex], length - distance);
      
      final currentX = startPoint.dx + unitX * distance;
      final currentY = startPoint.dy + unitY * distance;
      
      if (drawing) {
        if (pattern == DashPattern.dotted) {
          // For dots, draw circles instead of lines
          canvas.drawCircle(
            Offset(currentX, currentY),
            strokeWidth / 2,
            paint..style = PaintingStyle.fill,
          );
        } else {
          // For dashes, draw line segments
          path.moveTo(currentX, currentY);
          path.lineTo(
            currentX + unitX * segmentLength,
            currentY + unitY * segmentLength,
          );
        }
      }

      distance += segmentLength;
      patternIndex = (patternIndex + 1) % dashPattern.length;
      drawing = !drawing;
    }

    if (pattern != DashPattern.dotted) {
      canvas.drawPath(path, paint..style = PaintingStyle.stroke);
    }
  }

  /// Gets the dash pattern based on the selected type
  List<double> _getDashPattern() {
    switch (pattern) {
      case DashPattern.dotted:
        return [0, spacing];
      case DashPattern.dashed:
        return [spacing * 2, spacing];
      case DashPattern.dashDot:
        return [spacing * 2, spacing, 0, spacing];
      case DashPattern.custom:
        return customPattern!;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DottedLineElement &&
        other.x == x &&
        other.y == y &&
        other.endX == endX &&
        other.endY == endY &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.pattern == pattern &&
        other.spacing == spacing &&
        _listEquals(other.customPattern, customPattern);
  }

  @override
  int get hashCode => Object.hash(
        x,
        y,
        endX,
        endY,
        color,
        strokeWidth,
        pattern,
        spacing,
        customPattern,
      );

  /// Helper method to compare lists
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
