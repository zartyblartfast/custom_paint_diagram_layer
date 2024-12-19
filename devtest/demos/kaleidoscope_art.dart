import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'dart:math' as math;

class KaleidoscopeArt extends StatefulWidget {
  const KaleidoscopeArt({super.key});
  @override
  State<KaleidoscopeArt> createState() => _KaleidoscopeArtState();
}

class _KaleidoscopeArtState extends State<KaleidoscopeArt> {
  late IDiagramLayer diagramLayer;
  double _sliderValue = 0.0;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    diagramLayer = _createDiagramLayer();
  }

  IDiagramLayer _createDiagramLayer() {
    final elements = <DrawableElement>[];
    _addKaleidoscopeElements(elements);
    
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

  void _addKaleidoscopeElements(List<DrawableElement> elements) {
    const numReflections = 12;  
    const baseRadius = 200.0;  

    void addBasePattern(double angle) {
      final rotatedAngle = angle + _sliderValue * 2 * math.pi;
      
      for (int i = 0; i < 3; i++) {
        final triangleAngle = rotatedAngle + (i * 2 * math.pi / 3);
        final points = <Point2D>[
          Point2D(0, 0),  
          Point2D(
            baseRadius * math.cos(triangleAngle),
            baseRadius * math.sin(triangleAngle),
          ),
          Point2D(
            baseRadius * math.cos(triangleAngle + math.pi / 3),
            baseRadius * math.sin(triangleAngle + math.pi / 3),
          ),
        ];

        final hue = (360 * _sliderValue + i * 120) % 360;
        elements.add(PolygonElement(
          points: points,
          x: 0,
          y: 0,
          fillColor: HSLColor.fromAHSL(1.0, hue, 0.8, 0.5).toColor(),  
          strokeWidth: 3.0,  
          color: Colors.black87,  
        ));

        final circleRadius = baseRadius * 0.15;  
        for (final point in points) {
          elements.add(CircleElement(
            x: point.x,
            y: point.y,
            radius: circleRadius,
            fillColor: HSLColor.fromAHSL(0.8, (hue + 60) % 360, 0.9, 0.6).toColor(),
            color: Colors.black87,  
            strokeWidth: 2.0,
          ));
        }
      }

      elements.add(CircleElement(
        x: 0,
        y: 0,
        radius: baseRadius * 0.2,
        fillColor: HSLColor.fromAHSL(0.9, (360 * _sliderValue) % 360, 1.0, 0.5).toColor(),
        color: Colors.white,
        strokeWidth: 2.0,
      ));
    }

    for (int i = 0; i < numReflections; i++) {
      final angle = (i * 2 * math.pi) / numReflections;
      addBasePattern(angle);
    }
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
