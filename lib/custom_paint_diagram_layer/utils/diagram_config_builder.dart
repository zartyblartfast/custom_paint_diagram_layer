import 'package:flutter/material.dart';
import '../config/diagram_config.dart';
import '../core_diagram_base.dart';
import '../diagram.dart';
import '../coordinate_system.dart';

/// A utility class to build diagram configurations with sensible defaults
class DiagramConfigBuilder {
  /// Creates a standard diagram configuration with common settings
  static DiagramConfig createStandardConfig({
    // Size
    required double width,
    required double height,
    
    // Visibility
    bool showAxes = true,
    bool showGrid = true,
    bool showFrame = true,
    
    // Coordinate system
    double xRangeMin = 0,
    double xRangeMax = 10,
    double yRangeMin = 0,
    double yRangeMax = 10,
    Offset origin = const Offset(0, 0),
    double scale = 1.0,
    
    // Frame styling
    Color? frameStrokeColor,
    double frameStrokeWidth = 3.0,
    double frameStrokeOpacity = 0.8,
    bool frameFill = true,
    Color? frameFillColor,
    double frameFillOpacity = 0.1,
    
    // Axes styling
    Color? axisColor,
    double axisOpacity = 0.8,
  }) {
    return DiagramConfig(
      width: width,
      height: height,
      showAxes: showAxes,
      showGrid: showGrid,
      showFrame: showFrame,
      xRangeMin: xRangeMin,
      xRangeMax: xRangeMax,
      yRangeMin: yRangeMin,
      yRangeMax: yRangeMax,
      origin: origin,
      scale: scale,
      frameStrokeColor: frameStrokeColor ?? const Color.fromARGB(255, 48, 48, 48),
      frameStrokeWidth: frameStrokeWidth,
      frameStrokeOpacity: frameStrokeOpacity,
      frameFill: frameFill,
      frameFillColor: frameFillColor ?? const Color.fromARGB(255, 187, 231, 252),
      frameFillOpacity: frameFillOpacity,
      axisColor: axisColor ?? const Color.fromARGB(255, 0, 0, 0),
      axisOpacity: axisOpacity,
    );
  }

  /// Creates a configuration for a standalone diagram
  static DiagramConfig createStandaloneConfig() {
    return createStandardConfig(
      width: 600,
      height: 400,
    );
  }

  /// Creates a configuration for an embedded diagram
  static DiagramConfig createEmbeddedConfig() {
    return createStandardConfig(
      width: 400,
      height: 300,
    );
  }

  /// Creates a configuration based on whether it's standalone
  static DiagramConfig createResponsiveConfig({
    required bool standalone,
    double? customWidth,
    double? customHeight,
  }) {
    return createStandardConfig(
      width: customWidth ?? (standalone ? 600 : 400),
      height: customHeight ?? (standalone ? 400 : 300),
    );
  }
}
