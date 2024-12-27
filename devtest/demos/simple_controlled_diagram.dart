import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

/// Simple diagram with a circle controlled by external inputs
class SimpleControlledDiagram extends DiagramRendererBase with DiagramControllerMixin {
  static const String radiusKey = 'radius';
  
  SimpleControlledDiagram({
    super.config,
    Map<String, dynamic>? initialValues,
    void Function(Map<String, dynamic>)? onValuesChanged,
  }) {
    initializeController(
      defaultValues: {radiusKey: 1.0, ...?initialValues},
      onValuesChanged: onValuesChanged,
    );
  }

  @override
  CoordinateSystem createCoordinateSystem() {
    return CoordinateSystem(
      origin: Offset.zero,
      xRangeMin: -5,
      xRangeMax: 5,
      yRangeMin: -5,
      yRangeMax: 5,
      scale: 1.0,
    );
  }

  @override
  List<DrawableElement> createElements() {
    return [
      // Simple circle with radius controlled by external slider
      CircleElement(
        x: 0,
        y: 0,
        radius: controller.getValue<double>(radiusKey) ?? 1.0,
        color: Colors.blue,
        strokeWidth: 2.0,
      ),
    ];
  }
}

/// Demo page showing external control of the diagram
class SimpleControlledDiagramDemo extends StatefulWidget {
  const SimpleControlledDiagramDemo({super.key});

  @override
  State<SimpleControlledDiagramDemo> createState() => _SimpleControlledDiagramDemoState();
}

class _SimpleControlledDiagramDemoState extends State<SimpleControlledDiagramDemo> {
  late SimpleControlledDiagram diagram;
  double currentRadius = 1.0;

  @override
  void initState() {
    super.initState();
    diagram = SimpleControlledDiagram(
      config: DiagramConfig(
        width: 400,
        height: 400,
        showAxes: true,
        showGrid: true,
      ),
      initialValues: {SimpleControlledDiagram.radiusKey: currentRadius},
      onValuesChanged: (values) {
        // Update our local state when diagram values change
        setState(() {
          currentRadius = values[SimpleControlledDiagram.radiusKey] ?? currentRadius;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Controlled Diagram'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The diagram
            diagram.buildDiagramWidget(context),
            
            const SizedBox(height: 20),
            
            // External controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Radius: '),
                SizedBox(
                  width: 300,
                  child: Slider(
                    min: 0.1,
                    max: 4.0,
                    value: currentRadius,
                    onChanged: (value) {
                      setState(() {
                        currentRadius = value;
                        // Update the diagram's state
                        diagram.controller.updateValue(
                          SimpleControlledDiagram.radiusKey,
                          value,
                        );
                      });
                    },
                  ),
                ),
                Text(currentRadius.toStringAsFixed(2)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: SimpleControlledDiagramDemo()));
}
