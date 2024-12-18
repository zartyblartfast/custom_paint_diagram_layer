import '../coordinate_system.dart';
import '../element_bounds.dart';
import '../elements/group_element.dart';

/// Utility class for mapping slider values to coordinate positions
class CoordinateMapper {
  final CoordinateSystem coordSystem;

  CoordinateMapper(this.coordSystem);

  /// Maps a slider value (0-1) to a position in the coordinate system
  double mapSliderToPosition({
    required double sliderValue,
    required bool isXAxis,
  }) {
    final min = isXAxis ? coordSystem.xRangeMin : coordSystem.yRangeMin;
    final max = isXAxis ? coordSystem.xRangeMax : coordSystem.yRangeMax;
    return min + (sliderValue * (max - min));
  }

  /// Maps a slider value to a position that respects diagram boundaries
  double mapSliderToSafePosition({
    required double sliderValue,
    required bool isXAxis,
    required GroupElement currentGroup,
  }) {
    // Get the proposed next position
    final nextPosition = mapSliderToPosition(
      sliderValue: sliderValue,
      isXAxis: isXAxis,
    );

    // Test if this position would violate boundaries
    final testGroup = GroupElement(
      x: isXAxis ? nextPosition : currentGroup.x,
      y: isXAxis ? currentGroup.y : nextPosition,
      children: currentGroup.children,
    );

    final bounds = ElementBounds(testGroup, coordSystem);
    
    // If no boundary violation, allow the move
    if (!bounds.isOutsideDiagramBounds()) {
      return nextPosition;
    }

    // If there is a violation, stay at current position
    return isXAxis ? currentGroup.x : currentGroup.y;
  }
} 