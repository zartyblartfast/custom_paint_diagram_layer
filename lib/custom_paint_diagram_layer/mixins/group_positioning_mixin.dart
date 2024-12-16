import '../elements/group_element.dart';
import '../coordinate_system.dart';
import '../utils/group_positioning.dart';

/// Mixin that provides group positioning functionality for diagrams
mixin GroupPositioningMixin {
  /// Calculates the appropriate vertical position for a group within diagram bounds
  /// 
  /// [group] The group element to position
  /// [sliderValue] The current slider value (e.g., from -10 to +10)
  /// [coordinateSystem] The diagram's coordinate system
  /// [margin] The margin to maintain from diagram edges
  /// 
  /// Returns the y-coordinate for the group's center position
  double calculateGroupPosition({
    required GroupElement group,
    required double sliderValue,
    required CoordinateSystem coordinateSystem,
    required double margin,
  }) {
    final normalizedValue = GroupPositioner.normalizeValue(
      value: sliderValue,
      range: coordinateSystem.yRangeMax,
    );
    
    return GroupPositioner.calculateVerticalPosition(
      group: group,
      yMin: coordinateSystem.yRangeMin,
      yMax: coordinateSystem.yRangeMax,
      margin: margin,
      normalizedValue: normalizedValue,
    );
  }
} 