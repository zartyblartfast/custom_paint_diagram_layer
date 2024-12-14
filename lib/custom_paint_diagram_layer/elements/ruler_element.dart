import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart' show TextSpan;

import '../drawable_element.dart';
import '../coordinate_system.dart';

/// Orientation of the ruler
enum RulerOrientation {
  /// Horizontal ruler
  horizontal,
  /// Vertical ruler
  vertical
}

/// A drawable ruler element for measurements.
class RulerElement extends DrawableElement {
  /// The length of the ruler
  final double length;

  /// The orientation of the ruler
  final RulerOrientation orientation;

  /// The spacing between major ticks
  final double majorTickSpacing;

  /// The spacing between minor ticks
  final double minorTickSpacing;

  /// The length of major ticks
  final double majorTickLength;

  /// The length of minor ticks
  final double minorTickLength;

  /// The width of the ruler and ticks
  final double strokeWidth;

  /// Whether to show numeric labels
  final bool showLabels;

  /// The size of the labels
  final double labelSize;

  /// The format for displaying numbers
  final String Function(double)? numberFormat;

  /// Creates a new ruler element.
  ///
  /// [x] and [y] specify the start point of the ruler.
  /// [length] specifies how long the ruler should be.
  /// [orientation] determines if the ruler is horizontal or vertical.
  /// [numberFormat] can be provided to customize how numbers are displayed.
  const RulerElement({
    required double x,
    required double y,
    required this.length,
    required this.orientation,
    this.majorTickSpacing = 1.0,
    this.minorTickSpacing = 0.2,
    this.majorTickLength = 0.3,
    this.minorTickLength = 0.15,
    this.strokeWidth = 1.0,
    this.showLabels = true,
    this.labelSize = 12.0,
    this.numberFormat,
    Color color = const Color(0xFF000000),
  })  : assert(length > 0, 'Length must be positive'),
        assert(majorTickSpacing > 0, 'Major tick spacing must be positive'),
        assert(minorTickSpacing > 0, 'Minor tick spacing must be positive'),
        assert(majorTickSpacing >= minorTickSpacing,
            'Major tick spacing must be greater than or equal to minor tick spacing'),
        super(
          x: x,
          y: y,
          color: color,
        );

  @override
  void render(Canvas canvas, CoordinateSystem coordinates) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Use coordinate system ranges for start and end points
    final length = orientation == RulerOrientation.horizontal
        ? coordinates.xRangeMax - coordinates.xRangeMin
        : coordinates.yRangeMax - coordinates.yRangeMin;

    final startPoint = coordinates.mapValueToDiagram(
      orientation == RulerOrientation.horizontal ? coordinates.xRangeMin : x,
      orientation == RulerOrientation.horizontal ? y : coordinates.yRangeMin,
    );
    final endPoint = coordinates.mapValueToDiagram(
      orientation == RulerOrientation.horizontal ? coordinates.xRangeMax : x,
      orientation == RulerOrientation.horizontal ? y : coordinates.yRangeMax,
    );

    // Draw main ruler line
    canvas.drawLine(startPoint, endPoint, paint);

    // Draw ticks and labels
    final numMajorTicks = (length / majorTickSpacing).floor() + 1;
    final numMinorTicks = (length / minorTickSpacing).floor() + 1;

    // Draw minor ticks
    for (var i = 0; i < numMinorTicks; i++) {
      final position = orientation == RulerOrientation.horizontal
          ? coordinates.xRangeMin + (i * minorTickSpacing)
          : coordinates.yRangeMin + (i * minorTickSpacing);
      
      if ((orientation == RulerOrientation.horizontal && position > coordinates.xRangeMax) ||
          (orientation == RulerOrientation.vertical && position > coordinates.yRangeMax)) break;
      
      if (position % majorTickSpacing != 0) {
        _drawTick(
          canvas,
          coordinates,
          position,
          minorTickLength,
          paint,
        );
      }
    }

    // Draw major ticks and labels
    final textStyle = TextStyle(
      color: color,
      fontSize: labelSize,
    );
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (var i = 0; i < numMajorTicks; i++) {
      final position = orientation == RulerOrientation.horizontal
          ? coordinates.xRangeMin + (i * majorTickSpacing)
          : coordinates.yRangeMin + (i * majorTickSpacing);
      
      if ((orientation == RulerOrientation.horizontal && position > coordinates.xRangeMax) ||
          (orientation == RulerOrientation.vertical && position > coordinates.yRangeMax)) break;

      _drawTick(
        canvas,
        coordinates,
        position,
        majorTickLength,
        paint,
      );

      if (showLabels) {
        final text = numberFormat?.call(position) ?? position.toStringAsFixed(1);
        
        textPainter.text = TextSpan(
          text: text,
          style: textStyle,
        );
        textPainter.layout();

        final labelOffset = coordinates.mapValueToDiagram(
          orientation == RulerOrientation.horizontal ? position : x,
          orientation == RulerOrientation.horizontal ? y : position,
        );

        final labelPosition = Offset(
          orientation == RulerOrientation.horizontal
              ? labelOffset.dx - textPainter.width / 2
              : labelOffset.dx - textPainter.width - majorTickLength * 1.5,
          orientation == RulerOrientation.horizontal
              ? labelOffset.dy + majorTickLength * 1.5
              : labelOffset.dy - textPainter.height / 2,
        );

        textPainter.paint(canvas, labelPosition);
      }
    }
  }

  /// Draws a tick mark at the specified position
  void _drawTick(
    Canvas canvas,
    CoordinateSystem coordinates,
    double position,
    double tickLength,
    Paint paint,
  ) {
    final tickStart = coordinates.mapValueToDiagram(
      orientation == RulerOrientation.horizontal ? position : x,
      orientation == RulerOrientation.horizontal ? y : position,
    );

    final tickEnd = coordinates.mapValueToDiagram(
      orientation == RulerOrientation.horizontal
          ? position
          : x + tickLength,
      orientation == RulerOrientation.horizontal
          ? y + tickLength
          : position,
    );

    canvas.drawLine(tickStart, tickEnd, paint);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RulerElement &&
        other.x == x &&
        other.y == y &&
        other.length == length &&
        other.orientation == orientation &&
        other.majorTickSpacing == majorTickSpacing &&
        other.minorTickSpacing == minorTickSpacing &&
        other.majorTickLength == majorTickLength &&
        other.minorTickLength == minorTickLength &&
        other.strokeWidth == strokeWidth &&
        other.showLabels == showLabels &&
        other.labelSize == labelSize &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(
        x,
        y,
        length,
        orientation,
        majorTickSpacing,
        minorTickSpacing,
        majorTickLength,
        minorTickLength,
        strokeWidth,
        showLabels,
        labelSize,
        color,
      );
}
