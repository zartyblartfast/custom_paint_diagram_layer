import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

/// Example of a diagram using the new renderer architecture while
/// maintaining compatibility with existing patterns.
class ExampleDiagram extends DiagramRendererBase with DiagramMigrationHelper {
  // State variables (if needed for interactive elements)
  double _position = 0.5;

  ExampleDiagram({
    super.config,
  });

  @override
  CoordinateSystem createCoordinateSystem() {
    return CoordinateSystem(
      origin: Offset.zero,
      xRangeMin: -10,
      xRangeMax: 10,
      yRangeMin: -10,
      yRangeMax: 10,
      scale: 1.0,
    );
  }

  @override
  List<DrawableElement> createElements() {
    // Map position (0-1) to coordinate space
    final x = (_position * 20) - 10;
    
    return [
      // Create a simple group with rectangle and circle
      GroupElement(
        x: x,
        y: 0,
        children: [
          RectangleElement(
            x: -1,
            y: -1,
            width: 2,
            height: 2,
            color: Colors.blue,
            fillColor: Colors.blue.withOpacity(0.3),
          ),
          CircleElement(
            x: 0,
            y: 2,
            radius: 1,
            color: Colors.red,
            fillColor: Colors.red.withOpacity(0.3),
          ),
        ],
      ),
    ];
  }

  @override
  DiagramRendererBase updateConfig(DiagramConfig newConfig) {
    return ExampleDiagram(config: newConfig);
  }

  // Support for legacy slider updates
  @override
  void updateFromSlider(double value) {
    _position = value;
    updateElements();
  }
}

/// Widget that demonstrates both standalone and embedded usage
class ExampleDiagramDemo extends StatelessWidget {
  final bool useStandalone;
  
  const ExampleDiagramDemo({
    super.key,
    this.useStandalone = true,
  });

  @override
  Widget build(BuildContext context) {
    final diagram = ExampleDiagram(
      config: const DiagramConfig(
        width: 600,
        height: 400,
        showGrid: true,
        showAxes: true,
      ),
    );

    // Demonstrate both usage patterns
    if (useStandalone) {
      // Legacy-style full page with controls
      return diagram.wrapInTestWidget('Example Migrated Diagram');
    } else {
      // New embedded style
      return diagram.wrapForWeb();
    }
  }
}

/// Entry point for standalone demo
void main() {
  runApp(
    const MaterialApp(
      home: ExampleDiagramDemo(useStandalone: true),
    ),
  );
}
