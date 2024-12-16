import 'package:flutter/material.dart';
import 'custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: DiagramTest(),
        ),
      ),
    );
  }
}

class DiagramTest extends StatelessWidget {
  const DiagramTest({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building diagram test'); // Debug print

    // Create a diagram layer with a coordinate system
    final diagram = BasicDiagramLayer(
      coordinateSystem: CoordinateSystem(
        origin: const Offset(300, 300),
        scale: 40.0,
        xRangeMin: -5,
        xRangeMax: 5,
        yRangeMin: -5,
        yRangeMax: 5,
      ),
    )
    // Add a grid for reference
    .addElement(
      GridElement(
        x: -5,
        y: -5,
        majorSpacing: 1,
        minorSpacing: 0.2,
        majorColor: Colors.grey.withOpacity(0.5),
        minorColor: Colors.grey.withOpacity(0.2),
        majorStrokeWidth: 1,
        minorStrokeWidth: 0.5,
      ),
    )
    // Simple solid line for testing
    .addElement(
      LineElement(
        x1: -3,
        y1: 0,
        x2: 3,
        y2: 0,
        color: Colors.blue,
        strokeWidth: 4,
      ),
    )
    // Circle for reference point
    .addElement(
      CircleElement(
        x: 0,
        y: 0,
        radius: 0.2,
        color: Colors.red,
        fillColor: Colors.red,
      ),
    );

    print('Created diagram with elements'); // Debug print

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black), // Add border to see container bounds
      ),
      width: 600,
      height: 600,
      child: diagram,
    );
  }
} 