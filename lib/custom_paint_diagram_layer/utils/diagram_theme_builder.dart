import 'package:flutter/material.dart';
import '../config/diagram_config.dart';
import '../elements/elements.dart';

/// A utility class to create themed diagram elements
class DiagramThemeBuilder {
  /// Create a background element with theme colors
  static RectangleElement createBackgroundElement(
    DiagramConfig config,
    Map<String, Color> colors,
  ) {
    return RectangleElement(
      x: config.xRangeMin - 1,
      y: config.yRangeMin - 1,
      width: (config.xRangeMax - config.xRangeMin) + 2,
      height: (config.yRangeMax - config.yRangeMin) + 2,
      color: colors['background']!,
      fillColor: colors['background']!,
      strokeWidth: 0,  // No border for background
    );
  }

  /// Create a grid element with theme colors
  static GridElement createGridElement(Map<String, Color> colors) {
    return GridElement(
      x: 0,
      y: 0,
      majorSpacing: 1.0,
      minorSpacing: 0.2,
      majorColor: colors['grid']!,
      minorColor: colors['gridMinor']!,
      majorStrokeWidth: 1.0,
      minorStrokeWidth: 0.5,
    );
  }

  /// Create a frame element with theme colors
  static FrameElement createFrameElement(Map<String, Color> colors) {
    return FrameElement(
      color: colors['element']!.withOpacity(0.7),
      strokeWidth: 1.0,
    );
  }

  /// Create axis elements with theme colors
  static List<AxisElement> createAxisElements(Map<String, Color> colors) {
    final color = colors['element']!.withOpacity(0.7);
    return [
      XAxisElement(
        yValue: 0,
        color: color,
        tickInterval: 1.0,
      ),
      YAxisElement(
        xValue: 0,
        color: color,
        tickInterval: 1.0,
      ),
    ];
  }
}
