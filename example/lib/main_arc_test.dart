import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/layers/layers.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/custom_paint_renderer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/image_loader.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/elements.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/polygon_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/bezier_curve_element.dart';
import 'dart:ui' as ui;

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
          title: const Text('Diagram Layer Elements Showcase'),
        ),
        body: const Center(
          child: DiagramWidget(),
        ),
      ),
    );
  }
}

class DiagramWidget extends StatefulWidget {
  const DiagramWidget({super.key});

  @override
  State<DiagramWidget> createState() => _DiagramWidgetState();
}

class _DiagramWidgetState extends State<DiagramWidget> {
  late IDiagramLayer _layer;
  bool _showAxes = true;
  bool _showGrid = true;

  @override
  void initState() {
    super.initState();
    _initializeLayer();
  }

  void _initializeLayer() {
    // Create diagram layer with proper coordinate system
    _layer = BasicDiagramLayer(
      coordinateSystem: CoordinateSystem(
        origin: const Offset(400, 300), // Center of the 800x600 canvas
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: -7.5,
        yRangeMax: 7.5,
        scale: 30,
      ),
      showAxes: _showAxes,
      showDebugInfo: true,  // Enable debug mode
    );

    if (_showAxes) {
      _layer = _layer
        .addElement(XAxisElement(yValue: 0, id: 'A0-x'))
        .addElement(YAxisElement(xValue: 0, id: 'A1-y'));
    }

    // Add coordinate grid
    if (_showGrid) {
      _layer = _layer.addElement(
        GridElement(
          x: 0,
          y: 0,
          majorSpacing: 1.0,
          minorSpacing: 0.2,
          id: 'G1-grid',
          color: Colors.black,
        ),
      );
    }

    // Add test line
    _layer = _layer.addElement(
      LineElement(
        x1: 0,
        y1: 3,
        x2: 0,
        y2: 6,
        color: Colors.red,
        strokeWidth: 2,
        id: 'L1-test',
      ),
    ).addElement(
      LineElement(
        x1: -2,
        y1: -3,
        x2: -2,
        y2: 4,
        color: Colors.blue,
        strokeWidth: 2,
        id: 'L2-test',
      ),
    ).addElement(
      LineElement(
        x1: 4,
        y1: -3,
        x2: 8,
        y2: -3,
        color: Colors.green,
        strokeWidth: 2,
        id: 'L3-test',
      ),
    ).addElement(
      ArcElement(
        x: 0,
        y: 0,
        radius: 7,
        startAngle: 0,             // Start at positive X axis
        endAngle: math.pi,         // End at negative X axis (upper semicircle)
        color: Colors.black,
        strokeWidth: 2,
        id: 'A1-test',
      ),
    ).addElement(
      CircleElement(
        x: 3,
        y: 3,
        radius: 2,
        color: Colors.black,
        strokeWidth: 2,
        id: 'C1-test',
      ),
    ).addElement(
      // Upper right quadrant (0 to π/2) - Red
      ArcElement(
        x: 0,
        y: 0,
        radius: 7,
        startAngle: 0,
        endAngle: math.pi/2,
        color: Colors.red,
        strokeWidth: 2,
        id: 'arc-ur',
      ),
    ).addElement(
      // Upper left quadrant (π/2 to π) - Blue
      ArcElement(
        x: 0,
        y: 0,
        radius: 7,
        startAngle: math.pi/2,
        endAngle: math.pi,
        color: Colors.blue,
        strokeWidth: 2,
        id: 'arc-ul',
      ),
    ).addElement(
      // Lower left quadrant (π to 3π/2) - Green
      ArcElement(
        x: 0,
        y: 0,
        radius: 7,
        startAngle: math.pi,
        endAngle: 3*math.pi/2,
        color: Colors.green,
        strokeWidth: 2,
        id: 'arc-ll',
      ),
    ).addElement(
      // Lower right quadrant (3π/2 to 2π) - Orange
      ArcElement(
        x: 0,
        y: 0,
        radius: 7,
        startAngle: 3*math.pi/2,
        endAngle: 2*math.pi,
        color: Colors.orange,
        strokeWidth: 2,
        id: 'arc-lr',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(800, 600),
      painter: CustomPaintRenderer(_layer),
    );
  }
}

class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);
}
