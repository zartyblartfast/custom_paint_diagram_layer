import 'package:flutter/material.dart';
import '../coordinate_system.dart';
import '../drawable_element.dart';

/// Represents a text element in the diagram.
class TextElement extends DrawableElement {
  /// The text content to display
  final String text;

  /// The text style to use for rendering
  final TextStyle? style;

  /// Creates a new text element.
  /// 
  /// The text will be positioned at (x, y) with the specified text content.
  /// Optionally, a [style] can be provided to customize the text appearance.
  /// The color parameter is used as the text color if no style is provided.
  const TextElement({
    required double x,
    required double y,
    required this.text,
    required Color color,
    this.style,
  }) : super(x: x, y: y, color: color);

  @override
  void render(Canvas canvas, CoordinateSystem coordinateSystem) {
    final position = coordinateSystem.mapValueToDiagram(x, y);
    
    // Create text painter
    final textSpan = TextSpan(
      text: text,
      style: style ?? TextStyle(color: color),
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Layout and paint text
    textPainter.layout();
    
    // Center the text at the specified position
    final offset = Offset(
      position.dx - (textPainter.width / 2),
      position.dy - (textPainter.height / 2),
    );
    
    textPainter.paint(canvas, offset);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextElement &&
           other.x == x &&
           other.y == y &&
           other.text == text &&
           other.color == color &&
           other.style == style;
  }

  @override
  int get hashCode => Object.hash(x, y, text, color, style);
}
