import 'package:flutter/material.dart';

/// A coordinate system that handles transformations between app-space and diagram-space coordinates.
///
/// The coordinate system is responsible for:
/// * Managing the mapping between app-space values and diagram-space coordinates
/// * Maintaining the origin point in canvas space
/// * Handling scaling between coordinate spaces
/// * Ensuring proper centering of the diagram
///
/// Key concepts:
/// * App-space: The logical coordinate space of your application's data
/// * Diagram-space: The physical pixel space where the diagram is rendered
/// * Origin: The reference point for coordinate transformations
/// * Scale: The factor that converts between app-space and diagram-space units
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
///
/// // Map a point from app-space to diagram-space
/// final diagramPoint = coordSystem.mapValueToDiagram(25, 75);
/// ```
///
/// Note: The coordinate system assumes Y-axis grows upward in diagram space,
/// which is the opposite of Flutter's default coordinate system.
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

  /// Creates a new CoordinateSystem with some properties updated.
  CoordinateSystem copyWith({
    Offset? origin,
    double? xRangeMin,
    double? xRangeMax,
    double? yRangeMin,
    double? yRangeMax,
    double? scale,
  }) {
    return CoordinateSystem(
      origin: origin ?? this.origin,
      xRangeMin: xRangeMin ?? this.xRangeMin,
      xRangeMax: xRangeMax ?? this.xRangeMax,
      yRangeMin: yRangeMin ?? this.yRangeMin,
      yRangeMax: yRangeMax ?? this.yRangeMax,
      scale: scale ?? this.scale,
    );
  }

  /// Transforms app-level coordinates to diagram space coordinates.
  ///
  /// Example:
  /// ```dart
  /// final point = coordSystem.mapValueToDiagram(50, 25);
  /// // If origin is (100, 100), scale is 2.0:
  /// // point will be Offset(200, 50)
  /// ```
  Offset mapValueToDiagram(double x, double y) {
    // Calculate the total ranges
    final xRange = xRangeMax - xRangeMin;
    final yRange = yRangeMax - yRangeMin;
    
    // Calculate the scaled distances from the minimum values
    final scaledX = (x - xRangeMin) * scale;
    final scaledY = (y - yRangeMin) * scale;
    
    // Center the coordinates relative to the origin
    double diagramX = origin.dx - (xRange * scale / 2) + scaledX;
    double diagramY = origin.dy + (yRange * scale / 2) - scaledY;
    
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CoordinateSystem &&
           other.origin == origin &&
           other.xRangeMin == xRangeMin &&
           other.xRangeMax == xRangeMax &&
           other.yRangeMin == yRangeMin &&
           other.yRangeMax == yRangeMax &&
           other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(
    origin,
    xRangeMin,
    xRangeMax,
    yRangeMin,
    yRangeMax,
    scale,
  );
}
