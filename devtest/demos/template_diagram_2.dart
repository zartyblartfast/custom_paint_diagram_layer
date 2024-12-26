import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

/// A template diagram that properly follows the layer architecture
class TemplateDiagram2 extends DiagramRendererBase 
    with DiagramMigrationHelper, DiagramControllerMixin {
  
  static const String valueKey = 'value';
  final Map<String, dynamic>? _initialValues;
  final void Function(Map<String, dynamic>)? _onValuesChanged;

  // Canvas size
  double _canvasWidth = 500;
  double _canvasHeight = 500;

  // Display control flags
  bool _showAxes = true;
  bool _showGrid = true;
  bool _showFrame = true;

  // Frame style
  double _frameStrokeWidth = 1.0;
  Color _frameStrokeColor = Colors.blueAccent;
  Color? _frameFillColor = Colors.grey.shade100;  // Light grey fill
  double _frameOpacity = 1.0;

  TemplateDiagram2({
    super.config,
    Map<String, dynamic>? initialValues,
    void Function(Map<String, dynamic>)? onValuesChanged,
  }) : _initialValues = initialValues,
       _onValuesChanged = onValuesChanged {
    if (config != null) {
      _canvasWidth = config.width;
      _canvasHeight = config.height;
    }
  }

  // Getters and setters for canvas size
  double get canvasWidth => _canvasWidth;
  set canvasWidth(double value) {
    _canvasWidth = value;
    updateConfig(DiagramConfig(
      width: value,
      height: _canvasHeight,
      showAxes: _showAxes,
      showGrid: _showGrid,
      showFrame: _showFrame,
    ));
    updateElements();
  }

  double get canvasHeight => _canvasHeight;
  set canvasHeight(double value) {
    _canvasHeight = value;
    updateConfig(DiagramConfig(
      width: _canvasWidth,
      height: value,
      showAxes: _showAxes,
      showGrid: _showGrid,
      showFrame: _showFrame,
    ));
    updateElements();
  }

  // Getters and setters for axis and grid visibility
  bool get showAxes => _showAxes;
  set showAxes(bool value) {
    _showAxes = value;
    updateElements();
  }

  bool get showGrid => _showGrid;
  set showGrid(bool value) {
    _showGrid = value;
    updateElements();
  }

  bool get showFrame => _showFrame;
  set showFrame(bool value) {
    _showFrame = value;
    updateElements();
  }

  // Getters and setters for frame style
  double get frameStrokeWidth => _frameStrokeWidth;
  set frameStrokeWidth(double value) {
    _frameStrokeWidth = value;
    updateElements();
  }

  Color get frameStrokeColor => _frameStrokeColor;
  set frameStrokeColor(Color value) {
    _frameStrokeColor = value;
    updateElements();
  }

  Color? get frameFillColor => _frameFillColor;
  set frameFillColor(Color? value) {
    _frameFillColor = value;
    updateElements();
  }

  double get frameOpacity => _frameOpacity;
  set frameOpacity(double value) {
    _frameOpacity = value;
    updateElements();
  }

  @override
  void initState() {
    initializeController(
      defaultValues: {
        valueKey: 0.0,
        ...?_initialValues,
      },
      onValuesChanged: _onValuesChanged,
    );
    _initDiagram();  // Call our own _initDiagram instead of super
  }

  @override
  void _initDiagram() {
    final coords = createCoordinateSystem();
    
    // Create initial layer with coordinate system
    diagramLayer = BasicDiagramLayer(
      coordinateSystem: coords,
      showAxes: _showAxes,
    );

    // Add initial elements
    final elements = createElements();
    for (final element in elements) {
      diagramLayer = diagramLayer.addElement(element);
    }
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
    final elements = <DrawableElement>[];

    // Add frame if enabled
    if (_showFrame) {
      elements.add(FrameElement(
        color: _frameStrokeColor,
        strokeWidth: _frameStrokeWidth,
        fillColor: _frameFillColor,
        opacity: _frameOpacity,
      ));
    }

    // Add grid if enabled
    if (_showGrid) {
      elements.add(GridElement(
        x: 0,
        y: 0,
        majorSpacing: 1.0,
        minorSpacing: 0.2,
        majorColor: Colors.grey.withOpacity(0.5),
        minorColor: Colors.grey.withOpacity(0.2),
      ));
    }

    // Add axes if enabled
    if (_showAxes) {
      elements.add(const XAxisElement(
        yValue: 0,  // X-axis positioned at y=0
        tickInterval: 1.0,
        color: Colors.black,
      ));

      elements.add(const YAxisElement(
        xValue: 0,  // Y-axis positioned at x=0
        tickInterval: 1.0,
        color: Colors.black,
      ));
    }

    // Create text element
    elements.add(TextElement(
      x: 0,
      y: 0,
      text: 'Template 2',
      color: Colors.black,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    ));

    return elements;
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
      config: DiagramConfig(
        width: 500,    // Match the new canvas size
        height: 500,   // Match the new canvas size
      ),
    );
    diagram.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: diagram.buildDiagramWidget(context),
        ),
      ),
    );
  }
}

void main() {
  runApp(const TemplateDiagram2Demo());
}