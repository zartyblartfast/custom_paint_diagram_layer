import 'package:flutter/material.dart';
import 'layers/diagram_layer.dart';

/// A CustomPainter implementation that renders a Diagram onto a Flutter canvas.
///
/// This class bridges the gap between Flutter's painting system and our diagram layer.
/// It handles:
/// * Proper delegation of rendering to the diagram layer
/// * Efficient repaint decisions based on layer equality
/// * Integration with Flutter's CustomPaint widget
///
/// Usage:
/// ```dart
/// CustomPaint(
///   painter: CustomPaintRenderer(myDiagramLayer),
///   size: Size(400, 300),
/// )
/// ```
///
/// Performance considerations:
/// * The shouldRepaint method efficiently checks for layer changes
/// * Repainting only occurs when the layer reference changes
/// * The layer's immutable nature helps prevent unnecessary repaints
class CustomPaintRenderer extends CustomPainter {
  /// The diagram layer to render
  final IDiagramLayer layer;

  /// Creates a new custom paint renderer for the given diagram layer
  CustomPaintRenderer(this.layer);

  @override
  void paint(Canvas canvas, Size size) {
    layer.render(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is CustomPaintRenderer) {
      return oldDelegate.layer != layer;
    }
    return true;
  }
}
