import '../coordinate_system.dart';

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
} 