import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'coordinate_system.dart';
import 'drawable_element.dart';

/// A diagram that can contain drawable elements and render coordinate axes.
class Diagram {
  /// The coordinate system used for transformations
  final CoordinateSystem coordinateSystem;

  /// Whether to show the coordinate axes
  final bool showAxes;

  /// The list of drawable elements in the diagram
  final List<DrawableElement> elements;

  /// Creates a new diagram with the given coordinate system
  const Diagram({
    required this.coordinateSystem,
    this.showAxes = true,
    this.elements = const [],
  });

  /// Renders the diagram onto the given canvas
  void render(Canvas canvas, Size size) {
    if (showAxes) {
      _renderAxes(canvas);
    }

    // Render all drawable elements
    for (final element in elements) {
      element.render(canvas, coordinateSystem);
    }
  }

  /// Renders the coordinate axes and scale markings
  void _renderAxes(Canvas canvas) {
    final axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw X axis
    final xStart = coordinateSystem.mapValueToDiagram(coordinateSystem.xRangeMin, 0);
    final xEnd = coordinateSystem.mapValueToDiagram(coordinateSystem.xRangeMax, 0);
    canvas.drawLine(xStart, xEnd, axisPaint);

    // Draw Y axis
    final yStart = coordinateSystem.mapValueToDiagram(0, coordinateSystem.yRangeMin);
    final yEnd = coordinateSystem.mapValueToDiagram(0, coordinateSystem.yRangeMax);
    canvas.drawLine(yStart, yEnd, axisPaint);

    _renderAxisTicks(canvas, axisPaint);
  }

  /// Renders the axis ticks and labels
  void _renderAxisTicks(Canvas canvas, Paint axisPaint) {
    const tickLength = 5.0;
    const textStyle = TextStyle(fontSize: 10);

    // X-axis ticks
    for (var x = coordinateSystem.xRangeMin.ceil(); 
         x <= coordinateSystem.xRangeMax.floor(); 
         x++) {
      if (x == 0) continue; // Skip origin
      final tickPos = coordinateSystem.mapValueToDiagram(x.toDouble(), 0);
      canvas.drawLine(
        Offset(tickPos.dx, tickPos.dy - tickLength),
        Offset(tickPos.dx, tickPos.dy + tickLength),
        axisPaint,
      );

      // Draw tick label
      final textPainter = TextPainter(
        text: TextSpan(text: x.toString(), style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(tickPos.dx - textPainter.width / 2, tickPos.dy + tickLength),
      );
    }

    // Y-axis ticks
    for (var y = coordinateSystem.yRangeMin.ceil(); 
         y <= coordinateSystem.yRangeMax.floor(); 
         y++) {
      if (y == 0) continue; // Skip origin
      final tickPos = coordinateSystem.mapValueToDiagram(0, y.toDouble());
      canvas.drawLine(
        Offset(tickPos.dx - tickLength, tickPos.dy),
        Offset(tickPos.dx + tickLength, tickPos.dy),
        axisPaint,
      );

      // Draw tick label
      final textPainter = TextPainter(
        text: TextSpan(text: y.toString(), style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(tickPos.dx - textPainter.width - tickLength * 2, tickPos.dy - textPainter.height / 2),
      );
    }

    // Draw origin label
    final originPos = coordinateSystem.mapValueToDiagram(0, 0);
    final originPainter = TextPainter(
      text: const TextSpan(text: '0', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    originPainter.paint(
      canvas,
      Offset(originPos.dx - originPainter.width - tickLength,
             originPos.dy + tickLength),
    );
  }

  /// Creates a new diagram with updated elements
  Diagram copyWith({
    CoordinateSystem? coordinateSystem,
    bool? showAxes,
    List<DrawableElement>? elements,
  }) {
    return Diagram(
      coordinateSystem: coordinateSystem ?? this.coordinateSystem,
      showAxes: showAxes ?? this.showAxes,
      elements: elements ?? this.elements,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Diagram &&
           other.coordinateSystem == coordinateSystem &&
           other.showAxes == showAxes &&
           listEquals(other.elements, elements);
  }

  @override
  int get hashCode => Object.hash(
    coordinateSystem,
    showAxes,
    Object.hashAll(elements),
  );
}
