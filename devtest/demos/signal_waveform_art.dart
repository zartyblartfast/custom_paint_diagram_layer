import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

class SignalWaveformArt extends StatefulWidget {
  const SignalWaveformArt({super.key});
  @override
  State<SignalWaveformArt> createState() => _SignalWaveformArtState();
}

class _SignalWaveformArtState extends State<SignalWaveformArt> {
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
        origin: const Offset(400, 300),  // Center of 800x600 canvas
        xRangeMin: -400,  // Full width range
        xRangeMax: 400,
        yRangeMin: -300,  // Full height range
        yRangeMax: 300,
        scale: _scale,
      ),
      elements: _createElements(_sliderValue),
    );
  }

  List<DrawableElement> _createElements(double sliderValue) {
    final elements = <DrawableElement>[];
    
    // Grid lines for technical look
    for (int x = -400; x <= 400; x += 50) {
      elements.add(LineElement(
        x1: x.toDouble(),
        y1: -300,
        x2: x.toDouble(),
        y2: 300,
        color: Colors.grey.withOpacity(0.3),
        strokeWidth: 1,
      ));
    }
    for (int y = -300; y <= 300; y += 50) {
      elements.add(LineElement(
        x1: -400,
        y1: y.toDouble(),
        x2: 400,
        y2: y.toDouble(),
        color: Colors.grey.withOpacity(0.3),
        strokeWidth: 1,
      ));
    }

    // Axes
    elements.add(LineElement(
      x1: -400,
      y1: 0,
      x2: 400,
      y2: 0,
      color: Colors.black,
      strokeWidth: 2,
    ));
    elements.add(LineElement(
      x1: 0,
      y1: -300,
      x2: 0,
      y2: 300,
      color: Colors.black,
      strokeWidth: 2,
    ));

    // Create sine wave points
    final points = <Point2D>[];
    for (double x = -400; x <= 400; x += 5) {
      final frequency = 1 + sliderValue * 3; // 1-4 Hz
      final y = math.sin(x * frequency * math.pi / 180) * 100;
      points.add(Point2D(x, y));
    }

    // Add sine wave
    elements.add(PolygonElement(
      points: points,
      x: 0,
      y: 0,
      color: Colors.blue,
      strokeWidth: 2,
      closed: false,
    ));

    return elements;
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
        title: const Text('Signal Waveform Demo'),
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
                const Text('Frequency Control'),
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
