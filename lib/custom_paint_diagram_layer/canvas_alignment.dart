import 'package:flutter/material.dart';
import 'coordinate_system.dart';

/// Manages the alignment and scaling of a CoordinateSystem relative to a canvas.
///
/// This class is responsible for:
/// * Calculating and applying the appropriate scale factor based on canvas dimensions
/// * Positioning the coordinate system origin relative to the canvas
/// * Ensuring atomic updates of both scale and origin
///
/// The alignment operations are atomic, meaning that scale and origin are always
/// updated together to maintain visual consistency. This prevents temporary visual
/// artifacts that could occur if these properties were updated separately.
///
/// Usage:
/// ```dart
/// final alignment = CanvasAlignment(
///   canvasSize: Size(400, 300),
///   coordinateSystem: myCoordinateSystem,
/// );
///
/// // Center the coordinate system on the canvas
/// alignment.alignCenter();
///
/// // Or align to the bottom center
/// alignment.alignBottomCenter();
/// ```
///
/// Note: After alignment operations, the coordinate system will be modified
/// to maintain the new position and scale. The original coordinate system
/// is not preserved.
class CanvasAlignment {
  /// The size of the canvas being rendered to
  final Size canvasSize;
  
  /// The coordinate system to align
  CoordinateSystem coordinateSystem;

  /// Creates a new canvas alignment handler
  CanvasAlignment({
    required this.canvasSize,
    required CoordinateSystem coordinateSystem,
  }) : coordinateSystem = coordinateSystem.copyWith();

  /// Updates the scale of the coordinate system based on canvas size and coordinate range
  void updateScale() {
    final xRange = coordinateSystem.xRangeMax - coordinateSystem.xRangeMin;
    final yRange = coordinateSystem.yRangeMax - coordinateSystem.yRangeMin;
    
    final xScale = canvasSize.width / xRange;
    final yScale = canvasSize.height / yRange;
    
    final newScale = xScale.abs() < yScale.abs() ? xScale.abs() : yScale.abs();
    
    coordinateSystem = coordinateSystem.copyWith(
      scale: newScale,
    );
  }

  /// Aligns the CoordinateSystem.origin to the center of the canvas
  void alignCenter() {
    // Calculate the scale first
    updateScale();
    
    // Calculate center position
    final center = Offset(
      canvasSize.width / 2,
      canvasSize.height / 2,
    );
    
    // Update origin
    coordinateSystem = coordinateSystem.copyWith(
      origin: center,
    );
  }

  /// Aligns the CoordinateSystem.origin to the bottom center of the canvas
  void alignBottomCenter() {
    // Calculate the scale first
    updateScale();
    
    // Calculate bottom center position
    final bottomCenter = Offset(
      canvasSize.width / 2,
      canvasSize.height,
    );
    
    // Update origin
    coordinateSystem = coordinateSystem.copyWith(
      origin: bottomCenter,
    );
  }
}
