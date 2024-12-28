import 'package:flutter/material.dart';
import '../drawable_element.dart';
import '../config/diagram_config.dart';
import '../elements/rectangle_element.dart';
import '../elements/line_element.dart';       // We would create this
import 'diagram_elements_builder.dart';

/// A custom elements builder that adds rectangle and line elements
class CustomDiagramElementsBuilder extends DiagramElementsBuilder {
  final double rectangleWidth;
  final double rectangleHeight;
  final Offset lineStart;
  final Offset lineEnd;

  const CustomDiagramElementsBuilder({
    required super.config,
    required super.themeColors,
    required super.showGrid,
    required super.showFrame,
    required super.showAxes,
    required super.value,
    required this.rectangleWidth,
    required this.rectangleHeight,
    required this.lineStart,
    required this.lineEnd,
  });

  /// Creates a standard custom diagram elements builder
  static CustomDiagramElementsBuilder createStandard({
    required DiagramConfig config,
    required Map<String, Color> themeColors,
    required double value,
    bool showGrid = true,
    bool showFrame = true,
    bool showAxes = true,
    double rectangleWidth = 2.0,
    double rectangleHeight = 1.0,
    Offset lineStart = const Offset(-2, -2),
    Offset lineEnd = const Offset(2, 2),
  }) {
    return CustomDiagramElementsBuilder(
      config: config,
      themeColors: themeColors,
      showGrid: showGrid,
      showFrame: showFrame,
      showAxes: showAxes,
      value: value,
      rectangleWidth: rectangleWidth,
      rectangleHeight: rectangleHeight,
      lineStart: lineStart,
      lineEnd: lineEnd,
    );
  }

  @override
  List<DrawableElement> buildElements() {
    // Get base elements (background, grid, standard elements)
    final elements = super.buildElements();
    
    // Add rectangle element
    elements.add(RectangleElement(
      x: -1.0,  // Center the rectangle
      y: -0.5,
      width: rectangleWidth,
      height: rectangleHeight,
      color: themeColors['element']!,
      fillColor: themeColors['elementFill']!,
      fillOpacity: 0.2,
      borderRadius: 0.2,
    ));

    // Add line element (once we create it)
    // elements.add(LineElement(
    //   start: lineStart,
    //   end: lineEnd,
    //   color: themeColors['element']!,
    // ));

    reportInfo('buildElements', 'Added custom elements: rectangle');
    return elements;
  }
}
