import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/testing/diagram_test_base.dart';

/// Demonstrates element positioning with engineering-style coordinates.
/// 
/// Key features demonstrated:
/// - X-axis at bottom of diagram (y = 0)
/// - Y-axis extends up from X-axis (positive only)
/// - Group element with overlapping shapes
/// - Boundary-aware vertical positioning
/// - Axes and grid visibility control
void main() {
  runApp(const MaterialApp(home: EngineeringCoordsTest()));
}

/// Test widget showing engineering coordinate system layout
class EngineeringCoordsTest extends DiagramTestBase {
  const EngineeringCoordsTest({super.key}) 
      : super(
          title: 'Engineering Coordinates Test',
          coordRange: 5.0,  // Smaller range since we're only using positive Y
        );

  @override
  EngineeringCoordsTestState createState() => EngineeringCoordsTestState();
}

/// State for the engineering coordinates test
class EngineeringCoordsTestState extends DiagramTestBaseState<EngineeringCoordsTest> {
  late GroupElement _group;

  @override
  double get elementHeight => 4.0; // Total height of group (2 units above and below center)

  @override
  CoordinateSystem createCoordinateSystem() {
    // Override to create engineering-style coordinate system
    return CoordinateSystem(
      origin: Offset.zero,  // Will be set by CanvasAlignment
      xRangeMin: -widget.coordRange,
      xRangeMax: widget.coordRange,
      yRangeMin: 0,  // Y starts at 0 (bottom)
      yRangeMax: widget.coordRange * 2,  // Double the range for positive Y only
      scale: 1.0,  // Will be adjusted by CanvasAlignment
    );
  }

  @override
  List<DrawableElement> createElements(double sliderValue) {
    // Create the group with initial elements
    final group = GroupElement(
      x: 0,
      y: 0,  // Initial position
      children: [
        // A semi-transparent blue rectangle
        RectangleElement(
          x: -1,
          y: -1,
          width: 2,
          height: 2,
          color: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.3),
        ),
        // An overlapping semi-transparent red circle
        CircleElement(
          x: 0,
          y: 0,
          radius: 1,
          color: Colors.red,
          fillColor: Colors.red.withOpacity(0.3),
        ),
      ],
    );
    print('Created group with ${group.children.length} children');

    // Calculate bounded position for the group
    final position = calculateBoundedPosition(
      element: group,
      sliderValue: sliderValue,
      coordinateSystem: diagramLayer.coordinateSystem,
      margin: widget.margin,
      elementHeight: elementHeight,
    );
    print('Calculated position: $position');

    // Create new group with updated position
    _group = group.copyWith(y: position);
    print('Created new group at position $position');

    return [_group];
  }
} 