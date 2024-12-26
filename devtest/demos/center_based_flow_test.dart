import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

/// Test diagram for center-based positioning of rectangles and connectors
class CenterFlowDiagram extends DiagramRendererBase 
    with DiagramMigrationHelper, DiagramControllerMixin {
  
  final Map<String, dynamic>? _initialValues;
  final Function(Map<String, dynamic>)? _onValuesChanged;

  CenterFlowDiagram({
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
        ...?_initialValues,
      },
      onValuesChanged: _onValuesChanged,
    );
    super.initState();
  }

  @override
  DiagramRendererBase updateConfig(DiagramConfig newConfig) {
    return CenterFlowDiagram(
      config: newConfig,
      initialValues: _initialValues,
      onValuesChanged: _onValuesChanged,
    );
  }

  @override
  void updateFromController() {
    // No controller updates needed for this simple diagram
  }

  @override
  CoordinateSystem createCoordinateSystem() {
    return CoordinateSystem(
      origin: Offset.zero,
      xRangeMin: -6,
      xRangeMax: 6,
      yRangeMin: -6,
      yRangeMax: 6,
      scale: 1.0,
    );
  }

  @override
  List<DrawableElement> createElements() {
    final elements = <DrawableElement>[];
    final rectColor = Colors.lightBlue.shade100;
    final strokeColor = Colors.black87;

    // Create top rectangle with label
    final topGroup = GroupElement(
      x: 0,     // Center X
      y: 2,     // Upper position
      children: [
        RectangleElement(
          x: 0,     // Center relative to group
          y: 0,     // Center relative to group
          width: 2,
          height: 1,
          color: strokeColor,
          fillColor: rectColor,
          borderRadius: 0.2,
        ),
        TextElement(
          x: 0,    // Center of rectangle
          y: 0,    // Center of rectangle
          text: 'Top',
          color: Colors.black,
        ),
      ],
    );
    elements.add(topGroup);

    // Create bottom rectangle with label
    final bottomGroup = GroupElement(
      x: 0,     // Center X
      y: 0,     // Lower position
      children: [
        RectangleElement(
          x: 0,     // Center relative to group
          y: 0,     // Center relative to group
          width: 2,
          height: 1,
          color: strokeColor,
          fillColor: rectColor,
          borderRadius: 0.2,
        ),
        TextElement(
          x: 0,    // Center of rectangle
          y: 0,    // Center of rectangle
          text: 'Bottom',
          color: Colors.black,
        ),
      ],
    );
    elements.add(bottomGroup);

    // Add vertical connector between rectangles
    final (start, end) = ConnectorElement.calculateConnectionPoints(
      startGroup: topGroup,
      startSocket: Socket.B,
      endGroup: bottomGroup,
      endSocket: Socket.T,
      coordSystem: diagramLayer.coordinateSystem,
    );
    
    final connector = ConnectorElement(
      start: start,
      end: end,
      endEndpoint: ConnectorEndpoint.arrow,
      strokeWidth: 2.0,
      color: strokeColor,
    );
    elements.add(connector);

    return elements;
  }
}

/// Widget that displays the center-based flow test diagram
class CenterFlowDemo extends StatefulWidget {
  final bool useStandalone;
  
  const CenterFlowDemo({
    super.key,
    this.useStandalone = true,
  });

  @override
  State<CenterFlowDemo> createState() => _CenterFlowDemoState();
}

class _CenterFlowDemoState extends State<CenterFlowDemo> {
  late final CenterFlowDiagram diagram;

  @override
  void initState() {
    super.initState();
    diagram = CenterFlowDiagram(
      config: const DiagramConfig(
        width: 800,
        height: 600,
        showGrid: true,
        showAxes: true,
      ),
    );
    diagram.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useStandalone) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Center Based Flow Test'),
            backgroundColor: Colors.blue,
          ),
          body: Center(
            child: diagram.buildDiagramWidget(context),
          ),
        ),
      );
    } else {
      return diagram.buildDiagramWidget(context);
    }
  }
}

void main() {
  runApp(const CenterFlowDemo());
}
