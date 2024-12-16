import 'package:flutter/material.dart';
import '../elements/group_element.dart';
import '../coordinate_system.dart';

/// Utility class for calculating group element positions within diagram bounds
class GroupPositioner {
  /// Calculates the position for a group element within diagram bounds
  /// Returns the y-coordinate for the group's center position
  static double calculateVerticalPosition({
    required GroupElement group,
    required double yMin,
    required double yMax,
    required double margin,
    required double normalizedValue,  // 0.0 to 1.0
  }) {
    final bounds = group.getRelativeBounds();
    final bottomPosition = (yMin + margin) - bounds.minY;
    final topPosition = yMax - margin;
    return bottomPosition + ((topPosition - bottomPosition) * normalizedValue);
  }

  /// Converts a slider value to a normalized value (0.0 to 1.0)
  /// [value] is the current slider value
  /// [range] is the coordinate range (e.g., 10.0 for -10 to +10)
  static double normalizeValue({
    required double value,
    required double range,
  }) {
    return (value + range) / (range * 2);
  }
} 