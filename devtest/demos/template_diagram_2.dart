import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

/// A template diagram that properly follows the layer architecture
class TemplateDiagram2 extends DiagramRendererBase 
    with DiagramMigrationHelper, DiagramControllerMixin {
  
  static const String valueKey = 'value';
  final Map<String, dynamic>? _initialValues;
  final void Function(Map<String, dynamic>)? _onValuesChanged;

  TemplateDiagram2({
    super.config,
    Map<String, dynamic>? initialValues,
    void Function(Map<String, dynamic>)? onValuesChanged,
  }) : _initialValues = initialValues,
       _onValuesChanged = onValuesChanged;

  @override
  void initState() {
    initializeController(
      defaultValues: {
        valueKey: 0.0,
        ...?_initialValues,
      },
      onValuesChanged: _onValuesChanged,
    );
    super.initState();  // This calls _initDiagram() in DiagramRendererBase
  }

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
    // Create standard grid
    final grid = GridElement(
      x: 0,
      y: 0,
      majorSpacing: 1.0,
      minorSpacing: 0.2,
      majorColor: Colors.grey.withOpacity(0.5),
      minorColor: Colors.grey.withOpacity(0.2),
    );

    // Create axes
    const xAxis = XAxisElement(
      yValue: 0,  // X-axis positioned at y=0
      tickInterval: 1.0,
      color: Colors.black,
    );

    const yAxis = YAxisElement(
      xValue: 0,  // Y-axis positioned at x=0
      tickInterval: 1.0,
      color: Colors.black,
    );

    // Create text element
    final textElement = TextElement(
      x: 0,
      y: 0,
      text: 'Template 2',
      color: Colors.black,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    );

    return [grid, xAxis, yAxis, textElement];
  }

  @override
  void updateFromController() {
    updateElements();
  }

  @override
  DiagramRendererBase updateConfig(DiagramConfig newConfig) {
    return TemplateDiagram2(
      config: newConfig,
      initialValues: _initialValues,
      onValuesChanged: _onValuesChanged,
    );
  }
}

/// Widget that can display the template diagram
class TemplateDiagram2Demo extends StatefulWidget {
  const TemplateDiagram2Demo({super.key});

  @override
  State<TemplateDiagram2Demo> createState() => _TemplateDiagram2DemoState();
}

class _TemplateDiagram2DemoState extends State<TemplateDiagram2Demo> {
  late TemplateDiagram2 diagram;

  @override
  void initState() {
    super.initState();
    diagram = TemplateDiagram2(
      config: const DiagramConfig(
        width: 800,
        height: 600,
      ),
      onValuesChanged: (values) => setState(() {}),
    );
    diagram.initState();
  }

  @override
  Widget build(BuildContext context) {
    return diagram.buildDiagramWidget(context);
  }
}

void main() {
  runApp(const MaterialApp(home: TemplateDiagram2Demo()));
}