import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import '../utils/diagram_test_base.dart';

class RoundedRectTest extends DiagramTestBase {
  const RoundedRectTest({super.key}) : super(
    title: 'Rounded Rectangle Test',
    coordRange: 10.0,  // Reduced from 200 to 10 for better scaling
  );

  @override
  DiagramTestBaseState<RoundedRectTest> createState() => _RoundedRectTestState();
}

class _RoundedRectTestState extends DiagramTestBaseState<RoundedRectTest> {
  @override
  List<DrawableElement> createElements(double sliderValue) {
    final elements = <DrawableElement>[];
    
    // Add rectangles with different border radii
    elements.add(RectangleElement(
      x: -6,
      y: 4,
      width: 3,
      height: 2,
      color: Colors.blue,
      fillColor: Colors.blue.withOpacity(0.2),
      borderRadius: 0,  // Sharp corners
    ));

    elements.add(RectangleElement(
      x: -1.5,
      y: 4,
      width: 3,
      height: 2,
      color: Colors.green,
      fillColor: Colors.green.withOpacity(0.2),
      borderRadius: 0.2,  // Slightly rounded
    ));

    elements.add(RectangleElement(
      x: 3,
      y: 4,
      width: 3,
      height: 2,
      color: Colors.red,
      fillColor: Colors.red.withOpacity(0.2),
      borderRadius: 0.5,  // Very rounded
    ));

    // Add labels
    elements.add(TextElement(
      x: -6,
      y: 2,
      text: 'No Radius',
      color: Colors.black,
    ));

    elements.add(TextElement(
      x: -1.5,
      y: 2,
      text: 'Radius: 0.2',
      color: Colors.black,
    ));

    elements.add(TextElement(
      x: 3,
      y: 2,
      text: 'Radius: 0.5',
      color: Colors.black,
    ));

    // Add grid lines for reference
    for (double x = -8; x <= 8; x += 1) {
      elements.add(LineElement(
        x1: x,
        y1: -5,
        x2: x,
        y2: 5,
        color: Colors.grey.withOpacity(0.1),
        strokeWidth: 1,
      ));
    }
    for (double y = -5; y <= 5; y += 1) {
      elements.add(LineElement(
        x1: -8,
        y1: y,
        x2: 8,
        y2: y,
        color: Colors.grey.withOpacity(0.1),
        strokeWidth: 1,
      ));
    }

    return elements;
  }

  @override
  double get elementHeight => 10.0;  // Reduced to match coordinate range
}
