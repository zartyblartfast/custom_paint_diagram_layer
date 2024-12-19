import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

/// An artistic butterfly composition using geometric shapes and curves
class ButterflyArt extends StatefulWidget {
  const ButterflyArt({super.key});

  @override
  State<ButterflyArt> createState() => _ButterflyArtState();
}

class _ButterflyArtState extends State<ButterflyArt> {
  late IDiagramLayer diagramLayer;
  double _sliderValue = 0.0;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    diagramLayer = _createDiagramLayer();
  }

  IDiagramLayer _createDiagramLayer() {
    return BasicDiagramLayer(
      coordinateSystem: CoordinateSystem(
        origin: Offset.zero,
        xRangeMin: -12,
        xRangeMax: 12,
        yRangeMin: -12,
        yRangeMax: 12,
        scale: _scale,
      ),
      elements: _createElements(_sliderValue),
    );
  }

  // Colors for our butterfly
  static const wingColor = Color(0xFF9C27B0); // Purple
  static const bodyColor = Color(0xFF4CAF50); // Green
  static const antennaeColor = Color(0xFFFFC107); // Amber

  List<DrawableElement> _createElements(double sliderValue) {
    // Use slider value to create wing flutter effect (0-1)
    final flutter = math.sin(sliderValue * math.pi * 2) * 0.3;
    
    // Create butterfly parts
    final elements = <DrawableElement>[
      // Left Wing (upper)
      BezierCurveElement(
        x: 0,
        y: 0,
        endPoint: Point(-4, 2 + flutter),
        controlPoint1: Point(-2, 3),
        type: BezierType.quadratic,
        color: wingColor,
        strokeWidth: 2,
      ),
      // Left Wing (lower)
      BezierCurveElement(
        x: 0,
        y: 0,
        endPoint: Point(-3, -2 - flutter),
        controlPoint1: Point(-2, -2),
        type: BezierType.quadratic,
        color: wingColor,
        strokeWidth: 2,
      ),
      // Right Wing (upper)
      BezierCurveElement(
        x: 0,
        y: 0,
        endPoint: Point(4, 2 + flutter),
        controlPoint1: Point(2, 3),
        type: BezierType.quadratic,
        color: wingColor,
        strokeWidth: 2,
      ),
      // Right Wing (lower)
      BezierCurveElement(
        x: 0,
        y: 0,
        endPoint: Point(3, -2 - flutter),
        controlPoint1: Point(2, -2),
        type: BezierType.quadratic,
        color: wingColor,
        strokeWidth: 2,
      ),
      
      // Body segments (3 circles)
      CircleElement(
        x: 0,
        y: 0,
        radius: 0.5,
        color: bodyColor,
        fillColor: bodyColor,
        fillOpacity: 0.7,
      ),
      CircleElement(
        x: 0,
        y: -0.8,
        radius: 0.4,
        color: bodyColor,
        fillColor: bodyColor,
        fillOpacity: 0.7,
      ),
      CircleElement(
        x: 0,
        y: 0.8,
        radius: 0.4,
        color: bodyColor,
        fillColor: bodyColor,
        fillOpacity: 0.7,
      ),

      // Left Antenna (using bezier curve instead of spiral)
      BezierCurveElement(
        x: 0,
        y: 1,
        endPoint: Point(-1.5, 2.5),
        controlPoint1: Point(-0.5, 2),
        type: BezierType.quadratic,
        color: antennaeColor,
        strokeWidth: 1,
      ),
      // Right Antenna
      BezierCurveElement(
        x: 0,
        y: 1,
        endPoint: Point(1.5, 2.5),
        controlPoint1: Point(0.5, 2),
        type: BezierType.quadratic,
        color: antennaeColor,
        strokeWidth: 1,
      ),

      // Wing decorations - small circles
      ...List.generate(6, (i) {
        final angle = i * math.pi / 3;
        final radius = 2.0;
        return CircleElement(
          x: radius * math.cos(angle),
          y: radius * math.sin(angle),
          radius: 0.2,
          color: Colors.white,
          fillColor: Colors.white,
          fillOpacity: 0.8,
        );
      }),
    ];

    return elements;
  }

  void _updateSliderPosition(double value) {
    setState(() {
      _sliderValue = value;
      diagramLayer = _createDiagramLayer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geometric Butterfly'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomPaint(
              painter: CustomPaintRenderer(diagramLayer),
              size: Size.infinite,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Flutter Wings'),
                Expanded(
                  child: Slider(
                    value: _sliderValue,
                    onChanged: _updateSliderPosition,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: ButterflyArt()));
}
