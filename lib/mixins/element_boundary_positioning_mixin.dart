import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

mixin ElementBoundaryPositioningMixin {
  /// Calculates an element's position based on slider value while respecting diagram boundaries
  double calculateBoundedPosition({
    required DrawableElement element,
    required double sliderValue,
    required CoordinateSystem coordinateSystem,
    required double margin,
    required double elementHeight,
  }) {
    // Calculate the valid range where the element can be positioned
    // This accounts for the element's height and margins
    final validMin = coordinateSystem.yRangeMin + margin + (elementHeight / 2);
    final validMax = coordinateSystem.yRangeMax - margin - (elementHeight / 2);
    final validRange = validMax - validMin;
    
    // Calculate how far through the slider's range we are (0.0 to 1.0)
    final sliderProgress = (sliderValue - coordinateSystem.yRangeMin) / 
        (coordinateSystem.yRangeMax - coordinateSystem.yRangeMin);
    
    // Map the slider progress to the valid position range
    final position = validMin + (sliderProgress * validRange);
           
    // Debug output
    print('\nBoundary Calculation Debug:');
    print('Input values:');
    print('  sliderValue: $sliderValue');
    print('  coordinateSystem:');
    print('    yRange: ${coordinateSystem.yRangeMin} to ${coordinateSystem.yRangeMax}');
    print('  margin: $margin');
    print('  elementHeight: $elementHeight');
    print('\nCalculated values:');
    print('  validMin: $validMin');
    print('  validMax: $validMax');
    print('  validRange: $validRange');
    print('  sliderProgress: $sliderProgress');
    print('  position: $position');
    print('  element edges will be at: ${position - elementHeight/2} to ${position + elementHeight/2}');
    
    return position;
  }
} 