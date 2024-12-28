import 'package:flutter/material.dart';
import '../renderers/diagram_renderer_base.dart';
import '../config/diagram_config.dart';
import '../drawable_element.dart';
import '../elements/grid_element.dart';
import '../elements/frame_element.dart';
import '../elements/axis_element.dart';
import '../coordinate_system.dart';
import '../layers/basic_diagram_layer.dart';
import 'diagram_state_manager.dart';
import '../utils/diagnostic_helper.dart';
import '../elements/axis_element.dart';

/// Base class for diagrams that use the new state management system.
/// This class provides the same functionality as CoreDiagramBase but with improved
/// state management. Existing diagrams can continue to use CoreDiagramBase while
/// new diagrams can use this class.
abstract class StateManagedDiagramBase extends DiagramRendererBase with DiagnosticHelper {
  @override
  String get diagnosticSource => 'StateManagedDiagramBase';

  @override
  DiagnosticCallback? get onDiagnostic => null;

  /// The state manager for this diagram
  final DiagramStateManager state;

  /// Creates a new state-managed diagram
  StateManagedDiagramBase({
    required DiagramConfig config,
  }) : state = DiagramStateManager(),
       super(config: config) {
    // Listen for state changes
    state.addListener(_onStateChanged);
    
    // Initialize state
    initState();
  }

  @override
  void initState() {
    // Initialize diagram layer
    diagramLayer = BasicDiagramLayer(
      coordinateSystem: createCoordinateSystem(),
      elements: createElements(),
      showAxes: state.showAxes,  // Pass initial axes state
    );
    
    // Set initial visibility states from config
    state.updateVisibility(DiagramStateManager.kGrid, config.showGrid);
    state.updateVisibility(DiagramStateManager.kFrame, config.showFrame);
    state.updateVisibility(DiagramStateManager.kAxes, config.showAxes);
  }

  @override
  void dispose() {
    state.removeListener(_onStateChanged);
    state.dispose();
  }

  /// Called when state changes
  void _onStateChanged() {
    if (isDiagnosticsEnabled) {
      reportInfo('_onStateChanged', 'State changed, updating elements');
    }

    // Update diagram layer with new elements and state
    diagramLayer = BasicDiagramLayer(
      coordinateSystem: createCoordinateSystem(),
      elements: createElements(),
      showAxes: state.showAxes,  // Pass the current axes state
    );
    updateElements();
  }

  /// Toggle axes visibility
  void toggleAxes() {
    if (isDiagnosticsEnabled) {
      reportInfo('toggleAxes', 'Axes visibility changed: ${!state.showAxes}');
    }
    state.toggleVisibility(DiagramStateManager.kAxes);
  }

  /// Toggle frame visibility
  void toggleFrame() {
    if (isDiagnosticsEnabled) {
      reportInfo('toggleFrame', 'Frame visibility changed: ${!state.showFrame}');
    }
    state.toggleVisibility(DiagramStateManager.kFrame);
  }

  /// Toggle grid visibility
  void toggleGrid() {
    if (isDiagnosticsEnabled) {
      reportInfo('toggleGrid', 'Grid visibility changed: ${!state.showGrid}');
    }
    state.toggleVisibility(DiagramStateManager.kGrid);
  }

  // Expose visibility states
  bool get showGrid => state.showGrid;
  bool get showFrame => state.showFrame;
  bool get showAxes => state.showAxes;

  @override
  List<DrawableElement> createElements() {
    if (!isDiagnosticsEnabled) {
      return _createElementsInternal();
    }

    reportInfo('createElements', 'Creating elements', {
      'showFrame': state.showFrame,
      'showGrid': state.showGrid,
      'showAxes': state.showAxes,
    });

    final elements = _createElementsInternal();
    reportInfo('createElements', 'Total elements created: ${elements.length}');
    return elements;
  }

  List<DrawableElement> _createElementsInternal() {
    final elements = <DrawableElement>[];
    
    // Add frame (if enabled) - should be first to be behind other elements
    if (state.showFrame) {
      if (isDiagnosticsEnabled) reportInfo('createElements', 'Adding frame element');
      elements.add(createFrameElement());
    }
    
    // Add grid (if enabled)
    if (state.showGrid) {
      if (isDiagnosticsEnabled) reportInfo('createElements', 'Adding grid element');
      elements.add(createGridElement());
    }
    
    // Add axes (if enabled)
    if (state.showAxes) {
      if (isDiagnosticsEnabled) reportInfo('createElements', 'Adding axes elements');
      elements.addAll(createAxisElements());
    }
    
    // Add diagram-specific elements
    elements.addAll(createDiagramElements());
    
    return elements;
  }

  /// Create grid element
  GridElement createGridElement() {
    return GridElement(
      x: 0,
      y: 0,
      majorSpacing: 1.0,
      minorSpacing: 0.2,
      majorColor: Colors.grey.withOpacity(0.5),
      minorColor: Colors.grey.withOpacity(0.2),
    );
  }

  /// Create frame element
  FrameElement createFrameElement() {
    return FrameElement(
      color: Colors.black,
      strokeWidth: 2.0,
    );
  }

  /// Create axis elements
  List<AxisElement> createAxisElements() {
    return [
      XAxisElement(
        yValue: 0,
        tickInterval: 1.0,
        color: Colors.black,
      ),
      YAxisElement(
        xValue: 0,
        tickInterval: 1.0,
        color: Colors.black,
      ),
    ];
  }

  /// Create diagram-specific elements
  List<DrawableElement> createDiagramElements();

  @override
  CoordinateSystem createCoordinateSystem() {
    return CoordinateSystem(
      xRangeMin: config.xRangeMin,
      xRangeMax: config.xRangeMax,
      yRangeMin: config.yRangeMin,
      yRangeMax: config.yRangeMax,
      origin: config.origin,
      scale: config.scale,
    );
  }

  @override
  DiagramRendererBase updateConfig(DiagramConfig newConfig) {
    // Since we can't instantiate an abstract class, we'll return this
    // with the understanding that config updates may need manual handling
    // in derived classes
    updateElements();
    return this;
  }

  /// Get the canvas width from config
  double get canvasWidth => config.width;

  /// Get the canvas height from config
  double get canvasHeight => config.height;
}
