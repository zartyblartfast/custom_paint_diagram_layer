import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/layers/layers.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/custom_paint_renderer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/image_loader.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/elements.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/polygon_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/bezier_curve_element.dart';
import 'dart:math' as math;
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
        yRangeMin: -7.5, // Adjusted for 4:3 aspect ratio
        yRangeMax: 7.5,  // Adjusted for 4:3 aspect ratio
        scale: 30, // Larger scale for better visibility
      ),
      showAxes: _showAxes,
    );

    if (_showAxes) {
      _layer = _layer
        .addElement(const XAxisElement(yValue: 0))
        .addElement(const YAxisElement(xValue: 0));
    }

    // Add coordinate grid
    _layer = _layer.addElement(
      CoordinateGridElement(
        type: CoordinateType.cartesian,
        majorSpacing: 2.0,
        minorSpacing: 0.5,
        majorColor: Colors.grey.shade300,
        minorColor: Colors.grey.shade200,
        opacity: 0.3,
        showLabels: true,
        labelFontSize: 10.0,
      ),
    );

    // TODO: Add demonstrations of all elements
    // We'll implement this next
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 800,
          height: 600, // Reduced height for better fit
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: CustomPaint(
            painter: CustomPaintRenderer(_layer),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showAxes = !_showAxes;
              _initializeLayer();
            });
          },
          child: Text(_showAxes ? 'Hide Axes' : 'Show Axes'),
        ),
      ],
    );
  }
}
