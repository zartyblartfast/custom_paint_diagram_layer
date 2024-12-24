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

  /// Creates a new diagram configuration
  const DiagramConfig({
    this.width = 600,
    this.height = 600,
    this.showAxes = true,
    this.showGrid = true,
  });

  /// Creates a configuration from JSON string
  factory DiagramConfig.fromJson(String json) {
    final map = jsonDecode(json);
    return DiagramConfig(
      width: map['width']?.toDouble() ?? 600,
      height: map['height']?.toDouble() ?? 600,
      showAxes: map['showAxes'] ?? true,
      showGrid: map['showGrid'] ?? true,
    );
  }

  /// Creates a copy of this configuration with some properties updated
  DiagramConfig copyWith({
    double? width,
    double? height,
    bool? showAxes,
    bool? showGrid,
  }) {
    return DiagramConfig(
      width: width ?? this.width,
      height: height ?? this.height,
      showAxes: showAxes ?? this.showAxes,
      showGrid: showGrid ?? this.showGrid,
    );
  }
}
