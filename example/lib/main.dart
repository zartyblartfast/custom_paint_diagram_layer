import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/layers/layers.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/custom_paint_renderer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/elements.dart';

void main() {
  runApp(const DiagramApp());
}

class DiagramApp extends StatelessWidget {
  const DiagramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const ElementTestPage(),
    );
  }
}

class ElementTestPage extends StatefulWidget {
  const ElementTestPage({super.key});

  @override
  State<ElementTestPage> createState() => _ElementTestPageState();
}

class _ElementTestPageState extends State<ElementTestPage> {
  late IDiagramLayer _layer;
  bool _showAxes = true;
  bool _showGrid = true;
  bool _showDebugInfo = true;
  int _currentTestSet = 0;
  double _scale = 100;
  Offset _origin = const Offset(400, 300);

  final List<String> _testSets = [
    'Basic Shapes',
    'Lines & Curves',
    'Arrows & Angles',
    'Polygons',
    'Text & Labels',
    'Composite',
    'Coordinate Tests'
  ];

  @override
  void initState() {
    super.initState();
    _initializeLayer();
  }

  void _initializeLayer() {
    _layer = BasicDiagramLayer(
      coordinateSystem: CoordinateSystem(
        origin: _origin,
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: -7.5,
        yRangeMax: 7.5,
        scale: _scale,
      ),
      showAxes: _showAxes,
      showDebugInfo: _showDebugInfo,
    );

    if (_showGrid) {
      _layer = _layer.addElement(
        const GridElement(
          x: 0,
          y: 0,
          majorSpacing: 1.0,
          minorSpacing: 0.2,
          majorColor: Colors.grey,
          minorColor: Colors.grey,
          majorStrokeWidth: 1.0,
          minorStrokeWidth: 0.5,
          opacity: 0.3,
          color: Colors.grey,
          id: 'grid-main',
        ),
      );
    }

    _addTestElements();
  }

  void _addTestElements() {
    switch (_currentTestSet) {
      case 0:
        _addBasicShapes();
        break;
      case 1:
        _addLinesAndCurves();
        break;
      case 2:
        _addArrowsAndAngles();
        break;
      case 3:
        _addPolygons();
        break;
      case 4:
        _addTextAndLabels();
        break;
      case 5:
        _addCompositeElements();
        break;
      case 6:
        _addCoordinateTests();
        break;
    }
  }

  void _addBasicShapes() {
    // Test circles
    for (int i = 0; i < 4; i++) {
      _layer = _layer.addElement(
        const CircleElement(
          x: -6,
          y: 4,
          radius: 1,
          color: Colors.blue,
          fillColor: Colors.blue,
          fillOpacity: 0.3,
          strokeWidth: 2,
          id: 'circle-1',
        ),
      );
    }

    // Test rectangles
    for (int i = 0; i < 4; i++) {
      _layer = _layer.addElement(
        const RectangleElement(
          x: -6,
          y: 1,
          width: 2,
          height: 1.5,
          color: Colors.red,
          fillColor: Colors.red,
          fillOpacity: 0.3,
          strokeWidth: 2,
          id: 'rect-1',
        ),
      );
    }

    // Test ellipses
    for (int i = 0; i < 4; i++) {
      _layer = _layer.addElement(
        const EllipseElement(
          x: -6,
          y: -2,
          width: 2,
          height: 1,
          color: Colors.green,
          fillColor: Colors.green,
          fillOpacity: 0.3,
          strokeWidth: 2,
          id: 'ellipse-1',
        ),
      );
    }

    // Test arcs
    for (int i = 0; i < 4; i++) {
      _layer = _layer.addElement(
        const ArcElement(
          x: -6,
          y: -5,
          radius: 1,
          startAngle: 0,
          endAngle: math.pi / 2,
          color: Colors.purple,
          fillColor: Colors.purple,
          fillOpacity: 0.3,
          strokeWidth: 2,
          id: 'arc-1',
        ),
      );
    }
  }

  void _addLinesAndCurves() {
    // Test lines
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.orange];
    
    for (int i = 0; i < 4; i++) {
      _layer = _layer.addElement(
        const LineElement(
          x1: -6,
          y1: 4,
          x2: -4,
          y2: 6,
          color: Colors.blue,
          strokeWidth: 2.0,
          id: 'line-1',
        ),
      );
    }

    // Test Bezier curves
    _layer = _layer.addElement(
      const BezierCurveElement(
        x: -6,
        y: 0,
        endPoint: const Point(0, 0),
        controlPoint1: const Point(-4, 2),
        controlPoint2: const Point(-2, -2),
        type: BezierType.cubic,
        color: Colors.purple,
        strokeWidth: 2,
        id: 'bezier-1',
      ),
    );

