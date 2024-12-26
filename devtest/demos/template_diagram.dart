import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

/// A minimal template diagram using the new renderer architecture
class TemplateDiagram extends DiagramRendererBase 
    with DiagramMigrationHelper, DiagramControllerMixin {
  
  final Map<String, dynamic>? _initialValues;
  final void Function(Map<String, dynamic>)? _onValuesChanged;
  bool _showAxes = true;  // Track axes visibility
  bool _showGrid = true;  // Track grid visibility
  bool _showFrame = true;  // Track frame visibility

  TemplateDiagram({
    super.config,
    Map<String, dynamic>? initialValues,
    void Function(Map<String, dynamic>)? onValuesChanged,
  }) : _initialValues = initialValues,
       _onValuesChanged = onValuesChanged;

  @override
  void initState() {
    initializeController(
      defaultValues: {
        ...?_initialValues,
      },
      onValuesChanged: _onValuesChanged,
    );
    super.initState();
  }

  @override
  void updateFromController() {
    // No controller updates needed for this template
  }

  @override
  DiagramRendererBase updateConfig(DiagramConfig newConfig) {
    return TemplateDiagram(
      config: newConfig,
      initialValues: _initialValues,
      onValuesChanged: _onValuesChanged,
    );
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
    // Initialize diagram layer
    diagramLayer = BasicDiagramLayer(
      coordinateSystem: createCoordinateSystem(),
      showAxes: _showAxes,
    );

    // Add grid if needed
    if (_showGrid) {
      diagramLayer = diagramLayer.addElement(GridElement(
        x: 0,
        y: 0,
        majorSpacing: 1.0,
        minorSpacing: 0.2,
        majorColor: Colors.grey.withOpacity(0.5),
        minorColor: Colors.grey.withOpacity(0.2),
      ));
    }

    // Add axes if needed
    if (_showAxes) {
      diagramLayer = diagramLayer.toggleAxes();
    }

    // Create text element
    final textElement = TextElement(
      x: 0,
      y: 0,
      text: 'Template',
      color: Colors.black,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 96,
      ),
    );

    // Add frame if needed (last to draw on top)
    if (_showFrame) {
      diagramLayer = diagramLayer.addElement(RectangleElement(
        x: -9,  // Slightly inside the coordinate range
        y: -9,
        width: 18,  // To frame the -10 to 10 range
        height: 18,
        strokeWidth: 2.0,
        color: Colors.black,
        fillColor: Colors.grey[200],  // Light grey fill
        fillOpacity: 0.1,  // Very transparent
      ));
    }

    // Return text element
    return [textElement];
  }

  /// Toggle grid visibility
  void toggleGrid() {
    _showGrid = !_showGrid;
    updateElements();
  }

  /// Show the grid
  void showGrid() {
    _showGrid = true;
    updateElements();
  }

  /// Hide the grid
  void hideGrid() {
    _showGrid = false;
    updateElements();
  }

  /// Toggle axes visibility
  void toggleAxes() {
    _showAxes = !_showAxes;
    updateElements();
  }

  /// Show axes
  void showAxes() {
    _showAxes = true;
    updateElements();
  }

  /// Hide axes
  void hideAxes() {
    _showAxes = false;
    updateElements();
  }

  /// Toggle frame visibility
  void toggleFrame() {
    _showFrame = !_showFrame;
    updateElements();
  }

  /// Show the frame
  void showFrame() {
    if (!_showFrame) {
      _showFrame = true;
      updateElements();
    }
  }

  /// Hide the frame
  void hideFrame() {
    if (_showFrame) {
      _showFrame = false;
      updateElements();
    }
  }
}

/// Widget that can display the template diagram in either standalone or embedded mode
class TemplateDiagramDemo extends StatefulWidget {
  final bool useStandalone;
  
  const TemplateDiagramDemo({
    super.key,
    this.useStandalone = true,
  });

  @override
  State<TemplateDiagramDemo> createState() => _TemplateDiagramDemoState();
}

class _TemplateDiagramDemoState extends State<TemplateDiagramDemo> {
  late final TemplateDiagram diagram;

  @override
  void initState() {
    super.initState();
    diagram = TemplateDiagram(
      config: const DiagramConfig(
        width: 800,
        height: 600,
        showGrid: true,
        showAxes: false,  // Match our default state
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
            title: const Text('Template Diagram'),
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
  runApp(const TemplateDiagramDemo());
}
