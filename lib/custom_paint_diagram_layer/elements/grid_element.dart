import 'dart:ui';
import 'dart:math' as math;

import '../drawable_element.dart';
import '../coordinate_system.dart';

/// Style of grid lines
enum GridLineStyle {
  /// Solid lines
  solid,
  /// Dotted lines
  dotted,
  /// Dashed lines
  dashed
}

/// A drawable grid element that can show major and minor grid lines.
class GridElement extends DrawableElement {
  /// The spacing between major grid lines
  final double majorSpacing;

  /// The spacing between minor grid lines
  final double minorSpacing;

  /// The color of major grid lines
  final Color majorColor;

  /// The color of minor grid lines
  final Color minorColor;

  /// The width of major grid lines
  final double majorStrokeWidth;

  /// The width of minor grid lines
  final double minorStrokeWidth;

  /// The style of major grid lines
  final GridLineStyle majorStyle;

  /// The style of minor grid lines
  final GridLineStyle minorStyle;

  /// The opacity of the grid (0.0 to 1.0)
  final double opacity;

  /// Creates a new grid element.
  ///
  /// [x] and [y] specify the top-left corner of the grid.
  /// [majorSpacing] determines the space between major grid lines.
  /// [minorSpacing] determines the space between minor grid lines.
  const GridElement({
    double x = 0,
    double y = 0,
    this.majorSpacing = 1.0,
    this.minorSpacing = 0.2,
    this.majorColor = const Color(0xFF888888),
    this.minorColor = const Color(0xFFCCCCCC),
    this.majorStrokeWidth = 1.0,
    this.minorStrokeWidth = 0.5,
    this.majorStyle = GridLineStyle.solid,
    this.minorStyle = GridLineStyle.solid,
    this.opacity = 0.5,
  })  : assert(majorSpacing > 0, 'Major spacing must be positive'),
        assert(minorSpacing > 0, 'Minor spacing must be positive'),
        assert(majorSpacing >= minorSpacing,
            'Major spacing must be greater than or equal to minor spacing'),
        assert(opacity >= 0 && opacity <= 1,
            'Opacity must be between 0.0 and 1.0'),
        super(
          x: x,
          y: y,
          color: const Color(0xFF000000),
        );

  @override
  void render(Canvas canvas, CoordinateSystem coordinates) {
    // Use the coordinate system's range instead of fixed dimensions
    final startPoint = coordinates.mapValueToDiagram(coordinates.xRangeMin, coordinates.yRangeMin);
    final endPoint = coordinates.mapValueToDiagram(coordinates.xRangeMax, coordinates.yRangeMax);

    // Draw minor grid lines
    _drawGridLines(
      canvas,
      coordinates,
      startPoint,
      endPoint,
      minorSpacing,
      minorColor.withOpacity(opacity),
      minorStrokeWidth,
      minorStyle,
    );

    // Draw major grid lines
    _drawGridLines(
      canvas,
      coordinates,
      startPoint,
      endPoint,
      majorSpacing,
      majorColor.withOpacity(opacity),
      majorStrokeWidth,
      majorStyle,
    );
  }

  /// Draws grid lines with the specified parameters
  void _drawGridLines(
    Canvas canvas,
    CoordinateSystem coordinates,
    Offset startPoint,
    Offset endPoint,
    double spacing,
    Color lineColor,
    double strokeWidth,
    GridLineStyle style,
  ) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Calculate the number of lines needed based on coordinate system range
    final verticalLines = ((coordinates.xRangeMax - coordinates.xRangeMin) / spacing).ceil();
    final horizontalLines = ((coordinates.yRangeMax - coordinates.yRangeMin) / spacing).ceil();

    // Draw vertical lines
    for (var i = 0; i <= verticalLines; i++) {
      final xPos = coordinates.xRangeMin + (i * spacing);
      if (xPos > coordinates.xRangeMax) continue;

      final lineStart = coordinates.mapValueToDiagram(xPos, coordinates.yRangeMin);
      final lineEnd = coordinates.mapValueToDiagram(xPos, coordinates.yRangeMax);

      _drawStyledLine(
        canvas,
        paint,
        lineStart,
        lineEnd,
        style,
      );
    }

    // Draw horizontal lines
    for (var i = 0; i <= horizontalLines; i++) {
      final yPos = coordinates.yRangeMin + (i * spacing);
      if (yPos > coordinates.yRangeMax) continue;

      final lineStart = coordinates.mapValueToDiagram(coordinates.xRangeMin, yPos);
      final lineEnd = coordinates.mapValueToDiagram(coordinates.xRangeMax, yPos);

      _drawStyledLine(
        canvas,
        paint,
        lineStart,
        lineEnd,
        style,
      );
    }
  }

  /// Draws a line with the specified style
  void _drawStyledLine(
    Canvas canvas,
    Paint paint,
    Offset start,
    Offset end,
    GridLineStyle style,
  ) {
    switch (style) {
      case GridLineStyle.solid:
        canvas.drawLine(start, end, paint);
        break;
      case GridLineStyle.dotted:
        _drawDottedLine(canvas, paint, start, end, 2, 2);
        break;
      case GridLineStyle.dashed:
        _drawDottedLine(canvas, paint, start, end, 5, 3);
        break;
    }
  }

  /// Draws a dotted or dashed line
  void _drawDottedLine(
    Canvas canvas,
    Paint paint,
    Offset start,
    Offset end,
    double dashLength,
    double spaceLength,
  ) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final length = math.sqrt(dx * dx + dy * dy);
    final unitX = dx / length;
    final unitY = dy / length;

    var currentX = start.dx;
    var currentY = start.dy;
    var remainingLength = length;
    var drawing = true;

    while (remainingLength > 0) {
      final segmentLength =
          drawing ? dashLength : spaceLength;
      final actualLength = segmentLength.clamp(0.0, remainingLength);

      if (drawing) {
        canvas.drawLine(
          Offset(currentX, currentY),
          Offset(
            currentX + unitX * actualLength,
            currentY + unitY * actualLength,
          ),
          paint,
        );
      }

      currentX += unitX * actualLength;
      currentY += unitY * actualLength;
      remainingLength -= actualLength;
      drawing = !drawing;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GridElement &&
        other.majorSpacing == majorSpacing &&
        other.minorSpacing == minorSpacing &&
        other.majorColor == majorColor &&
        other.minorColor == minorColor &&
        other.majorStrokeWidth == majorStrokeWidth &&
        other.minorStrokeWidth == minorStrokeWidth &&
        other.majorStyle == majorStyle &&
        other.minorStyle == minorStyle &&
        other.opacity == opacity;
  }

  @override
  int get hashCode => Object.hash(
        majorSpacing,
        minorSpacing,
        majorColor,
        minorColor,
        majorStrokeWidth,
        minorStrokeWidth,
        majorStyle,
        minorStyle,
        opacity,
      );
}
