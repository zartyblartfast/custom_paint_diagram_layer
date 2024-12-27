import 'dart:convert';
import 'package:flutter/material.dart';

/// Configuration for diagram rendering settings.
/// 
/// Provides basic configuration options that can be expanded over time
/// without breaking existing implementations.
class DiagramConfig {
  /// Width of the diagram canvas
  final double width;
  
  /// Height of the diagram canvas
  final double height;
  
  /// Whether to show coordinate axes
  final bool showAxes;
  
  /// Whether to show the background grid
  final bool showGrid;

  /// Whether to show the diagram frame
  final bool showFrame;

  /// X-axis minimum value
  final double xRangeMin;

  /// X-axis maximum value
  final double xRangeMax;

  /// Y-axis minimum value
  final double yRangeMin;

  /// Y-axis maximum value
  final double yRangeMax;

  /// Scale factor for the coordinate system
  final double scale;

  /// Origin point in the coordinate system
  final Offset origin;

  /// Frame stroke color
  final Color frameStrokeColor;

  /// Frame stroke width
  final double frameStrokeWidth;

  /// Frame stroke opacity (0.0 to 1.0)
  final double frameStrokeOpacity;

  /// Whether to fill the frame
  final bool frameFill;

  /// Frame fill color
  final Color frameFillColor;

  /// Frame fill opacity (0.0 to 1.0)
  final double frameFillOpacity;

  /// Grid major line color
  final Color gridMajorColor;

  /// Grid major line opacity (0.0 to 1.0)
  final double gridMajorOpacity;

  /// Grid minor line color
  final Color gridMinorColor;

  /// Grid minor line opacity (0.0 to 1.0)
  final double gridMinorOpacity;

  /// Axes line color
  final Color axisColor;

  /// Axes line opacity (0.0 to 1.0)
  final double axisOpacity;

  /// Creates a new diagram configuration
  const DiagramConfig({
    this.width = 600,
    this.height = 600,
    this.showAxes = true,
    this.showGrid = true,
    this.showFrame = false,
    this.xRangeMin = -10,
    this.xRangeMax = 10,
    this.yRangeMin = -10,
    this.yRangeMax = 10,
    this.scale = 1.0,
    this.origin = Offset.zero,
    this.frameStrokeColor = Colors.black,
    this.frameStrokeWidth = 2.0,
    this.frameStrokeOpacity = 1.0,
    this.frameFill = false,
    this.frameFillColor = Colors.white,
    this.frameFillOpacity = 1.0,
    this.gridMajorColor = const Color.fromRGBO(128, 128, 128, 1),  // Grey
    this.gridMajorOpacity = 0.5,
    this.gridMinorColor = const Color.fromRGBO(128, 128, 128, 1),  // Grey
    this.gridMinorOpacity = 0.2,
    this.axisColor = const Color.fromRGBO(0, 0, 0, 1),  // Black
    this.axisOpacity = 1.0,
  });

  /// Creates a configuration from JSON string
  factory DiagramConfig.fromJson(String json) {
    final map = jsonDecode(json);
    return DiagramConfig(
      width: map['width']?.toDouble() ?? 600,
      height: map['height']?.toDouble() ?? 600,
      showAxes: map['showAxes'] ?? true,
      showGrid: map['showGrid'] ?? true,
      showFrame: map['showFrame'] ?? false,
      xRangeMin: map['xRangeMin']?.toDouble() ?? -10,
      xRangeMax: map['xRangeMax']?.toDouble() ?? 10,
      yRangeMin: map['yRangeMin']?.toDouble() ?? -10,
      yRangeMax: map['yRangeMax']?.toDouble() ?? 10,
      scale: map['scale']?.toDouble() ?? 1.0,
      origin: map['origin'] != null 
        ? Offset(
            (map['origin']['x'] ?? 0.0).toDouble(),
            (map['origin']['y'] ?? 0.0).toDouble(),
          )
        : Offset.zero,
      frameStrokeColor: map['frameStrokeColor'] != null 
        ? Color(map['frameStrokeColor']) 
        : Colors.black,
      frameStrokeWidth: map['frameStrokeWidth']?.toDouble() ?? 2.0,
      frameStrokeOpacity: map['frameStrokeOpacity']?.toDouble() ?? 1.0,
      frameFill: map['frameFill'] ?? false,
      frameFillColor: map['frameFillColor'] != null 
        ? Color(map['frameFillColor']) 
        : Colors.white,
      frameFillOpacity: map['frameFillOpacity']?.toDouble() ?? 1.0,
      gridMajorColor: map['gridMajorColor'] != null 
        ? Color(map['gridMajorColor']) 
        : const Color.fromRGBO(128, 128, 128, 1),
      gridMajorOpacity: map['gridMajorOpacity']?.toDouble() ?? 0.5,
      gridMinorColor: map['gridMinorColor'] != null 
        ? Color(map['gridMinorColor']) 
        : const Color.fromRGBO(128, 128, 128, 1),
      gridMinorOpacity: map['gridMinorOpacity']?.toDouble() ?? 0.2,
      axisColor: map['axisColor'] != null 
        ? Color(map['axisColor']) 
        : const Color.fromRGBO(0, 0, 0, 1),
      axisOpacity: map['axisOpacity']?.toDouble() ?? 1.0,
    );
  }

