import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/layers/diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/layers/basic_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/elements.dart';

/// Base class for diagram test widgets
abstract class DiagramTestBase extends StatefulWidget {
  final String title;

  const DiagramTestBase({
    super.key,
    required this.title,
  });
}

/// Base state class for diagram tests
abstract class DiagramTestBaseState<T extends DiagramTestBase> extends State<T> {
  late IDiagramLayer diagramLayer;

  /// Height of elements in diagram units
  double get elementHeight;

  @override
  void initState() {
    super.initState();
    
    // Create coordinate system
    final coords = CoordinateSystem(
      origin: const Offset(300, 300), // Center of 600x600 container
      xRangeMin: -10,
      xRangeMax: 10,
      yRangeMin: -10,
      yRangeMax: 10,
      scale: 20, // 20 pixels per unit
    );

    // Create initial diagram layer
    diagramLayer = BasicDiagramLayer(
      coordinateSystem: coords,
      elements: createElements(0.5),
    );
  }

  /// Create elements for the diagram
  List<DrawableElement> createElements(double sliderValue);
}
