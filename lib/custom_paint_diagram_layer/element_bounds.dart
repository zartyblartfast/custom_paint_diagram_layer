import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'coordinate_system.dart';
import 'elements/elements.dart';
import 'drawable_element.dart';

/// Calculates and manages element boundary information
class ElementBounds {
  late final double minX, maxX, minY, maxY;
  final CoordinateSystem coordSystem;

  ElementBounds(DrawableElement element, this.coordSystem) {
    _calculateBounds(element);
    // Debug prints
    print('\nCalculated Bounds:');
    print('Width: ${maxX - minX}');
    print('Height: ${maxY - minY}');
    print('Center: (${(minX + maxX) / 2}, ${(minY + maxY) / 2})');
  }

  void _calculateBounds(DrawableElement element) {
    if (element is GroupElement) {
      _calculateGroupBounds(element);
    } else {
      _calculateElementBounds(element);
    }
  }

  void _calculateElementBounds(DrawableElement element) {
    // Use local variables for calculations
    double localMinX = double.infinity;
    double localMaxX = -double.infinity;
    double localMinY = double.infinity;
    double localMaxY = -double.infinity;

    print('\nProcessing ${element.runtimeType}:');
    print('  Position: (${element.x}, ${element.y})');

    if (element is RectangleElement) {
      final halfWidth = element.width / 2;
      final halfHeight = element.height / 2;
      
      localMinX = element.x - halfWidth;
      localMaxX = element.x + halfWidth;
      localMinY = element.y - halfHeight;
      localMaxY = element.y + halfHeight;

      print('  Width: ${element.width}, Height: ${element.height}');
    } else if (element is CircleElement) {
      localMinX = element.x - element.radius;
      localMaxX = element.x + element.radius;
      localMinY = element.y - element.radius;
      localMaxY = element.y + element.radius;

      print('  Radius: ${element.radius} (Diameter: ${element.radius * 2})');
    } else if (element is GroupElement) {
      print('  Processing group children:');
      for (final child in element.children) {
        // Recursively calculate bounds for each child
        final childBounds = ElementBounds(child, coordSystem);
        localMinX = math.min(localMinX, childBounds.minX);
        localMaxX = math.max(localMaxX, childBounds.maxX);
        localMinY = math.min(localMinY, childBounds.minY);
        localMaxY = math.max(localMaxY, childBounds.maxY);
      }
    } else {
      // For other elements, use their position as a point
      localMinX = element.x;
      localMaxX = element.x;
      localMinY = element.y;
      localMaxY = element.y;
      print('  Using position as bounds');
    }

    // Assign to final fields
    minX = localMinX;
    maxX = localMaxX;
    minY = localMinY;
    maxY = localMaxY;

    // Print calculated bounds
    print('  Bounds:');
    print('    Width: ${maxX - minX} (from minX=$minX to maxX=$maxX)');
    print('    Height: ${maxY - minY} (from minY=$minY to maxY=$maxY)');
    print('    Center: (${(minX + maxX) / 2}, ${(minY + maxY) / 2})');
  }

