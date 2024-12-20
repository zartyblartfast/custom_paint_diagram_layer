import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import '../utils/static_diagram_base.dart';

/// Visualizes how GroupElement transforms coordinate systems
void main() {
  runApp(const MaterialApp(home: CoordinateSystemVisualization()));
}

class CoordinateSystemVisualization extends StatelessWidget {
  const CoordinateSystemVisualization({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coordinate System Transformation'),
      ),
      body: CustomPaint(
        painter: CustomPaintRenderer(
          BasicDiagramLayer(
            coordinateSystem: CoordinateSystem(
              origin: const Offset(400, 300),
              scale: 100.0,  // Make everything bigger for visibility
              xRangeMin: -6,
              xRangeMax: 6,
              yRangeMin: -4,
              yRangeMax: 4,
            ),
            elements: [
              // Main coordinate system axes
              LineElement(
                x1: -6, x2: 6, y1: 0, y2: 0,
                color: Colors.black,
                strokeWidth: 1,
              ),
              LineElement(
                x1: 0, x2: 0, y1: -4, y2: 4,
                color: Colors.black,
                strokeWidth: 1,
              ),
              TextElement(
                x: 0.2, y: 0.2,
                text: 'Main Origin (0,0)',
                color: Colors.black,
              ),

              // R1 Group at (-2, -1)
              GroupElement(
                x: -2,
                y: -1,
                children: [
                  // Group's coordinate system
                  LineElement(
                    x1: -2, x2: 2, y1: 0, y2: 0,
                    color: Colors.blue.withOpacity(0.5),
                    strokeWidth: 2,
                  ),
                  LineElement(
                    x1: 0, x2: 0, y1: -2, y2: 2,
                    color: Colors.blue.withOpacity(0.5),
                    strokeWidth: 2,
                  ),
                  TextElement(
                    x: 0.2, y: 0.2,
                    text: 'R1 Origin (-2,-1)',
                    color: Colors.blue,
                  ),
                  // Rectangle relative to group origin
                  RectangleElement(
                    x: -1,
                    y: -0.5,
                    width: 2,
                    height: 1,
                    color: Colors.blue,
                    fillColor: Colors.blue.withOpacity(0.2),
                  ),
                  // Show rectangle's center
                  CircleElement(
                    x: -1,
                    y: -0.5,
                    radius: 0.05,
                    color: Colors.blue,
                    fillColor: Colors.blue,
                  ),
                  TextElement(
                    x: -1,
                    y: -0.7,
                    text: 'Rect Center\n(-1,-0.5) relative\n= (-3,-1.5) absolute',
                    color: Colors.blue,
                  ),
                ],
              ),

              // R2 Group at (2, -1)
              GroupElement(
                x: 2,
                y: -1,
                children: [
                  // Group's coordinate system
                  LineElement(
                    x1: -2, x2: 2, y1: 0, y2: 0,
                    color: Colors.red.withOpacity(0.5),
                    strokeWidth: 2,
                  ),
                  LineElement(
                    x1: 0, x2: 0, y1: -2, y2: 2,
                    color: Colors.red.withOpacity(0.5),
                    strokeWidth: 2,
                  ),
                  TextElement(
                    x: 0.2, y: 0.2,
                    text: 'R2 Origin (2,-1)',
                    color: Colors.red,
                  ),
                  // Rectangle relative to group origin
                  RectangleElement(
                    x: -1,
                    y: -0.5,
                    width: 2,
                    height: 1,
                    color: Colors.red,
                    fillColor: Colors.red.withOpacity(0.2),
                  ),
                  // Show rectangle's center
                  CircleElement(
                    x: -1,
                    y: -0.5,
                    radius: 0.05,
                    color: Colors.red,
                    fillColor: Colors.red,
                  ),
                  TextElement(
                    x: -1,
                    y: -0.7,
                    text: 'Rect Center\n(-1,-0.5) relative\n= (1,-1.5) absolute',
                    color: Colors.red,
                  ),
                ],
              ),

              // Show connector socket points
              CircleElement(
                x: -1, y: -2,
                radius: 0.1,
                color: Colors.green,
                fillColor: Colors.green,
              ),
              TextElement(
                x: -1, y: -2.3,
                text: 'R1 Right Socket\n(-1,-2)',
                color: Colors.green,
              ),
              CircleElement(
                x: 1, y: -2,
                radius: 0.1,
                color: Colors.green,
                fillColor: Colors.green,
              ),
              TextElement(
                x: 1, y: -2.3,
                text: 'R2 Left Socket\n(1,-2)',
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
