import 'dart:math';
import 'package:flutter/material.dart';
import 'custom_paint_diagram_layer/basic_diagram_layer.dart';
import 'custom_paint_diagram_layer/elements/polygon_element.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: DiagramGallery(),
        ),
      ),
    );
  }
}

class DiagramGallery extends StatelessWidget {
  const DiagramGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Polygon Element Examples',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildDiagram('Triangle', _createTriangle()),
          const SizedBox(height: 20),
          _buildDiagram('Pentagon', _createPentagon()),
          const SizedBox(height: 20),
          _buildDiagram('Hexagon', _createHexagon()),
          const SizedBox(height: 20),
          _buildDiagram('Star Shape', _createStarShape()),
          const SizedBox(height: 20),
          _buildDiagram('Custom Open Shape', _createOpenShape()),
        ],
      ),
    );
  }

  Widget _buildDiagram(String title, BasicDiagramLayer layer) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 300,
          height: 300,
          child: layer,
        ),
      ],
    );
  }

  BasicDiagramLayer _createTriangle() {
    return BasicDiagramLayer(
      showGrid: true,
      showAxes: true,
    ).addElement(
      PolygonElement(
        points: const [
          Point2D(0, 0),
          Point2D(2, 0),
          Point2D(1, 2),
        ],
        x: 0,
        y: 0,
        color: Colors.blue,
        strokeWidth: 2,
        fillColor: Colors.blue,
        fillOpacity: 0.3,
      ),
    );
  }

  BasicDiagramLayer _createPentagon() {
    const radius = 1.5;
    const centerX = 1.5;
    const centerY = 1.5;
    const sides = 5;
    
    // Calculate pentagon points
    final points = List<Point2D>.generate(sides, (i) {
      final angle = (2 * 3.14159 * i) / sides - 3.14159 / 2;
      return Point2D(
        centerX + radius * cos(angle),
        centerY + radius * sin(angle),
      );
    });

    return BasicDiagramLayer(
      showGrid: true,
      showAxes: true,
    ).addElement(
      PolygonElement(
        points: points,
        x: 0,
        y: 0,
        color: Colors.green,
        strokeWidth: 2,
        fillColor: Colors.green,
        fillOpacity: 0.3,
      ),
    );
  }

  BasicDiagramLayer _createHexagon() {
    const radius = 1.5;
    const centerX = 1.5;
    const centerY = 1.5;
    const sides = 6;
    
    // Calculate hexagon points
    final points = List<Point2D>.generate(sides, (i) {
      final angle = (2 * 3.14159 * i) / sides;
      return Point2D(
        centerX + radius * cos(angle),
        centerY + radius * sin(angle),
      );
    });

    return BasicDiagramLayer(
      showGrid: true,
      showAxes: true,
    ).addElement(
      PolygonElement(
        points: points,
        x: 0,
        y: 0,
        color: Colors.purple,
        strokeWidth: 2,
        fillColor: Colors.purple,
        fillOpacity: 0.3,
      ),
    );
  }

  BasicDiagramLayer _createStarShape() {
    const outerRadius = 1.5;
    const innerRadius = 0.6;
    const centerX = 1.5;
    const centerY = 1.5;
    const points = 5;
    
    // Calculate star points
    final starPoints = <Point2D>[];
    for (var i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (3.14159 * i) / points - 3.14159 / 2;
      starPoints.add(Point2D(
        centerX + radius * cos(angle),
        centerY + radius * sin(angle),
      ));
    }

    return BasicDiagramLayer(
      showGrid: true,
      showAxes: true,
    ).addElement(
      PolygonElement(
        points: starPoints,
        x: 0,
        y: 0,
        color: Colors.orange,
        strokeWidth: 2,
        fillColor: Colors.orange,
        fillOpacity: 0.3,
      ),
    );
  }

  BasicDiagramLayer _createOpenShape() {
    return BasicDiagramLayer(
      showGrid: true,
      showAxes: true,
    ).addElement(
      PolygonElement(
        points: const [
          Point2D(0, 0),
          Point2D(1, 1),
          Point2D(2, 0),
          Point2D(3, 1),
          Point2D(2, 2),
          Point2D(1, 1.5),
        ],
        x: 0,
        y: 0,
        closed: false,
        color: Colors.red,
        strokeWidth: 2,
      ),
    );
  }
} 