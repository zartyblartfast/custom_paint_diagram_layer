import 'package:flutter/material.dart';
import '../coordinate_system.dart';

/// Base class for all drawable elements in the diagram
abstract class DrawableElement {
  /// X coordinate in the diagram's coordinate system
  final double x;

  /// Y coordinate in the diagram's coordinate system
  final double y;

  /// Color of the element
  final Color color;

  /// Creates a new drawable element
  const DrawableElement({
    required this.x,
    required this.y,
    this.color = Colors.black,
  });

  /// Renders the element on the canvas using the provided coordinate system
  void render(Canvas canvas, CoordinateSystem coordinateSystem);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DrawableElement &&
           other.x == x &&
           other.y == y &&
           other.color == color;
  }

  @override
  int get hashCode => Object.hash(x, y, color);
}
