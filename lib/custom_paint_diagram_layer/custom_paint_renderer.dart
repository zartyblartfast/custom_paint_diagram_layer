import 'package:flutter/material.dart';
import 'diagram.dart';

/// A CustomPainter implementation that renders a Diagram onto a Flutter canvas.
///
/// This class bridges the gap between Flutter's painting system and our diagram layer.
/// It handles:
/// * Proper delegation of rendering to the Diagram
/// * Efficient repaint decisions based on diagram equality
/// * Integration with Flutter's CustomPaint widget
///
/// Usage:
/// ```dart
/// CustomPaint(
///   painter: CustomPaintRenderer(myDiagram),
///   size: Size(400, 300),
/// )
/// ```
///
/// Performance considerations:
/// * The shouldRepaint method efficiently checks for diagram changes
/// * Repainting only occurs when the diagram reference changes
/// * The diagram's immutable nature helps prevent unnecessary repaints
class CustomPaintRenderer extends CustomPainter {
  /// The diagram to render
  final Diagram diagram;

  /// Creates a new custom paint renderer for the given diagram
  CustomPaintRenderer(this.diagram);

  @override
  void paint(Canvas canvas, Size size) {
    diagram.render(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is CustomPaintRenderer) {
      return oldDelegate.diagram != diagram;
    }
    return true;
  }
}