  void _calculateGroupBounds(GroupElement group) {
    print('\n=== DETAILED BOUNDS CALCULATION ===');
    print('Group position: (${group.x}, ${group.y})');

    // Initialize bounds
    double localMinX = double.infinity;
    double localMaxX = -double.infinity;
    double localMinY = double.infinity;
    double localMaxY = -double.infinity;

    // Process each child
    for (var child in group.children) {
      if (child is RectangleElement) {
        print('\nRectangle Details:');
        print('  Raw position: (${child.x}, ${child.y})');
        print('  Dimensions: ${child.width}x${child.height}');
        
        // Rectangle uses top-left coordinates
        final childMinX = group.x + child.x;  // Offset by group position
        final childMaxX = group.x + child.x + child.width;
        final childMinY = group.y + child.y;  // Offset by group position
        final childMaxY = group.y + child.y + child.height;

        print('  Calculated bounds:');
        print('    X: $childMinX to $childMaxX (width: ${childMaxX - childMinX})');
        print('    Y: $childMinY to $childMaxY (height: ${childMaxY - childMinY})');
        print('    Center: (${(childMinX + childMaxX) / 2}, ${(childMinY + childMaxY) / 2})');
        
        localMinX = math.min(localMinX, childMinX);
        localMaxX = math.max(localMaxX, childMaxX);
        localMinY = math.min(localMinY, childMinY);
        localMaxY = math.max(localMaxY, childMaxY);
      } else if (child is CircleElement) {
        print('\nCircle Details:');
        print('  Center position: (${child.x}, ${child.y})');
        print('  Radius: ${child.radius}');
        
        // Circle uses center coordinates
        final childMinX = group.x + child.x - child.radius;  // Offset by group position
        final childMaxX = group.x + child.x + child.radius;
        final childMinY = group.y + child.y - child.radius;  // Offset by group position
        final childMaxY = group.y + child.y + child.radius;

        print('  Calculated bounds:');
        print('    X: $childMinX to $childMaxX (width: ${childMaxX - childMinX})');
        print('    Y: $childMinY to $childMaxY (height: ${childMaxY - childMinY})');
        print('    Center: (${(childMinX + childMaxX) / 2}, ${(childMinY + childMaxY) / 2})');
        
        localMinX = math.min(localMinX, childMinX);
        localMaxX = math.max(localMaxX, childMaxX);
        localMinY = math.min(localMinY, childMinY);
        localMaxY = math.max(localMaxY, childMaxY);
      }

      print('\nCurrent Combined Bounds:');
      print('  X: $localMinX to $localMaxX (width: ${localMaxX - localMinX})');
      print('  Y: $localMinY to $localMaxY (height: ${localMaxY - localMinY})');
      print('  Center: (${(localMinX + localMaxX) / 2}, ${(localMinY + localMaxY) / 2})');
    }

    // Assign final bounds
    minX = localMinX;
    maxX = localMaxX;
    minY = localMinY;
    maxY = localMaxY;

    print('\nFINAL Group Bounds:');
    print('  Width: ${maxX - minX} (from minX=$minX to maxX=$maxX)');
    print('  Height: ${maxY - minY} (from minY=$minY to maxY=$maxY)');
    print('  Center: (${(minX + maxX) / 2}, ${(minY + maxY) / 2})');
    print('=== END BOUNDS CALCULATION ===\n');
  }

  // Properties for diagnostic display
  double get width => maxX - minX;  // Calculate from actual bounds
  double get height => maxY - minY;  // Calculate from actual bounds
  double get centerX => (minX + maxX) / 2;
  double get centerY => (minY + maxY) / 2;

  // Boundary checking
  bool isOutsideDiagramBounds() {
    // Check if any part of the element extends beyond diagram bounds
    return minX < coordSystem.xRangeMin ||
           maxX > coordSystem.xRangeMax ||
           maxY > coordSystem.yRangeMax ||
           minY <= coordSystem.yRangeMin;    // Use <= for bottom boundary
  }

  // Detailed boundary checking
  Map<String, bool> getOutOfBoundsEdges() {
    return {
      'left': minX < coordSystem.xRangeMin,
      'right': maxX > coordSystem.xRangeMax,
      'top': maxY > coordSystem.yRangeMax,
      'bottom': minY <= coordSystem.yRangeMin,  // Use <= for bottom boundary
    };
  }

  // Get the amount by which the element violates boundaries
  Map<String, double> getBoundaryViolations() {
    return {
      'left': coordSystem.xRangeMin - minX,
      'right': maxX - coordSystem.xRangeMax,
      'top': coordSystem.yRangeMin - minY,
      'bottom': maxY - coordSystem.yRangeMax,
    };
  }

  /// Returns a position adjustment needed to keep the element within diagram bounds
  /// Returns null if no adjustment is needed
  Offset? calculateSafePosition() {
    if (!isOutsideDiagramBounds()) {
      return null; // Already safe
    }

    final violations = getBoundaryViolations();
    double xCorrection = 0;
    double yCorrection = 0;

    if (violations['left']! > 0) xCorrection = violations['left']!;
    if (violations['right']! > 0) xCorrection = -violations['right']!;
    if (violations['top']! > 0) yCorrection = violations['top']!;
    if (violations['bottom']! > 0) yCorrection = -violations['bottom']!;

    return Offset(xCorrection, yCorrection);
  }
}
