import 'package:flutter/material.dart';
import 'renderers/diagram_renderer_base.dart';
import 'renderers/diagram_controller.dart';
import 'config/diagram_config.dart';
import 'coordinate_system.dart';
import 'drawable_element.dart';
import 'elements/frame_element.dart';
import 'elements/grid_element.dart';
import 'elements/axis_element.dart';
import 'layers/layers.dart';
import 'utils/diagnostic_helper.dart';

/// Base class for diagrams that provides core functionality for handling common elements
/// like grid, axes, and frame. Concrete diagrams only need to implement diagram-specific
/// elements.
abstract class CoreDiagramBase extends DiagramRendererBase with DiagramControllerMixin, DiagnosticHelper {
  @override
  String get diagnosticSource => 'CoreDiagramBase';
  
  @override
  DiagnosticCallback? get onDiagnostic => null;

  // Canvas dimensions
  final double _canvasWidth;
  final double _canvasHeight;
  
  // Coordinate system
  final double _xRangeMin;
  final double _xRangeMax;
  final double _yRangeMin;
  final double _yRangeMax;
  final double _scale;
  final Offset _origin;
  
  // Grid attributes
  final double _gridMajorSpacing;
  final double _gridMinorSpacing;
  final Color _gridMajorColor;
  final Color _gridMinorColor;
  final double _gridMajorOpacity;
  final double _gridMinorOpacity;
  
  // Axes attributes
  final double _axisTickInterval;
  final Color _axisColor;
  
  // Frame attributes
  final Color _frameColor;
  final double _frameStrokeWidth;
  final double _frameOpacity;
  
  // Visibility flags
  bool _showAxes = false;
  bool _showGrid = false;
  bool _showFrame = false;

  CoreDiagramBase({
    required DiagramConfig config,
  }) : _canvasWidth = config.width,
       _canvasHeight = config.height,
       _xRangeMin = config.xRangeMin,
       _xRangeMax = config.xRangeMax,
       _yRangeMin = config.yRangeMin,
       _yRangeMax = config.yRangeMax,
       _scale = config.scale,
       _origin = config.origin,
       _gridMajorSpacing = 1.0,
       _gridMinorSpacing = 0.2,
       _gridMajorColor = config.gridMajorColor,
       _gridMinorColor = config.gridMinorColor,
       _gridMajorOpacity = config.gridMajorOpacity,
       _gridMinorOpacity = config.gridMinorOpacity,
       _axisTickInterval = 1.0,
       _axisColor = config.axisColor.withOpacity(config.axisOpacity),
       _frameColor = Colors.black,
       _frameStrokeWidth = 2.0,
       _frameOpacity = 1.0,
       super(config: config);

  @override
  void initState() {
    // Sync display flags with config
    _showAxes = config.showAxes;
    _showGrid = config.showGrid;
    _showFrame = config.showFrame;
    
    // Call super to initialize diagram
    super.initState();
  }

  @override
  CoordinateSystem createCoordinateSystem() {
    return CoordinateSystem(
      origin: _origin,
      xRangeMin: _xRangeMin,
      xRangeMax: _xRangeMax,
      yRangeMin: _yRangeMin,
      yRangeMax: _yRangeMax,
      scale: _scale,
    );
  }

  /// Creates the frame element for the diagram
  FrameElement createFrameElement() {
    return FrameElement(
      color: config.frameStrokeColor.withOpacity(config.frameStrokeOpacity),
      strokeWidth: config.frameStrokeWidth,
      fillColor: config.frameFill ? config.frameFillColor.withOpacity(config.frameFillOpacity) : null,
      opacity: 1.0,  // We handle opacity through the colors
    );
  }
  
  /// Creates a grid element with current grid attributes
  GridElement _createGridElement() {
    return GridElement(
      x: 0,
      y: 0,
      majorSpacing: _gridMajorSpacing,
      minorSpacing: _gridMinorSpacing,
      majorColor: _gridMajorColor,
      minorColor: _gridMinorColor,
      majorOpacity: _gridMajorOpacity,
      minorOpacity: _gridMinorOpacity,
      majorStrokeWidth: 1.0,
      minorStrokeWidth: 0.5,
      majorStyle: GridLineStyle.solid,
      minorStyle: GridLineStyle.solid,
    );
  }
  
