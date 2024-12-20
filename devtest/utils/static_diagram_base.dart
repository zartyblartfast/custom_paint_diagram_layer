import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

/// A base widget for static diagram elements with standard controls and positioning.
/// 
/// Provides a standard environment with:
/// - Coordinate system with configurable range
/// - Grid and axes
/// - Element positioning with boundary constraints
abstract class StaticDiagramBase extends StatefulWidget {
  /// Title displayed in the app bar
  final String title;

  /// Range of the coordinate system in both x and y directions
  final double coordRange;

  /// Margin to maintain between elements and diagram boundaries
  final double margin;
  
  const StaticDiagramBase({
    super.key,
    required this.title,
    this.coordRange = 10.0,
    this.margin = 1.0,
  });

  @override
  StaticDiagramBaseState<StaticDiagramBase> createState();
}

/// Base state class for static diagrams.
/// 
/// Provides common functionality for diagrams:
/// - Diagram layer initialization and management
/// - Element positioning with boundary constraints
/// - Standard grid and axes setup
abstract class StaticDiagramBaseState<T extends StaticDiagramBase> extends State<T> {
  /// The diagram layer containing all elements.
  @protected
  late IDiagramLayer diagramLayer;
  
  // Private fields
  late final GridElement _grid;
  late final CoordinateSystem _coordSystem;
  bool _showAxes = true;
  
  /// Creates the diagram elements.
  @protected
  List<DrawableElement> createElements();

  /// The height of the element for boundary calculations.
  @protected
  double get elementHeight;

  /// Creates the coordinate system for the diagram.
  @protected
  CoordinateSystem createCoordinateSystem() {
    return CoordinateSystem(
      origin: Offset.zero,
      xRangeMin: -widget.coordRange,
      xRangeMax: widget.coordRange,
      yRangeMin: -widget.coordRange,
      yRangeMax: widget.coordRange,
      scale: 1.0,
    );
  }

  @override
  void initState() {
    super.initState();
    _initDiagramLayer();
  }

  void _initDiagramLayer() {
    _coordSystem = createCoordinateSystem();
    
    _grid = GridElement(
      x: 0,
      y: 0,
      majorSpacing: 1.0,
      minorSpacing: 0.2,
      majorColor: Colors.grey.withOpacity(0.5),
      minorColor: Colors.grey.withOpacity(0.2),
    );

    diagramLayer = BasicDiagramLayer(
      coordinateSystem: _coordSystem,
      showAxes: false,
    ).addElement(_grid);

    _updateElements();
  }

  void _updateElements() {
    var newLayer = BasicDiagramLayer(
      coordinateSystem: _coordSystem,
      showAxes: false,
    ).addElement(_grid);
    
    final newElements = createElements();
    for (final element in newElements) {
      newLayer = newLayer.addElement(element);
    }
    
    if (_showAxes) {
      newLayer = newLayer.toggleAxes();
    }
    
    setState(() {
      diagramLayer = newLayer;
    });
  }

  void _toggleAxes() {
    setState(() {
      _showAxes = !_showAxes;
      _updateElements();
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
      body: CustomPaint(
        painter: CustomPaintRenderer(diagramLayer),
        size: Size.infinite,
      ),
    );
  }
}