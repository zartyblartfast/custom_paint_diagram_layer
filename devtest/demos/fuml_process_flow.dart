import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import '../utils/static_diagram_base.dart';

class FUMLProcessFlow extends StaticDiagramBase {
  const FUMLProcessFlow({super.key}) : super(
    title: 'Calculate Average Process Flow',
    coordRange: 10.0,
  );

  @override
  StaticDiagramBaseState<FUMLProcessFlow> createState() => _FUMLProcessFlowState();
}

class _FUMLProcessFlowState extends StaticDiagramBaseState<FUMLProcessFlow> {
  @override
  List<DrawableElement> createElements() {
    final elements = <DrawableElement>[];
    
    // Colors
    final actionColor = Colors.lightBlue[100]!;
    final decisionColor = Colors.amber[100]!;
    final strokeColor = Colors.black87;
    
    // Initial Node (filled circle)
    elements.add(CircleElement(
      x: 0,
      y: 8,
      radius: 0.2,
      color: strokeColor,
      fillColor: strokeColor,
    ));

    // Initialize Variables Action
    elements.add(RectangleElement(
      x: -2,
      y: 5.5,
      width: 4,
      height: 1,
      color: strokeColor,
      fillColor: actionColor,
      borderRadius: 0.2,
    ));
    elements.add(TextElement(
      x: 0,
      y: 5.5,
      text: 'Initialize Variables',
      color: Colors.black,
    ));

    // While Loop Decision
    elements.add(RectangleElement(
      x: -1.5,
      y: 3.5,
      width: 3,
      height: 1,
      color: strokeColor,
      fillColor: decisionColor,
      borderRadius: 0.1,
    ));
    elements.add(TextElement(
      x: 0,
      y: 3.5,
      text: 'i <= count?',
      color: Colors.black,
    ));

    // Sum Accumulation Action
    elements.add(RectangleElement(
      x: -2,
      y: 1.5,
      width: 4,
      height: 1,
      color: strokeColor,
      fillColor: actionColor,
      borderRadius: 0.2,
    ));
    elements.add(TextElement(
      x: 0,
      y: 1.5,
      text: 'sum += numbers[i]',
      color: Colors.black,
    ));

    // Increment Counter Action
    elements.add(RectangleElement(
      x: -2,
      y: -0.5,
      width: 4,
      height: 1,
      color: strokeColor,
      fillColor: actionColor,
      borderRadius: 0.2,
    ));
    elements.add(TextElement(
      x: 0,
      y: -0.5,
      text: 'i += 1',
      color: Colors.black,
    ));

    // Count Check Decision
    elements.add(RectangleElement(
      x: -1.5,
      y: -2.5,
      width: 3,
      height: 1,
      color: strokeColor,
      fillColor: decisionColor,
      borderRadius: 0.1,
    ));
    elements.add(TextElement(
      x: 0,
      y: -2.5,
      text: 'count > 0?',
      color: Colors.black,
    ));

    // Calculate Average Action
    elements.add(RectangleElement(
      x: -2,
      y: -4.5,
      width: 4,
      height: 1,
      color: strokeColor,
      fillColor: actionColor,
      borderRadius: 0.2,
    ));
    elements.add(TextElement(
      x: 0,
      y: -4.5,
      text: 'sum / count',
      color: Colors.black,
    ));

    // Return 0.0 Action
    elements.add(RectangleElement(
      x: 3,
      y: -4.5,
      width: 4,
      height: 1,
      color: strokeColor,
      fillColor: actionColor,
      borderRadius: 0.2,
    ));
    elements.add(TextElement(
      x: 5,
      y: -4.5,
      text: 'return 0.0',
      color: Colors.black,
    ));

    // Final Node (double circle)
    elements.add(CircleElement(
      x: 0,
      y: -6,
      radius: 0.3,
      color: strokeColor,
      strokeWidth: 2,
    ));
    elements.add(CircleElement(
      x: 0,
      y: -6,
      radius: 0.2,
      color: strokeColor,
      strokeWidth: 1,
    ));

    // Control Flow Arrows
    _addArrow(elements, 0, 7.8, 0, 6.5);  // Initial to Initialize (top)
    _addArrow(elements, 0, 5.5, 0, 4.5);  // Initialize to While (bottom to top)
    _addArrow(elements, 0, 3.5, 0, 2.5);  // While to Sum (bottom to top)
    _addArrow(elements, 0, 1.5, 0, 0.5);  // Sum to Increment (bottom to top)
    _addArrow(elements, 0, -0.5, 0, -2.0); // Increment to Count Check (bottom to top)
    _addArrow(elements, 0, -3.0, 0, -4.0); // Count Check to Average (bottom to top)
    _addArrow(elements, 1.5, -2.5, 3, -4.0); // Count Check to Return 0 (side to top)
    _addArrow(elements, 0, -5.0, 0, -5.7); // Average to Final (bottom)
    _addArrow(elements, 5, -5.0, 0, -5.7); // Return 0 to Final (bottom)

    // Loop back arrow (using multiple segments)
    _addArrow(elements, 0, -0.5, 2, -0.5);  // Horizontal from Increment
    elements.add(LineElement(
      x1: 2,
      y1: -0.5,
      x2: 2,
      y2: 4.0,  // To While loop level
      color: strokeColor,
      strokeWidth: 1,
    ));
    _addArrow(elements, 2, 4.0, 1.5, 4.0);  // Back to While

    // Add "Yes"/"No" labels
    elements.add(TextElement(
      x: -0.5,
      y: 2.7,
      text: 'Yes',
      color: Colors.black,
    ));
    elements.add(TextElement(
      x: 2,
      y: -2.0,
      text: 'No',
      color: Colors.black,
    ));
    elements.add(TextElement(
      x: -0.5,
      y: -3.5,
      text: 'Yes',
      color: Colors.black,
    ));

    return elements;
  }

  void _addArrow(List<DrawableElement> elements, double x1, double y1, double x2, double y2) {
    elements.add(ArrowElement(
      x1: x1,
      y1: y1,
      x2: x2,
      y2: y2,
      color: Colors.black87,
      strokeWidth: 1,
      headLength: 0.2,  // Smaller head for better proportions
      style: ArrowStyle.filled,
    ));
  }

  @override
  double get elementHeight => 1.0;  // -8 to 8 vertical range
}
