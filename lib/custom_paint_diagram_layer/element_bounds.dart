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
  }

  void _calculateBounds(DrawableElement element) {
    if (element is GroupElement) {
      _calculateGroupBounds(element);
    } else {
      _calculateElementBounds(element);
    }
  }

  void _calculateElementBounds(DrawableElement element) {
    List<Offset> localPoints;
    
    if (element is RectangleElement) {
      localPoints = [
        Offset(element.x - element.width/2, element.y - element.height/2),
        Offset(element.x + element.width/2, element.y - element.height/2),
        Offset(element.x - element.width/2, element.y + element.height/2),
        Offset(element.x + element.width/2, element.y + element.height/2),
      ];
    } else if (element is CircleElement) {
      localPoints = [
        Offset(element.x - element.radius, element.y - element.radius),
        Offset(element.x + element.radius, element.y - element.radius),
        Offset(element.x - element.radius, element.y + element.radius),
        Offset(element.x + element.radius, element.y + element.radius),
      ];
    } else {
      localPoints = [Offset(element.x, element.y)];
    }
    
    var diagramPoints = localPoints.map((p) => coordSystem.mapValueToDiagram(p.dx, p.dy)).toList();

    minX = diagramPoints.map((p) => p.dx).reduce(math.min);
    maxX = diagramPoints.map((p) => p.dx).reduce(math.max);
    minY = diagramPoints.map((p) => p.dy).reduce(math.min);
    maxY = diagramPoints.map((p) => p.dy).reduce(math.max);
  }

  void _calculateGroupBounds(GroupElement group) {
    double globalMinX = double.infinity;
    double globalMaxX = -double.infinity;
    double globalMinY = double.infinity;
    double globalMaxY = -double.infinity;
    
    for (var child in group.children) {
      var childBounds = ElementBounds(child, coordSystem);
      
      globalMinX = math.min(globalMinX, childBounds.minX);
      globalMaxX = math.max(globalMaxX, childBounds.maxX);
      globalMinY = math.min(globalMinY, childBounds.minY);
      globalMaxY = math.max(globalMaxY, childBounds.maxY);
    }

    minX = globalMinX + group.x;
    maxX = globalMaxX + group.x;
    minY = globalMinY + group.y;
    maxY = globalMaxY + group.y;
  }

  // Properties for diagnostic display
  double get width => maxX - minX;
  double get height => maxY - minY;
  double get centerX => (minX + maxX) / 2;
  double get centerY => (minY + maxY) / 2;

  // Boundary checking
  bool isOutsideDiagramBounds() {
    return minX < coordSystem.xRangeMin ||
           maxX > coordSystem.xRangeMax ||
           minY < coordSystem.yRangeMin ||
           maxY > coordSystem.yRangeMax;
  }

  // Detailed boundary checking
  Map<String, bool> getOutOfBoundsEdges() {
    return {
      'left': minX < coordSystem.xRangeMin,
      'right': maxX > coordSystem.xRangeMax,
      'top': maxY > coordSystem.yRangeMax,
      'bottom': minY < coordSystem.yRangeMin,
    };
  }

  // Get the amount by which the element violates boundaries
  Map<String, double> getBoundaryViolations() {
    return {
      'left': coordSystem.xRangeMin - minX,
      'right': maxX - coordSystem.xRangeMax,
      'top': maxY - coordSystem.yRangeMax,
      'bottom': coordSystem.yRangeMin - minY,
    };
  }

  /// Returns a position adjustment needed to keep the element within diagram bounds
  /// Returns null if no adjustment is needed
  Offset? calculateSafePosition() {
    if (!isOutsideDiagramBounds()) {
      return null;  // Already safe, no adjustment needed
    }

    // Get current violations
    final violations = getBoundaryViolations();
    
    // Calculate corrections needed
    double xCorrection = 0;
    double yCorrection = 0;
    
    if (violations['left']! > 0) xCorrection = violations['left']!;
    if (violations['right']! > 0) xCorrection = -violations['right']!;
    if (violations['bottom']! > 0) yCorrection = violations['bottom']!;
    if (violations['top']! > 0) yCorrection = -violations['top']!;

    return Offset(xCorrection, yCorrection);
  }
} 