  /// Creates X and Y axis elements with current axis attributes
  List<DrawableElement> _createAxesElements() {
    return [
      XAxisElement(
        yValue: 0,
        tickInterval: _axisTickInterval,
        color: _axisColor,
      ),
      YAxisElement(
        xValue: 0,
        tickInterval: _axisTickInterval,
        color: _axisColor,
      ),
    ];
  }

  /// Toggles axes visibility
  void toggleAxes() {
    _showAxes = !_showAxes;
    // Create new layer with updated showAxes value
    diagramLayer = BasicDiagramLayer(
      coordinateSystem: diagramLayer.coordinateSystem,
      showAxes: _showAxes,
    );
    updateElements();
  }

  /// Toggles grid visibility
  void toggleGrid() {
    _showGrid = !_showGrid;
    updateElements();
  }

  /// Toggles frame visibility
  void toggleFrame() {
    _showFrame = !_showFrame;
    updateElements();
  }

  // Getters for core properties
  double get canvasWidth => _canvasWidth;
  double get canvasHeight => _canvasHeight;
  bool get showAxes => _showAxes;
  bool get showGrid => _showGrid;
  bool get showFrame => _showFrame;
  
  // Coordinate system getters
  double get xRangeMin => _xRangeMin;
  double get xRangeMax => _xRangeMax;
  double get yRangeMin => _yRangeMin;
  double get yRangeMax => _yRangeMax;
  double get scale => _scale;

  @override
  void _initDiagram() {
    final coords = createCoordinateSystem();
    
    // Create initial layer with coordinate system
    diagramLayer = BasicDiagramLayer(
      coordinateSystem: coords,
      showAxes: config.showAxes,
    );

    // Update elements through the standard path
    updateElements();
  }

  @override
  void updateFromController() {
    updateElements();
  }

  @override
  DiagramRendererBase updateConfig(DiagramConfig newConfig) {
    throw UnimplementedError(
      'updateConfig must be implemented by concrete diagrams to handle their specific initialization'
    );
  }

  @override
  List<DrawableElement> createElements() {
    if (!isDiagnosticsEnabled) {
      return _createElementsInternal();
    }

    reportInfo('createElements', 'Creating elements', {
      'showFrame': _showFrame,
      'showGrid': _showGrid,
      'showAxes': _showAxes,
    });

    final elements = _createElementsInternal();
    reportInfo('createElements', 'Total elements created: ${elements.length}');
    return elements;
  }

  List<DrawableElement> _createElementsInternal() {
    final elements = <DrawableElement>[];

    // Add frame if enabled
    if (_showFrame) {
      if (isDiagnosticsEnabled) reportInfo('createElements', 'Adding frame element');
      elements.add(createFrameElement());
    }

    // Add grid if enabled
    if (_showGrid) {
      if (isDiagnosticsEnabled) reportInfo('createElements', 'Adding grid element');
      elements.add(_createGridElement());
    }

    // Add axes if enabled
    if (_showAxes) {
      if (isDiagnosticsEnabled) reportInfo('createElements', 'Adding axes elements');
      elements.addAll(_createAxesElements());
    }

    // Add diagram-specific elements
    elements.addAll(createDiagramElements());
    
    return elements;
  }

  /// Abstract method that concrete diagrams must implement to provide their specific elements
  List<DrawableElement> createDiagramElements();

  @override
  void updateVisibility(String key, bool isVisible) {
    if (isDiagnosticsEnabled) {
      reportInfo('updateVisibility', 'Visibility updated: $key = $isVisible');
    }
    
    switch (key) {
      case 'grid':
        _showGrid = isVisible;
        break;
      case 'axes':
        _showAxes = isVisible;
        break;
      case 'frame':
        _showFrame = isVisible;
        break;
    }
    updateElements();
  }
}
