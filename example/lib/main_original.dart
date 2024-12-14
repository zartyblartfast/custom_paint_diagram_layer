// Original main.dart saved for reference
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
import 'spring_balance/spring_balance_main.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pre-load the image
  try {
    final data = await rootBundle.load('assets/observer.png');
    debugPrint('Successfully pre-loaded observer.png: ${data.lengthInBytes} bytes');
  } catch (e) {
    debugPrint('Failed to pre-load observer.png: $e');
  }
  
  runApp(const DiagramApp());
}

class DiagramApp extends StatelessWidget {
  const DiagramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Paint Diagram Layer Examples'),
        ),
        body: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: DiagramWidget(),
              ),
              Expanded(
                child: SpringBalanceDiagram(),
              ),
            ],
          ),
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
  late DiagramLayer _layer;
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
        origin: const Offset(200, 400),
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: 0,
        yRangeMax: 20,
        scale: 15,
      ),
      showAxes: _showAxes,
    );

    if (_showAxes) {
      // Add axes
      _layer = _layer
        .addElement(const XAxisElement(yValue: 0))
        .addElement(const YAxisElement(xValue: 0));
    }

    // Add grid for better visibility
    _layer = _layer
      .addElement(
        CoordinateGridElement(
          type: CoordinateType.polar,  // Try polar coordinates
          majorSpacing: 2.0,
          minorSpacing: 0.5,
          majorColor: Colors.grey.shade400,
          minorColor: Colors.grey.shade200,
          opacity: 0.3,
          showLabels: true,
          labelFontSize: 10.0,
        ),
      )
      .addElement(
        CircleElement(
          x: 5,
          y: 10,
          radius: 1,
          strokeWidth: 2,
          color: Colors.blue,
        ),
      )
      .addElement(
        LineElement(
          x1: -5,
          y1: 10,
          x2: 5,
          y2: 10,
          strokeWidth: 2,
          color: Colors.red,
        ),
      )
      .addElement(
        DottedLineElement(
          x: -5,
          y: 5,
          endX: 5,
          endY: 5,
          color: Colors.green,
          strokeWidth: 3,
          pattern: DashPattern.dashed,
          spacing: 1.0,
        ),
      )
      .addElement(
        ArrowElement(
          x1: 0,
          y1: 15,
          x2: 0,
          y2: 10,
          headLength: 1.0,
          strokeWidth: 2,
          color: Colors.purple,
        ),
      )
      .addElement(
        GroupElement(
          x: 5,  // Center of rotation/scaling
          y: 2,
          elements: [
            CircleElement(
              x: 3,
              y: 2,
              radius: 1.0,  // Larger radius
              strokeWidth: 2,
              fillColor: Colors.orange,  // Fill the circle
              fillOpacity: 0.8,
              color: Colors.orange,
            ),
            LineElement(
              x1: 3,
              y1: 2,
              x2: 7,
              y2: 2,
              strokeWidth: 3,  // Thicker line
              color: Colors.orange,
            ),
            CircleElement(
              x: 7,
              y: 2,
              radius: 1.0,  // Larger radius
              strokeWidth: 2,
              fillColor: Colors.orange,  // Fill the circle
              fillOpacity: 0.8,
              color: Colors.orange,
            ),
          ],
          scale: 1.0,
          rotation: math.pi / 6,  // 30 degrees rotation
          color: Colors.orange,
        ),
      );

    // Add another test group with mixed elements
    _layer = _layer.addElement(
      GroupElement(
        x: 8,  // Center point for the group
        y: 5,
        elements: [
          ArrowElement(
            x1: 8,
            y1: 5,
            x2: 10,
            y2: 7,
            strokeWidth: 2,
            color: Colors.blue,
            headLength: 0.5,
            headAngle: math.pi / 6,
          ),
          TextElement(
            x: 8.2,
            y: 6,
            text: "Force",
            color: Colors.blue,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
          DottedLineElement(
            x: 8,
            y: 5,
            endX: 6,
            endY: 7,
            strokeWidth: 2,
            pattern: DashPattern.custom,
            customPattern: [0.3, 0.2],
            color: Colors.blue,
          ),
        ],
        scale: 1.2,  // Slightly larger
        rotation: -math.pi / 4,  // -45 degrees rotation
        color: Colors.blue,
      ),
    );

    // Add an arced arrow
    _layer = _layer.addElement(
      ArcedArrowElement(
        x: 2,
        y: 2,
        endX: 4,
        endY: 4,
        radius: 3,  // Positive radius for counter-clockwise arc
        strokeWidth: 2,
        color: Colors.purple,
        headLength: 0.5,
        headAngle: math.pi / 6,
      ),
    );

    // Add a Bezier curve
    _layer = _layer.addElement(
      BezierCurveElement(
        x: 1,
        y: 8,
        endPoint: const Point(3, 8),
        controlPoint1: const Point(1.5, 9),
        controlPoint2: const Point(2.5, 7),
        type: BezierType.cubic,
        strokeWidth: 2,
        color: Colors.red,
        showControlPoints: true,  // Show control points for demonstration
      ),
    );

    // Add a ruler for measurements
    _layer = _layer.addElement(
      RulerElement(
        x: 6,
        y: 4,
        length: 5.0,
        orientation: RulerOrientation.vertical,
        majorTickSpacing: 1.0,
        minorTickSpacing: 0.2,
        majorTickLength: 0.3,
        minorTickLength: 0.15,
        strokeWidth: 1,
        color: Colors.grey,
        showLabels: true,
        labelSize: 12,
      ),
    );

    // Add examples of various shapes
    _layer = _layer.addElement(
      RectangleElement(
        x: 1,
        y: 1,
        width: 2,
        height: 1,
        strokeWidth: 2,
        color: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.2),
        fillOpacity: 0.5,
      ),
    ).addElement(
      IsoscelesTriangleElement(
        x: 3,
        y: 1,
        base: 2,
        height: 1,
        strokeWidth: 2,
        color: Colors.green,
        fillColor: Colors.green.withOpacity(0.2),
        fillOpacity: 0.5,
      ),
    ).addElement(
      PolygonElement(
        x: 1,
        y: 7,
        points: [
          const Point2D(0, 0),     // Relative to (1,7)
          const Point2D(1, 0),     // Relative to (1,7)
          const Point2D(1.5, 1),   // Relative to (1,7)
          const Point2D(1, 2),     // Relative to (1,7)
          const Point2D(0, 2),     // Relative to (1,7)
          const Point2D(-0.5, 1),  // Relative to (1,7)
        ],
        strokeWidth: 2,
        color: Colors.indigo,
        fillColor: Colors.indigo.withOpacity(0.2),
        fillOpacity: 0.5,
      ),
    );

    // Add angle markers
    _layer = _layer.addElement(
      AngleElement(
        x: 8,
        y: 7,
        vertex: const Point(0, 0),
        point1: const Point(1, 0),    // 0 degrees
        point2: const Point(0.7, 0.7), // 45 degrees
        radius: 0.5,
        markerStyle: AngleMarkerStyle.single,
        showMeasure: true,
        strokeWidth: 2,
        color: Colors.orange,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.orange,
        ),
      ),
    ).addElement(
      AngleElement(
        x: 8,
        y: 9,
        vertex: const Point(0, 0),
        point1: const Point(1, 0),     // 0 degrees
        point2: const Point(0, 1),     // 90 degrees
        radius: 0.5,
        markerStyle: AngleMarkerStyle.double, // Double arc for right angle
        showMeasure: true,
        strokeWidth: 2,
        color: Colors.green,
        arcSpacing: 0.1,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.green,
        ),
      ),
    ).addElement(
      AngleElement(
        x: 8,
        y: 11,
        vertex: const Point(0, 0),
        point1: const Point(0.866, 0.5),  // 30 degrees
        point2: const Point(0.866, -0.5), // -30 degrees
        radius: 0.5,
        markerStyle: AngleMarkerStyle.triple, // Triple arc for equal angles
        showMeasure: true,
        strokeWidth: 2,
        color: Colors.purple,
        arcSpacing: 0.1,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.purple,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 400,
          height: 400,
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
              _showAxes = !_showAxes;  // Toggle axes visibility
              _initializeLayer();      // Reinitialize layer with new state
            });
          },
          child: Text(_showAxes ? 'Hide Axes' : 'Show Axes'),
        ),
      ],
    );
  }
}
