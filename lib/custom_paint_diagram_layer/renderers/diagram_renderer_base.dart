import 'package:flutter/material.dart';
import '../config/diagram_config.dart';
import '../coordinate_system.dart';
import '../layers/layers.dart';
import '../drawable_element.dart';
import '../elements/elements.dart';
import '../custom_paint_renderer.dart';

/// Base class for diagram renderers.
/// 
/// Provides core functionality for diagram rendering while allowing
/// specific implementations to define their own coordinate systems
/// and element creation logic.
abstract class DiagramRendererBase {
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
    final coords = createCoordinateSystem();
    
    // Create initial layer with coordinate system
    diagramLayer = BasicDiagramLayer(
      coordinateSystem: coords,
      showAxes: config.showAxes,
    );

    // Add grid if enabled
    if (config.showGrid) {
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
  /// This method preserves grid and axes while updating other elements.
  void updateElements() {
    final elements = createElements();
    
    // Remove old elements except grid and axes
    final oldElements = diagramLayer.elements
        .where((e) => e is! GridElement && e is! AxisElement)
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
  /// 
  /// Returns a new instance with the updated configuration.
  DiagramRendererBase updateConfig(DiagramConfig newConfig);
}
