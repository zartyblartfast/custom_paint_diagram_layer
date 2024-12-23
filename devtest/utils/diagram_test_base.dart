import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

/// A base widget for testing diagram elements with standard controls and positioning.
/// 
/// Provides a standard test environment with:
/// - Coordinate system with configurable range
/// - Grid and axes
/// - Element positioning with boundary constraints
/// - Slider control for element movement
abstract class DiagramTestBase extends StatefulWidget {
  /// Title displayed in the app bar
  final String title;

  /// Range of the coordinate system in both x and y directions
  final double coordRange;

  /// Margin to maintain between elements and diagram boundaries
  final double margin;
  
  const DiagramTestBase({
    super.key,
    required this.title,
    this.coordRange = 10.0,
    this.margin = 1.0,
  });

  @override
  DiagramTestBaseState<DiagramTestBase> createState();
}

/// Base state class for diagram tests.
/// 
/// Provides common functionality for diagram testing:
/// - Diagram layer initialization and management
/// - Element positioning with boundary constraints
/// - Standard grid and axes setup
/// - Slider control for element movement
/// 
/// Subclasses must implement:
/// - [createElements] to provide the elements to display
/// - [elementHeight] to specify the height for boundary calculations
abstract class DiagramTestBaseState<T extends DiagramTestBase> extends State<T> {
  /// The diagram layer containing all elements.
  /// 
  /// Available for subclasses to access coordinate system information.
  /// Do not modify elements directly; use [createElements] instead.
  @protected
  late IDiagramLayer diagramLayer;
  
  // Private fields
  double _sliderValue = 0.0;
  late final GridElement _grid;
  late final CoordinateSystem _coordSystem;
  bool _showAxes = true;  // Track axes visibility state
  
  /// Creates the diagram elements for testing.
  /// 
  /// Implement this to return the list of elements to be displayed in the diagram.
  @protected
  List<DrawableElement> createElements(double sliderValue);

  /// The height of the element for boundary calculations.
  @protected
  double get elementHeight;

  /// Creates the coordinate system for the diagram.
  /// 
  /// Override this method to customize the coordinate system layout.
  /// The default implementation creates a standard Cartesian system
  /// with the origin at the center.
  /// 
  /// Example for engineering-style coordinates:
  /// ```dart
  /// @override
  /// CoordinateSystem createCoordinateSystem() {
  ///   return CoordinateSystem(
  ///     origin: Offset.zero,
  ///     xRangeMin: -widget.coordRange,
  ///     xRangeMax: widget.coordRange,
  ///     yRangeMin: 0,  // Y starts at 0 (bottom)
  ///     yRangeMax: widget.coordRange * 2,  // Double range for positive Y
  ///     scale: 1.0,
  ///   );
  /// }
  /// ```
  @protected
  CoordinateSystem createCoordinateSystem() {
    return CoordinateSystem(
      origin: Offset.zero,  // Will be set by CanvasAlignment
      xRangeMin: -widget.coordRange,
      xRangeMax: widget.coordRange,
      yRangeMin: -widget.coordRange,
      yRangeMax: widget.coordRange,
      scale: 1.0,  // Will be adjusted by CanvasAlignment
    );
  }

  @override
  void initState() {
    super.initState();
    print('DiagramTestBaseState.initState()');
    _initDiagramLayer();
  }

  void _initDiagramLayer() {
    print('DiagramTestBaseState._initDiagramLayer()');
    
    // Create coordinate system first
    _coordSystem = createCoordinateSystem();
    print('Created coordinate system: range = ±${widget.coordRange}');
    
    // Create standard grid
    _grid = GridElement(
      x: 0,
      y: 0,
      majorSpacing: 1.0,
      minorSpacing: 0.2,
      majorColor: Colors.grey.withOpacity(0.5),
      minorColor: Colors.grey.withOpacity(0.2),
    );
    print('Created grid element: ${_grid.runtimeType}');

    // Initialize diagram layer with grid
    diagramLayer = BasicDiagramLayer(
      coordinateSystem: _coordSystem,
      showAxes: false,  // Start with axes off, will toggle on below
    ).addElement(_grid);
    print('Created BasicDiagramLayer');

    // Add initial test elements and toggle axes if needed
    _updateElements(_sliderValue);
  }

  void _updateElements(double sliderValue) {
    print('\nUpdating elements for sliderValue: $sliderValue');
    
    // Start with a fresh layer containing just the grid
    var newLayer = BasicDiagramLayer(
      coordinateSystem: _coordSystem,
      showAxes: false,  // Start with axes off, will toggle if needed
    ).addElement(_grid);
    print('Created new layer with grid');
    
    // Add test-specific elements
    final newElements = createElements(sliderValue);
    for (final element in newElements) {
      // Calculate bounds for diagnostic purposes
      final bounds = ElementBounds(element, _coordSystem);
      
      // Add the element
      newLayer = newLayer.addElement(element);
      print('Added element: ${element.runtimeType}');
      
      // Print boundary information if outside bounds
      if (bounds.isOutsideDiagramBounds()) {
        print('Warning: Element is outside diagram bounds');
        final violations = bounds.getBoundaryViolations();
        violations.forEach((edge, amount) {
          if (amount > 0) {
            print('  $edge boundary violated by $amount units');
          }
        });
      }
    }
    
    // Toggle axes if needed
    if (_showAxes) {
      newLayer = newLayer.toggleAxes();
      print('Toggled axes on');
    }
    
    // Update state
    setState(() {
      diagramLayer = newLayer;
    });
    
    print('Diagram layer element count: ${diagramLayer.elements.length}');
    print('Coordinate system state:');
    print('- Origin: ${_coordSystem.origin}');
    print('- Scale: ${_coordSystem.scale}');
    print('- X range: ${_coordSystem.xRangeMin} to ${_coordSystem.xRangeMax}');
    print('- Y range: ${_coordSystem.yRangeMin} to ${_coordSystem.yRangeMax}');
  }

  void _updateSliderPosition(double newValue) {
    print('\nDiagramTestBaseState._updateSliderPosition(newValue: $newValue)');
    _sliderValue = newValue;
    _updateElements(newValue);
  }

  void _toggleAxes() {
    print('\nToggling axes visibility');
    setState(() {
      _showAxes = !_showAxes;
      _updateElements(_sliderValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(_showAxes ? Icons.grid_off : Icons.grid_on),
            onPressed: _toggleAxes,
            tooltip: 'Toggle Axes',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomPaint(
              painter: CustomPaintRenderer(diagramLayer),
              size: Size.infinite,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Position'),
                Expanded(
                  child: Slider(
                    value: _sliderValue,
                    onChanged: _updateSliderPosition,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
