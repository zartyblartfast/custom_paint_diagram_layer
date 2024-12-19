import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

class HarmonyWaveArt extends StatefulWidget {
  const HarmonyWaveArt({super.key});
  @override
  State<HarmonyWaveArt> createState() => _HarmonyWaveArtState();
}

class _HarmonyWaveArtState extends State<HarmonyWaveArt> {
  late IDiagramLayer diagramLayer;
  double _timePosition = 0.0;  // Renamed from _sliderValue - position in time
  double _timeRange = 1.0;    // New - controls how much time we see
  double _scale = 1.0;

  // Musical frequencies for C major triad
  static const cFreq = 261.63;  // C4 (middle C)
  static const eFreq = 329.63;  // E4
  static const gFreq = 392.00;  // G4

  @override
  void initState() {
    super.initState();
    diagramLayer = _createDiagramLayer();
  }

  IDiagramLayer _createDiagramLayer() {
    return BasicDiagramLayer(
      coordinateSystem: CoordinateSystem(
        origin: const Offset(400, 300),
        xRangeMin: -400,
        xRangeMax: 400,
        yRangeMin: -300,
        yRangeMax: 300,
        scale: _scale,
      ),
      elements: _createElements(_timePosition, _timeRange),
    );
  }

  List<DrawableElement> _createElements(double timePosition, double timeRange) {
    final elements = <DrawableElement>[];
    
    // Grid lines
    for (int x = -400; x <= 400; x += 50) {
      elements.add(LineElement(
        x1: x.toDouble(),
        y1: -300,
        x2: x.toDouble(),
        y2: 300,
        color: Colors.grey.withOpacity(0.1),
        strokeWidth: 1,
      ));
    }
    for (int y = -300; y <= 300; y += 50) {
      elements.add(LineElement(
        x1: -400,
        y1: y.toDouble(),
        x2: 400,
        y2: y.toDouble(),
        color: Colors.grey.withOpacity(0.1),
        strokeWidth: 1,
      ));
    }

    // Time axis
    elements.add(LineElement(
      x1: -400,
      y1: 0,
      x2: 400,
      y2: 0,
      color: Colors.black,
      strokeWidth: 2,
    ));

    // Create waveforms for each note
    final baseTimeScale = 0.01 / timeRange;  // Adjust time range with slider
    final timeOffset = timePosition * 10;    // Move through time
    final amplitude = 80.0;  // Height of waves

    // Helper function to create wave points
    List<Point2D> createWavePoints(double frequency, double timeScale, double offset) {
      final points = <Point2D>[];
      for (double x = -400; x <= 400; x += 2) {
        final t = (x * timeScale) + offset;
        final y = math.sin(2 * math.pi * frequency * t) * amplitude;
        points.add(Point2D(x, y));
      }
      return points;
    }

    // C note (red)
    elements.add(PolygonElement(
      points: createWavePoints(cFreq, baseTimeScale, timeOffset),
      x: 0,
      y: 0,
      color: Colors.red,
      strokeWidth: 2,
      closed: false,
    ));

    // E note (green)
    elements.add(PolygonElement(
      points: createWavePoints(eFreq, baseTimeScale, timeOffset),
      x: 0,
      y: 0,
      color: Colors.green,
      strokeWidth: 2,
      closed: false,
    ));

    // G note (blue)
    elements.add(PolygonElement(
      points: createWavePoints(gFreq, baseTimeScale, timeOffset),
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
        title: const Text('Musical Harmony Visualization'),
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
                const Text('Time Range (Zoom)'),
                Slider(
                  value: _timeRange,
                  min: 0.01,  // More extreme zoom in
                  max: 50.0,  // Much more zoom out
                  onChanged: (value) {
                    setState(() {
                      _timeRange = value;
                      _updateDiagram();
                    });
                  },
                ),
                const Text('Window Position'),
                Slider(
                  value: _timePosition,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (value) {
                    setState(() {
                      _timePosition = value;
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