  /// Creates a copy of this configuration with some properties updated
  DiagramConfig copyWith({
    double? width,
    double? height,
    bool? showAxes,
    bool? showGrid,
    bool? showFrame,
    double? xRangeMin,
    double? xRangeMax,
    double? yRangeMin,
    double? yRangeMax,
    double? scale,
    Offset? origin,
    Color? frameStrokeColor,
    double? frameStrokeWidth,
    double? frameStrokeOpacity,
    bool? frameFill,
    Color? frameFillColor,
    double? frameFillOpacity,
    Color? gridMajorColor,
    double? gridMajorOpacity,
    Color? gridMinorColor,
    double? gridMinorOpacity,
    Color? axisColor,
    double? axisOpacity,
  }) {
    return DiagramConfig(
      width: width ?? this.width,
      height: height ?? this.height,
      showAxes: showAxes ?? this.showAxes,
      showGrid: showGrid ?? this.showGrid,
      showFrame: showFrame ?? this.showFrame,
      xRangeMin: xRangeMin ?? this.xRangeMin,
      xRangeMax: xRangeMax ?? this.xRangeMax,
      yRangeMin: yRangeMin ?? this.yRangeMin,
      yRangeMax: yRangeMax ?? this.yRangeMax,
      scale: scale ?? this.scale,
      origin: origin ?? this.origin,
      frameStrokeColor: frameStrokeColor ?? this.frameStrokeColor,
      frameStrokeWidth: frameStrokeWidth ?? this.frameStrokeWidth,
      frameStrokeOpacity: frameStrokeOpacity ?? this.frameStrokeOpacity,
      frameFill: frameFill ?? this.frameFill,
      frameFillColor: frameFillColor ?? this.frameFillColor,
      frameFillOpacity: frameFillOpacity ?? this.frameFillOpacity,
      gridMajorColor: gridMajorColor ?? this.gridMajorColor,
      gridMajorOpacity: gridMajorOpacity ?? this.gridMajorOpacity,
      gridMinorColor: gridMinorColor ?? this.gridMinorColor,
      gridMinorOpacity: gridMinorOpacity ?? this.gridMinorOpacity,
      axisColor: axisColor ?? this.axisColor,
      axisOpacity: axisOpacity ?? this.axisOpacity,
    );
  }

  /// Converts the configuration to a JSON string
  String toJson() {
    return jsonEncode({
      'width': width,
      'height': height,
      'showAxes': showAxes,
      'showGrid': showGrid,
      'showFrame': showFrame,
      'xRangeMin': xRangeMin,
      'xRangeMax': xRangeMax,
      'yRangeMin': yRangeMin,
      'yRangeMax': yRangeMax,
      'scale': scale,
      'origin': {
        'x': origin.dx,
        'y': origin.dy,
      },
      'frameStrokeColor': frameStrokeColor.value,
      'frameStrokeWidth': frameStrokeWidth,
      'frameStrokeOpacity': frameStrokeOpacity,
      'frameFill': frameFill,
      'frameFillColor': frameFillColor.value,
      'frameFillOpacity': frameFillOpacity,
      'gridMajorColor': gridMajorColor.value,
      'gridMajorOpacity': gridMajorOpacity,
      'gridMinorColor': gridMinorColor.value,
      'gridMinorOpacity': gridMinorOpacity,
      'axisColor': axisColor.value,
      'axisOpacity': axisOpacity,
    });
  }
}
