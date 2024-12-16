import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/testing/diagram_test_base.dart';

/// Demonstrates group element boundary positioning with overlapping elements.
/// 
/// Key features demonstrated:
/// - Group element with overlapping rectangle and circle
/// - Boundary-aware vertical positioning
/// - Proper margin handling at diagram edges
/// - Axes and grid visibility control
void main() {
  runApp(const MaterialApp(home: GroupBoundaryTest()));
}

/// Test widget showing group element boundary positioning
class GroupBoundaryTest extends DiagramTestBase {
  const GroupBoundaryTest({super.key}) 
      : super(title: 'Group Boundary Test');

  @override
  GroupBoundaryTestState createState() => GroupBoundaryTestState();
}

/// State for the group boundary test
class GroupBoundaryTestState extends DiagramTestBaseState<GroupBoundaryTest> {
  late GroupElement _group;

  @override
  double get elementHeight => 4.0; // Total height of group (2 units above and below center)

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