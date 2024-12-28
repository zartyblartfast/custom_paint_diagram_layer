import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

/// A builder class that simplifies diagram creation by providing
/// a fluent interface and sensible defaults.
class DiagramBuilder {
  DiagramConfig _config;
  List<DrawableElement> _elements = [];
  Map<String, bool> _visibility = {};
  Map<String, dynamic> _controls = {};

  DiagramBuilder()
      : _config = const DiagramConfig();

  /// Set the canvas size
  DiagramBuilder withSize(double width, double height) {
    _config = _config.copyWith(width: width, height: height);
    return this;
  }

  /// Set the coordinate system range
  DiagramBuilder withRange({
    double? xMin,
    double? xMax,
    double? yMin,
    double? yMax,
  }) {
    _config = _config.copyWith(
      xRangeMin: xMin,
      xRangeMax: xMax,
      yRangeMin: yMin,
      yRangeMax: yMax,
    );
    return this;
  }

  /// Add elements to the diagram
  DiagramBuilder addElements(List<DrawableElement> elements) {
    _elements.addAll(elements);
    return this;
  }

  /// Set visibility states
  DiagramBuilder withVisibility({
    bool showGrid = true,
    bool showFrame = true,
    bool showAxes = true,
  }) {
    _config = _config.copyWith(
      showGrid: showGrid,
      showFrame: showFrame,
      showAxes: showAxes,
    );
    return this;
  }

  /// Build the diagram
  StateManagedDiagramBase build() {
    return _BuiltDiagram(
      config: _config,
      initialElements: _elements,
      visibility: _visibility,
      controls: _controls,
    );
  }
}

/// Internal implementation of a built diagram
class _BuiltDiagram extends StateManagedDiagramBase {
  final List<DrawableElement> initialElements;
  final Map<String, bool> visibility;
  final Map<String, dynamic> controls;

  _BuiltDiagram({
    required super.config,
    required this.initialElements,
    required this.visibility,
    required this.controls,
  }) {
    // Register custom visibility states
    visibility.forEach((key, value) {
      state.registerVisibility(key, value);
    });
  }

  @override
  List<DrawableElement> createDiagramElements() {
    return List.from(initialElements);
  }
}
