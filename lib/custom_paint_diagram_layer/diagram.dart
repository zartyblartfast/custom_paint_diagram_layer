import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'coordinate_system.dart';
import 'drawable_element.dart';
import 'elements/axis_element.dart';
import 'canvas_alignment.dart';

/// A diagram that manages a collection of drawable elements and coordinates their rendering.
///
/// The Diagram class is designed to be immutable, with all modification operations
/// returning new instances. This ensures thread-safety and predictable state management.
///
/// Key responsibilities:
/// * Managing the collection of drawable elements
/// * Coordinating rendering operations
/// * Handling axis visibility
/// * Maintaining immutability for state management
///
/// The diagram uses a coordinate system to transform between app-space and
/// diagram-space coordinates. All elements are positioned and rendered using
/// this coordinate system.
///
/// Example:
/// ```dart
/// final diagram = Diagram(
///   coordinateSystem: myCoordinateSystem,
///   showAxes: true,
/// )
/// .addElement(myElement)  // Returns new instance
/// .addAxesToDiagram();    // Returns new instance with axes if showAxes is true
/// ```
///
/// Note: All modification methods (addElement, removeElement, etc.) return
/// new Diagram instances rather than modifying the existing instance.
class Diagram {
  /// The coordinate system used for transformations
  final CoordinateSystem coordinateSystem;

  /// Whether to show the coordinate axes
  final bool showAxes;

  /// The list of drawable elements in the diagram
  final List<DrawableElement> elements;

  /// Creates a new diagram with the given coordinate system
  const Diagram({
    required this.coordinateSystem,
    this.showAxes = true,
    this.elements = const [],
  });

  /// Adds axis elements to the diagram if showAxes is true
  Diagram addAxesToDiagram() {
    if (!showAxes) return this;
    
    // Create temporary list for new elements
    final newElements = List<DrawableElement>.from(elements);
    
    // Add axes if they don't already exist
    if (!elements.any((e) => e is XAxisElement)) {
      newElements.add(const XAxisElement(yValue: 0));  // yValue for X-axis position
    }
    if (!elements.any((e) => e is YAxisElement)) {
      newElements.add(const YAxisElement(xValue: 0));  // xValue for Y-axis position
    }
    
    return Diagram(
      coordinateSystem: coordinateSystem,
      showAxes: showAxes,
      elements: newElements,
    );
  }

  /// Renders the diagram onto the given canvas
  void render(Canvas canvas, Size size) {
    // Create canvas alignment handler
    final alignment = CanvasAlignment(
      canvasSize: size,
      coordinateSystem: coordinateSystem,
    );
    
    // Align the coordinate system (scaling is handled within alignCenter)
    alignment.alignCenter();

    // Render all elements using the transformed coordinate system
    for (final element in elements) {
      element.render(canvas, alignment.coordinateSystem);
    }
  }

  /// Creates a new diagram with an additional element
  Diagram addElement(DrawableElement element) {
    return Diagram(
      coordinateSystem: coordinateSystem,
      showAxes: showAxes,
      elements: [...elements, element],
    );
  }

  /// Creates a new diagram with an element removed
  Diagram removeElement(DrawableElement element) {
    return Diagram(
      coordinateSystem: coordinateSystem,
      showAxes: showAxes,
      elements: elements.where((e) => e != element).toList(),
    );
  }

  /// Creates a copy of this diagram with the specified changes
  Diagram copyWith({
    CoordinateSystem? coordinateSystem,
    bool? showAxes,
    List<DrawableElement>? elements,
  }) {
    return Diagram(
      coordinateSystem: coordinateSystem ?? this.coordinateSystem,
      showAxes: showAxes ?? this.showAxes,
      elements: elements ?? this.elements,
    );
  }

  /// Creates a new diagram with axis elements removed
  Diagram _removeAxes() {
    return Diagram(
      coordinateSystem: coordinateSystem,
      showAxes: showAxes,
      elements: elements.where((e) => e is! XAxisElement && e is! YAxisElement).toList(),
    );
  }

  /// Toggles the visibility of axes
  Diagram toggleAxes() {
    // First remove any existing axes
    final withoutAxes = _removeAxes();
    // Then toggle showAxes and add new axes if needed
    return withoutAxes.copyWith(showAxes: !showAxes).addAxesToDiagram();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Diagram &&
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
