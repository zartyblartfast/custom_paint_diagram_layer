import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

class ColorHarmonyArt extends StatefulWidget {
  const ColorHarmonyArt({super.key});

  @override
  State<ColorHarmonyArt> createState() => _ColorHarmonyArtState();
}

class _ColorHarmonyArtState extends State<ColorHarmonyArt> {
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
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: -10,
        yRangeMax: 10,
        scale: _scale,
      ),
      elements: _createElements(_sliderValue),
    );
  }

  // Convert HSL to Color
  Color _hslToColor(double hue, double saturation, double lightness) {
    final h = hue % 360;
    final s = saturation.clamp(0, 1).toDouble();
    final l = lightness.clamp(0, 1).toDouble();
    
    HSLColor hslColor = HSLColor.fromAHSL(1.0, h, s, l);
    return hslColor.toColor();
  }

  // Create a harmonious color with offset
  Color _getHarmoniousColor(double baseHue, double offset) {
    return _hslToColor((baseHue + offset) % 360, 0.7, 0.5);
  }

  List<DrawableElement> _createElements(double sliderValue) {
    // Base hue rotates through color wheel based on slider
    final baseHue = sliderValue * 360;
    final elements = <DrawableElement>[];
    
    // Create concentric circles with harmonious colors
    for (int i = 0; i < 8; i++) {
      final radius = 8 - i;
      // Create complementary colors (180 degrees apart)
      final color = _getHarmoniousColor(baseHue, i * 45);
      
      elements.add(
        CircleElement(
          x: 0,
          y: 0,
          radius: radius.toDouble(),
          color: color,
          fillColor: color,
          fillOpacity: 0.5,
        ),
      );

      // Add floating geometric shapes around each circle
      final numShapes = 6;
      for (int j = 0; j < numShapes; j++) {
        final angle = (j * math.pi * 2 / numShapes) + (sliderValue * math.pi * 2);
        final shapeRadius = radius * 0.3;
        final distance = radius * 1.2;
        final x = math.cos(angle) * distance;
        final y = math.sin(angle) * distance;
        
        // Alternate between triangles and squares
        if (i % 2 == 0) {
          // Create triangle points
          final points = List<Point2D>.generate(3, (index) {
            final pointAngle = angle + (index * 2 * math.pi / 3);
            return Point2D(
              x + math.cos(pointAngle) * shapeRadius,
              y + math.sin(pointAngle) * shapeRadius,
            );
          });
          
          elements.add(
            PolygonElement(
              points: points,
              x: x,
              y: y,
              color: _getHarmoniousColor(baseHue, (i * 45 + 180) % 360),
              fillColor: _getHarmoniousColor(baseHue, (i * 45 + 180) % 360),
              fillOpacity: 0.5,
            ),
          );
        } else {
          // Create square points
          final points = List<Point2D>.generate(4, (index) {
            final pointAngle = angle + sliderValue * math.pi + (index * math.pi / 2);
            return Point2D(
              x + math.cos(pointAngle) * shapeRadius,
              y + math.sin(pointAngle) * shapeRadius,
            );
          });
          
          elements.add(
            PolygonElement(
              points: points,
              x: x,
              y: y,
              color: _getHarmoniousColor(baseHue, (i * 45 + 180) % 360),
              fillColor: _getHarmoniousColor(baseHue, (i * 45 + 180) % 360),
              fillOpacity: 0.5,
            ),
          );
        }
      }
    }

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
        title: const Text('Color Harmony Art'),
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
                const Text('Color Wheel'),
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
