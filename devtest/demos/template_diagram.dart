import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

/// A template diagram that properly follows the layer architecture
class TemplateDiagram extends DiagramRendererBase 
    with DiagramMigrationHelper, DiagramControllerMixin {
  
  static const String valueKey = 'value';
  final Map<String, dynamic>? _initialValues;
  final void Function(Map<String, dynamic>)? _onValuesChanged;

  // Title
  final String _title = 'Template Diagram';

  // Canvas size
  double _canvasWidth = 500;
  double _canvasHeight = 500;

  // Coordinate system configuration
  
  // 1. Standard coordinate system (origin at center, equal ranges)
  double _xRangeMin = -10;
  double _xRangeMax = 10;
  double _yRangeMin = -10;
  double _yRangeMax = 10;
  double _scale = 1.0;
  Offset _labelCoords = Offset(-5, 5);  // Top-left quadrant

  // 2. Origin at bottom-left with positive values
  //double _xRangeMin = 0;
  //double _xRangeMax = 20;
  //double _yRangeMin = 0;
  //double _yRangeMax = 20;
  //double _scale = 1.0;
  //Offset _labelCoords = Offset(10, 10);  // center

  // 3. X-axis -10 to +10 at bottom, Y 0 to 10 from origin
  //double _xRangeMin = -10;
  //double _xRangeMax = 10;
  //double _yRangeMin = 0;
  //double _yRangeMax = 10;
  //double _scale = 1.0;
  //Offset _labelCoords = Offset(-5, 5);  // Upper left area

  // 4. Larger coordinate ranges (-100 to +100)
  //double _xRangeMin = -100;
  //double _xRangeMax = 100;
  //double _yRangeMin = -100;
  //double _yRangeMax = 100;
  //double _scale = 0.1;  // Smaller scale to fit in canvas
  //Offset _labelCoords = Offset(-50, 50);  // Proportionally in top-left quadrant

  // Display control flags
  bool _showAxes = true;
  bool _showGrid = true;
  bool _showFrame = true;

  // Frame style
  double _frameStrokeWidth = 1.0;
  Color _frameStrokeColor = Colors.blueAccent;
  Color? _frameFillColor = Colors.grey.shade100;  // Light grey fill
  double _frameOpacity = 1.0;

  TemplateDiagram({
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

  // Getters and setters for coordinate system
  double get xRangeMin => _xRangeMin;
  set xRangeMin(double value) {
    _xRangeMin = value;
    _updateCoordinateSystem();
  }

  double get xRangeMax => _xRangeMax;
  set xRangeMax(double value) {
    _xRangeMax = value;
    _updateCoordinateSystem();
  }

  double get yRangeMin => _yRangeMin;
  set yRangeMin(double value) {
    _yRangeMin = value;
    _updateCoordinateSystem();
  }

  double get yRangeMax => _yRangeMax;
  set yRangeMax(double value) {
    _yRangeMax = value;
    _updateCoordinateSystem();
  }

  double get scale => _scale;
  set scale(double value) {
    _scale = value;
    _updateCoordinateSystem();
  }

  Offset get labelCoords => _labelCoords;
  set labelCoords(Offset value) {
    _labelCoords = value;
    updateElements();
  }

  // Helper method to update coordinate system
  void _updateCoordinateSystem() {
    final coords = createCoordinateSystem();
    diagramLayer = diagramLayer.updateCoordinateSystem(coords);
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
      xRangeMin: _xRangeMin,
      xRangeMax: _xRangeMax,
      yRangeMin: _yRangeMin,
      yRangeMax: _yRangeMax,
      scale: _scale,
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
      x: _labelCoords.dx,
      y: _labelCoords.dy,
      text: 'Template',
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
    return TemplateDiagram(
      config: newConfig,
      initialValues: _initialValues,
      onValuesChanged: _onValuesChanged,
    );
  }
}

/// Widget that can display the template diagram
class TemplateDiagramDemo extends StatefulWidget {
  const TemplateDiagramDemo({super.key});

  @override
  State<TemplateDiagramDemo> createState() => _TemplateDiagramDemoState();
}

class _TemplateDiagramDemoState extends State<TemplateDiagramDemo> {
  late TemplateDiagram diagram;

  @override
  void initState() {
    super.initState();
    diagram = TemplateDiagram(
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
        appBar: AppBar(
          title: Text(diagram._title),  // Access title through diagram instance
          backgroundColor: Colors.blueAccent,  // Match our frame color theme
        ),
        body: Center(
          child: diagram.buildDiagramWidget(context),
        ),
      ),
    );
  }
}

void main() {
  runApp(const TemplateDiagramDemo());
}