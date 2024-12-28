import 'package:flutter/material.dart';
import '../config/diagram_config.dart';
import '../coordinate_system.dart';
import '../layers/layers.dart';
import '../drawable_element.dart';
import '../elements/elements.dart';
import '../custom_paint_renderer.dart';
import '../utils/diagnostic_helper.dart';

/// Base class for diagram renderers.
/// 
/// Provides core functionality for diagram rendering while allowing
/// specific implementations to define their own coordinate systems
/// and element creation logic.
abstract class DiagramRendererBase with DiagnosticHelper {
  @override
  String get diagnosticSource => 'DiagramRendererBase';

  @override
  DiagnosticCallback? get onDiagnostic => null;

  /// The diagram layer containing all elements
  late IDiagramLayer diagramLayer;
  
  /// Configuration for the diagram
  final DiagramConfig config;

  /// Creates a new diagram renderer with the given configuration
  DiagramRendererBase({
    DiagramConfig? config,
  }) : config = config ?? const DiagramConfig();

  /// Initialize the diagram
  @mustCallSuper
  void initState() {
    _initDiagram();
  }

  /// Initializes the diagram with coordinate system and basic elements
  @protected
  void _initDiagram() {
    if (isDiagnosticsEnabled) {
      reportInfo('_initDiagram', 'Initializing diagram with config', {
        'showAxes': config.showAxes,
        'showGrid': config.showGrid,
        'showFrame': config.showFrame,
      });
    }

    final coords = createCoordinateSystem();
    
    // Create initial layer with coordinate system
    diagramLayer = BasicDiagramLayer(
      coordinateSystem: coords,
      showAxes: config.showAxes,
    );

    // Add grid if enabled
    if (config.showGrid) {
      if (isDiagnosticsEnabled) reportInfo('_initDiagram', 'Adding grid element');
      diagramLayer = diagramLayer.addElement(
        GridElement(
          x: 0,
          y: 0,
          majorSpacing: 1.0,
          minorSpacing: 0.2,
          majorColor: Colors.grey.withOpacity(0.5),
          minorColor: Colors.grey.withOpacity(0.2),
        ),
      );
    }

    // Add initial elements
    updateElements();
  }

  /// Creates the coordinate system for the diagram.
  /// 
  /// Override this to define custom coordinate system properties.
  CoordinateSystem createCoordinateSystem();

  /// Creates the elements to be displayed in the diagram.
  /// 
  /// Override this to define the diagram's content.
  List<DrawableElement> createElements();

  /// Updates the diagram elements.
  /// 
  /// This method preserves axes while updating other elements.
  void updateElements() {
    if (isDiagnosticsEnabled) {
      reportInfo('updateElements', 'State changed, updating elements');
    }

    final elements = createElements();
    
    // Remove old elements except axes
    final oldElements = diagramLayer.elements
        .where((e) => e is! AxisElement)
        .toList();
    
    // Update with new elements
    diagramLayer = diagramLayer.updateDiagram(
      elementUpdates: elements,
      removeElements: oldElements,
    );
  }

  /// Builds a Flutter widget displaying the diagram.
  /// 
  /// This can be used directly in widget trees or wrapped in
  /// other widgets for additional functionality.
  Widget buildDiagramWidget(BuildContext context) {
    return CustomPaint(
      painter: CustomPaintRenderer(diagramLayer),
      size: Size(config.width, config.height),
    );
  }

  /// Updates the diagram configuration.
  void updateConfig(DiagramConfig newConfig) {
    if (isDiagnosticsEnabled) {
      reportInfo('updateConfig', 'Updating diagram configuration');
    }
    // Handle config update logic
  }

  /// Helper method to show diagram axes
  @protected
  void showDiagramAxes() {
    diagramLayer = diagramLayer.toggleAxes();
  }

  /// Helper method to hide diagram axes
  @protected
  void hideDiagramAxes() {
    if (diagramLayer.showAxes) {
      diagramLayer = diagramLayer.toggleAxes();
    }
  }
}
