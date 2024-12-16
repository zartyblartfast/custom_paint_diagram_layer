import 'package:flutter/material.dart';
import '../coordinate_system.dart';
import '../drawable_element.dart';
import 'dart:math' as math;
import 'elements.dart';

/// A group element that can contain multiple child elements and transform them together.
class GroupElement extends DrawableElement {
  /// The list of child elements in this group
  final List<DrawableElement> children;

  /// Creates a new group element.
  /// 
  /// The [x] and [y] coordinates define the group's reference point.
  /// All child elements' positions are relative to this point.
  const GroupElement({
    required double x,
    required double y,
    required this.children,
    Color color = Colors.black,
  }) : super(x: x, y: y, color: color);

  /// Gets the relative bounds of the group's children
  /// Returns a record containing minX, maxX, minY, maxY relative to the group's position
  ({double minX, double maxX, double minY, double maxY}) getRelativeBounds() {
    if (children.isEmpty) {
      return (minX: 0, maxX: 0, minY: 0, maxY: 0);
    }

    // Start with the first child's position
    double minX = double.infinity;
    double maxX = double.negativeInfinity;
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    // Calculate bounds relative to group position
    for (final child in children) {
      if (child is RectangleElement) {
        minX = math.min(minX, child.x - child.width / 2);
        maxX = math.max(maxX, child.x + child.width / 2);
        minY = math.min(minY, child.y - child.height / 2);
        maxY = math.max(maxY, child.y + child.height / 2);
      } else if (child is CircleElement) {
        minX = math.min(minX, child.x - child.radius);
        maxX = math.max(maxX, child.x + child.radius);
        minY = math.min(minY, child.y - child.radius);
        maxY = math.max(maxY, child.y + child.radius);
      } else {
        // For other elements, just use their position
        minX = math.min(minX, child.x);
        maxX = math.max(maxX, child.x);
        minY = math.min(minY, child.y);
        maxY = math.max(maxY, child.y);
      }
    }

    return (minX: minX, maxX: maxX, minY: minY, maxY: maxY);
  }

  /// Gets the absolute bounds of the group including all children
  /// Returns a record containing minX, maxX, minY, maxY in absolute coordinates
  ({double minX, double maxX, double minY, double maxY}) getBounds() {
    final relativeBounds = getRelativeBounds();
    return (
      minX: x + relativeBounds.minX,
      maxX: x + relativeBounds.maxX,
      minY: y + relativeBounds.minY,
      maxY: y + relativeBounds.maxY,
    );
  }

  @override
  void render(Canvas canvas, CoordinateSystem coordinateSystem) {
    // Save the current canvas state
    canvas.save();
    
    // Get the group's position in diagram coordinates
    final groupPosition = coordinateSystem.mapValueToDiagram(x, y);
    
    // Create a translated coordinate system for the children
    final groupCoordinateSystem = CoordinateSystem(
      origin: coordinateSystem.origin + Offset(groupPosition.dx - coordinateSystem.origin.dx, groupPosition.dy - coordinateSystem.origin.dy),
      xRangeMin: coordinateSystem.xRangeMin,
      xRangeMax: coordinateSystem.xRangeMax,
      yRangeMin: coordinateSystem.yRangeMin,
      yRangeMax: coordinateSystem.yRangeMax,
      scale: coordinateSystem.scale,
    );

    // Render each child using the translated coordinate system
    for (final child in children) {
      child.render(canvas, groupCoordinateSystem);
    }

    // Restore the canvas state
    canvas.restore();
  }

  /// Creates a new group with updated position
  GroupElement copyWith({
    double? x,
    double? y,
    List<DrawableElement>? children,
    Color? color,
  }) {
    return GroupElement(
      x: x ?? this.x,
      y: y ?? this.y,
      children: children ?? this.children,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GroupElement &&
           other.x == x &&
           other.y == y &&
           other.color == color &&
           _listEquals(other.children, children);
  }

  @override
  int get hashCode => Object.hash(
    x,
    y,
    color,
    Object.hashAll(children),
  );

  /// Helper method to compare lists of elements
  bool _listEquals<T>(List<T> a, List<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
} 