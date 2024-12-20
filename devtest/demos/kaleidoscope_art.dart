import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'dart:math' as math;
import '../utils/diagram_test_base.dart';

class KaleidoscopeArt extends DiagramTestBase {
  const KaleidoscopeArt({super.key}) : super(
    title: 'Kaleidoscope Art',
    coordRange: 400.0,
  );

  @override
  DiagramTestBaseState<KaleidoscopeArt> createState() => _KaleidoscopeArtState();
}

class _KaleidoscopeArtState extends DiagramTestBaseState<KaleidoscopeArt> {
  late IDiagramLayer diagramLayer;
  double _sliderValue = 0.0;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    diagramLayer = _createDiagramLayer();
  }

  IDiagramLayer _createDiagramLayer() {
    final elements = createElements(_sliderValue);
    
    return BasicDiagramLayer(
      coordinateSystem: CoordinateSystem(
        origin: const Offset(400, 300),
        xRangeMin: -400,
        xRangeMax: 400,
        yRangeMin: -300,
        yRangeMax: 300,
        scale: _scale,
      ),
      elements: elements,
    );
  }

  @override
  List<DrawableElement> createElements(double sliderValue) {
    final elements = <DrawableElement>[];
    _addKaleidoscopeElements(elements, sliderValue);
    return elements;
  }

  @override
  double get elementHeight => 200.0;  // Height of the kaleidoscope pattern

  void _addKaleidoscopeElements(List<DrawableElement> elements, double sliderValue) {
    const numReflections = 12;  
    const baseRadius = 200.0;  

    // Create triangular patterns
    for (double angle = 0; angle < 2 * math.pi; angle += 2 * math.pi / numReflections) {
      final rotatedAngle = angle + sliderValue * 2 * math.pi;
      
      for (int i = 0; i < 3; i++) {
        final triangleAngle = rotatedAngle + (i * 2 * math.pi / 3);
        final points = [
          Point2D(
            baseRadius * math.cos(triangleAngle),
            baseRadius * math.sin(triangleAngle),
          ),
          Point2D(
            baseRadius * 0.5 * math.cos(triangleAngle + math.pi / 6),
            baseRadius * 0.5 * math.sin(triangleAngle + math.pi / 6),
          ),
          Point2D(
            baseRadius * 0.5 * math.cos(triangleAngle - math.pi / 6),
            baseRadius * 0.5 * math.sin(triangleAngle - math.pi / 6),
          ),
        ];

        final hue = (360 * sliderValue + i * 120) % 360;
        elements.add(PolygonElement(
          points: points,
          x: 0,
          y: 0,
          fillColor: HSLColor.fromAHSL(0.7, hue, 1.0, 0.5).toColor(),
          color: Colors.white,
          strokeWidth: 2.0,
        ));
      }

      // Add decorative circles at triangle vertices
      elements.add(CircleElement(
        x: baseRadius * math.cos(rotatedAngle),
        y: baseRadius * math.sin(rotatedAngle),
        radius: baseRadius * 0.1,
        fillColor: HSLColor.fromAHSL(0.8, (360 * sliderValue + 60) % 360, 1.0, 0.5).toColor(),
        color: Colors.white,
        strokeWidth: 2.0,
      ));
    }

    // Add central circle
    elements.add(CircleElement(
      x: 0,
      y: 0,
      radius: baseRadius * 0.2,
      fillColor: HSLColor.fromAHSL(0.9, (360 * sliderValue) % 360, 1.0, 0.5).toColor(),
      color: Colors.white,
      strokeWidth: 2.0,
    ));
  }

  void _updateDiagram() {
    setState(() {
      diagramLayer = _createDiagramLayer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kaleidoscope Art'),
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              scaleEnabled: true,
              minScale: 0.1,
              maxScale: 10.0,
              onInteractionUpdate: (details) {
                setState(() {
                  _scale = details.scale;
                });
              },
              child: CustomPaint(
                painter: CustomPaintRenderer(diagramLayer),
                size: const Size(800, 600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Rotate Pattern'),
                Slider(
                  value: _sliderValue,
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                      _updateDiagram();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
