import 'package:flutter/material.dart';

/// A coordinate system that handles transformations between app-space and diagram-space coordinates.
///
/// The coordinate system manages:
/// * Origin placement in canvas space
/// * X and Y axis ranges in diagram space
/// * Scaling between diagram and canvas space
///
/// Example:
/// ```dart
/// final coordSystem = CoordinateSystem(
///   origin: Offset(100, 100),
///   xRangeMin: -50,
///   xRangeMax: 50,
///   yRangeMin: 0,
///   yRangeMax: 100,
///   scale: 2.0,
/// );
/// ```
class CoordinateSystem {
  /// The origin point in canvas space
  final Offset origin;

  /// The minimum x-value in diagram space
  final double xRangeMin;

  /// The maximum x-value in diagram space
  final double xRangeMax;

  /// The minimum y-value in diagram space
  final double yRangeMin;

  /// The maximum y-value in diagram space
  final double yRangeMax;

  /// The scaling factor for transforming between diagram and canvas space
  final double scale;

  /// Creates a new coordinate system with the specified parameters.
  ///
  /// The [xRangeMax] must be greater than [xRangeMin],
  /// [yRangeMax] must be greater than [yRangeMin],
  /// and [scale] must be greater than zero.
  const CoordinateSystem({
    required this.origin,
    required this.xRangeMin,
    required this.xRangeMax,
    required this.yRangeMin,
    required this.yRangeMax,
    required this.scale,
  }) : assert(xRangeMax > xRangeMin, 'xRangeMax must be greater than xRangeMin'),
       assert(yRangeMax > yRangeMin, 'yRangeMax must be greater than yRangeMin'),
       assert(scale > 0, 'Scale must be greater than zero');

  /// Transforms app-level coordinates to diagram space coordinates.
  ///
  /// Example:
  /// ```dart
  /// final point = coordSystem.mapValueToDiagram(50, 25);
  /// // If origin is (100, 100), scale is 2.0:
  /// // point will be Offset(200, 50)
  /// ```
  Offset mapValueToDiagram(double x, double y) {
    // X-axis: transform from range to centered coordinates
    double diagramX = origin.dx + (x - xRangeMin) * scale;
    
    // Y-axis: transform from range to bottom-up coordinates
    double diagramY = origin.dy - (y - yRangeMin) * scale;
    
    return Offset(diagramX, diagramY);
  }

  /// Transforms diagram space coordinates back to app-level coordinates.
  ///
  /// Example:
  /// ```dart
  /// final point = coordSystem.mapDiagramToValue(200, 50);
  /// // If origin is (100, 100), scale is 2.0:
  /// // point will be Offset(50, 25)
  /// ```
  Offset mapDiagramToValue(double x, double y) {
    // X-axis: transform from centered coordinates to range
    double appX = (x - origin.dx) / scale + xRangeMin;
    
    // Y-axis: transform from bottom-up coordinates to range
    double appY = (origin.dy - y) / scale + yRangeMin;
    
    return Offset(appX, appY);
  }
}