    // Test spiral
    _layer = _layer.addElement(
      const SpiralElement(
        x: 4,
        y: 0,
        type: SpiralType.archimedean,
        rotations: 3,
        growthRate: 0.2,
        startRadius: 0.1,
        color: Colors.teal,
        strokeWidth: 2,
        id: 'spiral-1',
      ),
    );
  }

  void _addArrowsAndAngles() {
    // Test straight arrows
    for (int i = 0; i < 4; i++) {
      _layer = _layer.addElement(
        ArrowElement(
          x1: -6 + (i * 3),
          y1: 4,
          x2: -4 + (i * 3),
          y2: 6,
          color: Colors.blue,
          strokeWidth: 2.0,
          headLength: 0.3,
          headAngle: math.pi / 6,
          style: ArrowStyle.open,
          id: 'arrow-${i + 1}',
        ),
      );
    }

    // Test arced arrows
    for (int i = 0; i < 4; i++) {
      _layer = _layer.addElement(
        ArcedArrowElement(
          x: -6,
          y: 0,
          endX: -4,
          endY: 2,
          radius: 1,
          color: Colors.red,
          strokeWidth: 2,
          headLength: 0.2,  // Shorter head length
          headAngle: math.pi / 6,  // Standard arrow head angle
          id: 'arced-arrow-1',
        ),
      );
    }

    // Test angles
    _layer = _layer.addElement(
      const AngleElement(
        x: -6,
        y: -4,
        vertex: const Point(0, 0),
        point1: const Point(1, 0),
        point2: const Point(0, 1),
        radius: 1,
        markerStyle: AngleMarkerStyle.single,
        color: Colors.green,
        strokeWidth: 2,
        showMeasure: true,
        textStyle: TextStyle(fontSize: 12),
        id: 'angle-1',
      ),
    );

    _layer = _layer.addElement(
      const AngleElement(
        x: -3,
        y: -4,
        vertex: const Point(0, 0),
        point1: const Point(1, 0),
        point2: const Point(1, 1),
        radius: 1,
        markerStyle: AngleMarkerStyle.double,
        color: Colors.green,
        strokeWidth: 2,
        showMeasure: true,
        textStyle: TextStyle(fontSize: 12),
        id: 'angle-2',
      ),
    );

    _layer = _layer.addElement(
      const AngleElement(
        x: 0,
        y: -4,
        vertex: const Point(0, 0),
        point1: const Point(1, 0),
        point2: const Point(0, -1),
        radius: 1,
        markerStyle: AngleMarkerStyle.triple,
        color: Colors.green,
        strokeWidth: 2,
        showMeasure: true,
        textStyle: TextStyle(fontSize: 12),
        id: 'angle-3',
      ),
    );
  }

  void _addPolygons() {
    // Test triangles
    _layer = _layer
      .addElement(
        const RightTriangleElement(
          x: -6,
          y: 4,
          width: 2,
          height: 2,
          color: Colors.blue,
          fillColor: Colors.blue,
          fillOpacity: 0.3,
          strokeWidth: 2,
          id: 'right-triangle',
        ),
      )
      .addElement(
        const IsoscelesTriangleElement(
          x: -3,
          y: 4,
          baseWidth: 2,
          height: 2,
          color: Colors.blue,
          fillColor: Colors.blue,
          fillOpacity: 0.3,
          strokeWidth: 2,
          id: 'isosceles-triangle',
        ),
      );

    // Test regular polygons
    for (int i = 3; i <= 6; i++) {
      _layer = _layer.addElement(
        const RegularPolygonElement(
          x: -6,
          y: 0,
          radius: 1,
          sides: 3,
          color: Colors.purple,
          fillColor: Colors.purple,
          fillOpacity: 0.3,
          strokeWidth: 2,
          id: 'polygon-3',
        ),
      );
    }

    // Test stars
    for (int i = 5; i <= 8; i++) {
      _layer = _layer.addElement(
        StarElement(
          x: -6 + ((i - 5) * 3),
          y: -4,
          points: i,
          outerRadius: 1,
          innerRadius: 0.5,
          color: Colors.orange,
          strokeWidth: 2,
          fillColor: Colors.orange.withOpacity(0.3),
          fillOpacity: 1.0,
          id: 'star-$i',
        ),
      );
    }
  }

  void _addTextAndLabels() {
    final textSizes = [12.0, 16.0, 20.0, 24.0];
    final textColors = [Colors.black, Colors.blue, Colors.red, Colors.green];
    
    for (int i = 0; i < 4; i++) {
      _layer = _layer.addElement(
        const TextElement(
          x: -6,
          y: 4,
          text: "Text 1",
          color: Colors.black,
          style: TextStyle(fontSize: 12),
          id: 'text-1',
        ),
      );
    }
  }

  void _addCompositeElements() {
    // Test coordinate grid
    _layer = _layer.addElement(
      const CoordinateGridElement(
        x: 0,
        y: 0,
        type: CoordinateType.cartesian,
        majorSpacing: 1.0,
        minorSpacing: 0.2,
        majorColor: Colors.blue,
        minorColor: Colors.lightBlue,
        majorStrokeWidth: 1.0,
        minorStrokeWidth: 0.5,
        opacity: 0.5,
        showLabels: true,
        labelFontSize: 12,
        labelColor: Colors.black,
        id: 'coord-grid',
      ),
    );

    // X-axis ruler
    _layer = _layer.addElement(
      const RulerElement(
        x: -6,  // Start from left side
        y: 0,   // Align with x-axis
        length: 12,  // Span the full width
        orientation: RulerOrientation.horizontal,
        majorTickSpacing: 1.0,
        minorTickSpacing: 0.2,
        majorTickLength: 0.2,
        minorTickLength: 0.1,
        strokeWidth: 1.0,
        showLabels: true,
        labelSize: 12,
        id: 'ruler-x',
      ),
    );

    // Y-axis ruler
    _layer = _layer.addElement(
      const RulerElement(
        x: 0,    // Align with y-axis
        y: -4,   // Start from bottom
        length: 8,  // Span the full height
        orientation: RulerOrientation.vertical,
        majorTickSpacing: 1.0,
        minorTickSpacing: 0.2,
        majorTickLength: 0.2,
        minorTickLength: 0.1,
        strokeWidth: 1.0,
        showLabels: true,
        labelSize: 12,
        id: 'ruler-y',
      ),
    );
  }

  void _addCoordinateTests() {
    // Add elements at specific coordinates to test coordinate system
    final testPoints = [
      const Point(-5, 5),
      const Point(5, 5),
      const Point(-5, -5),
      const Point(5, -5),
      const Point(0, 0),
    ];

    for (var point in testPoints) {
      _layer = _layer.addElement(
        CircleElement(
          x: point.x,
          y: point.y,
          radius: 0.1, // Smaller radius for better precision
          color: Colors.red,
          fillColor: Colors.red,
          strokeWidth: 1.0,
          id: 'coord-test-${point.x},${point.y}',
        ),
      );

      _layer = _layer.addElement(
        TextElement(
          x: point.x + 0.2,
          y: point.y + 0.2,
          text: "(${point.x}, ${point.y})",
          color: Colors.black,
          style: const TextStyle(fontSize: 10),
          id: 'coord-label-${point.x},${point.y}',
        ),
      );
    }
  }

  void _adjustScale(double delta) {
    setState(() {
      _scale = (_scale + delta).clamp(10, 200);
      _initializeLayer();
    });
  }

  void _adjustOrigin(Offset delta) {
    setState(() {
      _origin = _origin + delta;
      _initializeLayer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Element Test Suite'),
        actions: [
          IconButton(
            icon: Icon(_showDebugInfo ? Icons.bug_report : Icons.bug_report_outlined),
            onPressed: () {
              setState(() {
                _showDebugInfo = !_showDebugInfo;
                _initializeLayer();
              });
            },
            tooltip: 'Toggle Debug Info',
          ),
          IconButton(
            icon: Icon(_showGrid ? Icons.grid_on : Icons.grid_off),
            onPressed: () {
              setState(() {
                _showGrid = !_showGrid;
                _initializeLayer();
              });
            },
            tooltip: 'Toggle Grid',
          ),
          IconButton(
            icon: Icon(_showAxes ? Icons.show_chart : Icons.hide_source),
            onPressed: () {
              setState(() {
                _showAxes = !_showAxes;
                _initializeLayer();
              });
            },
            tooltip: 'Toggle Axes',
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(
                  _testSets.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => setState(() {
                        _currentTestSet = index;
                        _initializeLayer();
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentTestSet == index
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                      child: Text(_testSets[index]),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.zoom_in),
                  onPressed: () => _adjustScale(5),
                ),
                Text('Scale: ${_scale.toStringAsFixed(1)}'),
                IconButton(
                  icon: const Icon(Icons.zoom_out),
                  onPressed: () => _adjustScale(-5),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                _adjustOrigin(details.delta);
              },
              child: CustomPaint(
                size: const Size(800, 600),
                painter: CustomPaintRenderer(_layer),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
