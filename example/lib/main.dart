import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/line_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/rectangle_element.dart';

void main() {
  runApp(const DiagramApp());
}

class DiagramApp extends StatelessWidget {
  const DiagramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Paint Diagram Layer Example'),
        ),
        body: const Center(
          child: DiagramWidget(),
        ),
      ),
    );
  }
}

class DiagramWidget extends StatelessWidget {
  const DiagramWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: CustomPaint(
        painter: CustomPaintRenderer(
          Diagram(
            coordinateSystem: CoordinateSystem(
              origin: const Offset(200, 200), // Center of canvas
              xRangeMin: -10,
              xRangeMax: 10,
              yRangeMin: -10,
              yRangeMax: 10,
              scale: 15,
            ),
            elements: [
              // Draw a line from (-5, -5) to (5, 5)
              LineElement(
                x1: -5,
                y1: -5,
                x2: 5,
                y2: 5,
                color: Colors.blue,
              ),
              // Draw another line from (-5, 5) to (5, -5)
              LineElement(
                x1: -5,
                y1: 5,
                x2: 5,
                y2: -5,
                color: Colors.red,
              ),
              // Draw a rectangle centered at (0, 0)
              RectangleElement(
                x: -3,  // Left edge
                y: 3,   // Top edge
                width: 6,
                height: 6,
                color: Colors.green,
              ),
            ],
            showAxes: true,
          ),
        ),
      ),
    );
  }
}
