import 'package:flutter/material.dart';
import 'diagram.dart';

/// A custom painter that renders a diagram
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
