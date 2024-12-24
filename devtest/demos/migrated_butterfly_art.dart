import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

/// Migrated version of the butterfly art using the new renderer architecture
class ButterflyDiagram extends DiagramRendererBase 
    with DiagramMigrationHelper, DiagramControllerMixin {
  static const String flutterControlKey = 'flutter';
  
  // Colors for butterfly parts
  static const wingColor = Color(0xFF9C27B0); // Purple
  static const bodyColor = Color(0xFF4CAF50); // Green
  static const antennaeColor = Color(0xFFFFC107); // Amber

  final Map<String, dynamic>? _initialValues;
  final Function(Map<String, dynamic>)? _onValuesChanged;

  ButterflyDiagram({
    super.config,
    Map<String, dynamic>? initialValues,
    Function(Map<String, dynamic>)? onValuesChanged,
  }) : _initialValues = initialValues,
       _onValuesChanged = onValuesChanged;

  @override
  void initState() {
    // Initialize controller before calling super which will create elements
    initializeController(
      defaultValues: {
        flutterControlKey: 0.0,
        ...?_initialValues,
      },
      onValuesChanged: _onValuesChanged,
    );
    super.initState();
  }

  @override
  CoordinateSystem createCoordinateSystem() {
    return CoordinateSystem(
      origin: Offset.zero,
      xRangeMin: -12,
      xRangeMax: 12,
      yRangeMin: -12,
      yRangeMax: 12,
      scale: 1.0,
    );
  }

  @override
  List<DrawableElement> createElements() {
    // Calculate wing flutter effect
    final flutterValue = controller.getValue<double>(flutterControlKey) ?? 0.0;
    final flutter = math.sin(flutterValue * math.pi * 2) * 0.3;
    
    return [
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
      
      // Body segments
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

      // Antennae
      BezierCurveElement(
        x: 0,
        y: 1,
        endPoint: Point(-1.5, 2.5),
        controlPoint1: Point(-0.5, 2),
        type: BezierType.quadratic,
        color: antennaeColor,
        strokeWidth: 1,
      ),
      BezierCurveElement(
        x: 0,
        y: 1,
        endPoint: Point(1.5, 2.5),
        controlPoint1: Point(0.5, 2),
        type: BezierType.quadratic,
        color: antennaeColor,
        strokeWidth: 1,
      ),

      // Wing decorations
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
  }

  @override
  DiagramRendererBase updateConfig(DiagramConfig newConfig) {
    return ButterflyDiagram(config: newConfig);
  }

  @override
  void updateFromSlider(double value) {
    controller.setValue(flutterControlKey, value);
    updateElements();
  }

  @override
  void updateFromController() {
    updateElements();
  }

  // Method for external control
  void setFlutterPosition(double value) {
    controller.setValue(flutterControlKey, value);
    updateElements();
  }

  // Get current flutter position
  double getFlutterPosition() {
    return controller.getValue<double>(flutterControlKey) ?? 0.0;
  }
}

/// Widget that can display the butterfly diagram in either standalone or embedded mode
class ButterflyArtDemo extends StatefulWidget {
  final bool useStandalone;
  final bool showControls;
  
  const ButterflyArtDemo({
    super.key,
    this.useStandalone = true,
    this.showControls = true,
  });

  @override
  State<ButterflyArtDemo> createState() => _ButterflyArtDemoState();
}

class _ButterflyArtDemoState extends State<ButterflyArtDemo> {
  late final ButterflyDiagram diagram;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    diagram = ButterflyDiagram(
      config: const DiagramConfig(
        width: 600,
        height: 600,
        showGrid: false,  // Artistic diagram looks better without grid
        showAxes: false,  // Hide axes for artistic effect
      ),
    );
    // Initialize the diagram
    diagram.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useStandalone) {
      // Full page with animation slider
      return Scaffold(
        appBar: AppBar(
          title: const Text('Geometric Butterfly'),
        ),
        body: Column(
          children: [
            Expanded(
              child: diagram.buildDiagramWidget(context),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text('Flutter Wings'),
                  Expanded(
                    child: Slider(
                      value: _sliderValue,
                      onChanged: (value) {
                        setState(() {
                          _sliderValue = value;
                          diagram.updateFromSlider(value);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Embedded version without controls
      // Embedded version with optional controls
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          diagram.wrapForWeb(context),
          if (widget.showControls) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Flutter Wings'),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 200,
                    child: Slider(
                      value: _sliderValue,
                      onChanged: (value) {
                        setState(() {
                          _sliderValue = value;
                          diagram.updateFromSlider(value);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    }
  }
}

/// Entry point for standalone demo
void main() {
  runApp(
    const MaterialApp(
      home: ButterflyArtDemo(useStandalone: true),
    ),
  );
}
