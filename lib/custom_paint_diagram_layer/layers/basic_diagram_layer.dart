import 'package:flutter/material.dart';
import '../coordinate_system.dart';
import '../drawable_element.dart';
import '../elements/axis_element.dart';
import '../canvas_alignment.dart';
import 'diagram_layer.dart';

/// Basic implementation of the diagram layer interface.
///
/// This layer provides the core diagram functionality without additional styling features.
/// It maintains the existing behavior of the diagram system while conforming to the
/// new layer interface.
///
/// Key features:
/// * Immutable state management
/// * Coordinate system transformations
/// * Basic element rendering
/// * Axis management
class BasicDiagramLayer implements IDiagramLayer {
  @override
  final CoordinateSystem coordinateSystem;

  @override
  final List<DrawableElement> elements;

  @override
  final bool showAxes;

  /// Creates a new basic diagram layer.
  /// 
  /// All parameters are immutable and changes create new instances.
  const BasicDiagramLayer({
    required this.coordinateSystem,
    this.elements = const [],
    this.showAxes = true,
  });

  @override
  IDiagramLayer updateCoordinateSystem(CoordinateSystem newSystem) {
    return copyWith(coordinateSystem: newSystem);
  }

  @override
  IDiagramLayer addElement(DrawableElement element) {
    return copyWith(
      elements: [...elements, element],
    );
  }

  @override
  IDiagramLayer removeElement(DrawableElement element) {
    return copyWith(
      elements: elements.where((e) => e != element).toList(),
    );
  }

  @override
  IDiagramLayer toggleAxes() {
    final newShowAxes = !showAxes;
    var layer = copyWith(showAxes: newShowAxes);
    return newShowAxes ? layer._addAxesToDiagram() : layer._removeAxes();
  }

  @override
  void render(Canvas canvas, Size size) {
    final alignment = CanvasAlignment(
      canvasSize: size,
      coordinateSystem: coordinateSystem,
    );
    
    alignment.alignCenter();

    for (final element in elements) {
      element.render(canvas, alignment.coordinateSystem);
    }
  }

  @override
  IDiagramLayer updateDiagram({
    List<DrawableElement> elementUpdates = const [],
    List<DrawableElement> removeElements = const [],
    CoordinateSystem? newCoordinateSystem,
  }) {
    // Start with coordinate system update if provided
    var updatedLayer = newCoordinateSystem != null
        ? updateCoordinateSystem(newCoordinateSystem)
        : this;

    // Remove elements first
    for (final element in removeElements) {
      updatedLayer = updatedLayer.removeElement(element);
    }

    // Then add/update elements
    for (final element in elementUpdates) {
      updatedLayer = updatedLayer.addElement(element);
    }

    return updatedLayer;
  }

  @override
  IDiagramLayer copyWith({
    CoordinateSystem? coordinateSystem,
    List<DrawableElement>? elements,
    bool? showAxes,
  }) {
    return BasicDiagramLayer(
      coordinateSystem: coordinateSystem ?? this.coordinateSystem,
      elements: elements ?? this.elements,
      showAxes: showAxes ?? this.showAxes,
    );
  }

  /// Internal method to add axes to the diagram
  IDiagramLayer _addAxesToDiagram() {
    if (!showAxes) return this;
    
    final newElements = List<DrawableElement>.from(elements);
    
    if (!elements.any((e) => e is XAxisElement)) {
      newElements.add(const XAxisElement(yValue: 0));
    }
    if (!elements.any((e) => e is YAxisElement)) {
      newElements.add(const YAxisElement(xValue: 0));
    }
    
    return copyWith(elements: newElements);
  }

  /// Internal method to remove axes from the diagram
  IDiagramLayer _removeAxes() {
    return copyWith(
      elements: elements.where((e) => 
        e is! XAxisElement && e is! YAxisElement
      ).toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicDiagramLayer &&
           other.coordinateSystem == coordinateSystem &&
           other.showAxes == showAxes &&
           listEquals(other.elements, elements);
  }

  @override
  int get hashCode => Object.hash(
    coordinateSystem,
    showAxes,
    Object.hashAll(elements),
  );
}
