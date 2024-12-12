import 'package:flutter/material.dart';
import '../coordinate_system.dart';
import '../drawable_element.dart';

/// Base class for axis elements that extends DrawableElement
abstract class AxisElement extends DrawableElement {
  /// The interval between ticks on the axis
  final double tickInterval;

  /// Creates a new axis element
  const AxisElement({
    required super.x,
    required super.y,
    this.tickInterval = 1.0,
    super.color = Colors.black,
  });

  /// Draws a tick mark at the given position
  void drawTick(Canvas canvas, Offset position, Paint paint);

  /// Draws a label at the given position
  void drawLabel(Canvas canvas, Offset position, String text, TextStyle style);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AxisElement &&
           other.x == x &&
           other.y == y &&
           other.tickInterval == tickInterval &&
           other.color == color;
  }

  @override
  int get hashCode => Object.hash(x, y, tickInterval, color);
}

/// Represents the X-axis in the diagram
class XAxisElement extends AxisElement {
  /// Creates a new X-axis element
  const XAxisElement({
    required double yValue,
    super.tickInterval = 1.0,
    super.color = Colors.black,
  }) : super(
    x: 0,
    y: yValue,
  );

  @override
  void drawTick(Canvas canvas, Offset position, Paint paint) {
    canvas.drawLine(
      Offset(position.dx, position.dy - 5),
      Offset(position.dx, position.dy + 5),
      paint,
    );
  }

  @override
  void drawLabel(Canvas canvas, Offset position, String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(position.dx - textPainter.width / 2, position.dy + 8),
    );
  }

  @override
  void render(Canvas canvas, CoordinateSystem coordinateSystem) {
    final start = coordinateSystem.mapValueToDiagram(coordinateSystem.xRangeMin, y);
    final end = coordinateSystem.mapValueToDiagram(coordinateSystem.xRangeMax, y);

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw main axis line
    canvas.drawLine(start, end, paint);

    // Draw ticks and labels
    final textStyle = TextStyle(
      color: color,
      fontSize: 10,
    );

    for (double x = coordinateSystem.xRangeMin.ceil().toDouble(); 
         x <= coordinateSystem.xRangeMax; 
         x += tickInterval) {
      if (x == 0) continue; // Skip origin tick
      final tickPos = coordinateSystem.mapValueToDiagram(x, y);
      
      drawTick(canvas, tickPos, paint);
      drawLabel(canvas, tickPos, x.toStringAsFixed(0), textStyle);
    }
  }
}

/// Represents the Y-axis in the diagram
class YAxisElement extends AxisElement {
  /// Creates a new Y-axis element
  const YAxisElement({
    required double xValue,
    super.tickInterval = 1.0,
    super.color = Colors.black,
  }) : super(
    x: xValue,
    y: 0,
  );

  @override
  void drawTick(Canvas canvas, Offset position, Paint paint) {
    canvas.drawLine(
      Offset(position.dx - 5, position.dy),
      Offset(position.dx + 5, position.dy),
      paint,
    );
  }

  @override
  void drawLabel(Canvas canvas, Offset position, String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(position.dx - textPainter.width - 8, position.dy - textPainter.height / 2),
    );
  }

  @override
  void render(Canvas canvas, CoordinateSystem coordinateSystem) {
    final start = coordinateSystem.mapValueToDiagram(x, coordinateSystem.yRangeMin);
    final end = coordinateSystem.mapValueToDiagram(x, coordinateSystem.yRangeMax);

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw main axis line
    canvas.drawLine(start, end, paint);

    // Draw ticks and labels
    final textStyle = TextStyle(
      color: color,
      fontSize: 10,
    );

    for (double y = coordinateSystem.yRangeMin.ceil().toDouble(); 
         y <= coordinateSystem.yRangeMax; 
         y += tickInterval) {
      if (y == 0) continue; // Skip origin tick
      final tickPos = coordinateSystem.mapValueToDiagram(x, y);
      
      drawTick(canvas, tickPos, paint);
      drawLabel(canvas, tickPos, y.toStringAsFixed(0), textStyle);
    }
  }
}
