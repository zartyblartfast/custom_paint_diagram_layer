import 'package:flutter/material.dart';
import '../coordinate_system.dart';
import '../drawable_element.dart';

/// Base interface for diagram layers.
///
/// The diagram layer is the core concept of this system - it's responsible for
/// creating, managing, and dynamically updating diagrams. All diagram operations
/// must go through a diagram layer to ensure consistent behavior and state management.
///
/// Key responsibilities:
/// * Managing the diagram's coordinate system
/// * Handling element addition and removal
/// * Coordinating rendering operations
/// * Managing diagram state and updates
/// * Maintaining immutability for predictable state management
abstract class IDiagramLayer {
  /// The coordinate system used for transformations
  CoordinateSystem get coordinateSystem;

  /// The current elements in the diagram
  List<DrawableElement> get elements;

  /// Whether coordinate axes are shown
  bool get showAxes;

  /// Creates a new layer with an updated coordinate system.
  /// 
  /// This operation returns a new instance, maintaining immutability.
  IDiagramLayer updateCoordinateSystem(CoordinateSystem newSystem);

  /// Adds an element to the diagram.
  /// 
  /// Returns a new layer instance with the element added.
  /// All element additions must go through this method to ensure
  /// proper diagram state management.
  IDiagramLayer addElement(DrawableElement element);

  /// Removes an element from the diagram.
  /// 
  /// Returns a new layer instance with the element removed.
  IDiagramLayer removeElement(DrawableElement element);

  /// Toggles the visibility of coordinate axes.
  /// 
  /// Returns a new layer instance with updated axis visibility.
  IDiagramLayer toggleAxes();

  /// Renders the diagram onto the given canvas.
  /// 
  /// This method handles all aspects of rendering, including:
  /// * Coordinate system alignment
  /// * Element transformation
  /// * Proper render order
  void render(Canvas canvas, Size size);

  /// Updates the diagram based on external inputs.
  /// 
  /// This is the primary method for handling dynamic updates to the diagram.
  /// Returns a new layer instance with the updates applied.
  /// 
  /// Example:
  /// ```dart
  /// // Update diagram based on new data
  /// layer = layer.updateDiagram(
  ///   elementUpdates: [newElement],
  ///   removeElements: [oldElement],
  /// );
  /// ```
  IDiagramLayer updateDiagram({
    List<DrawableElement> elementUpdates = const [],
    List<DrawableElement> removeElements = const [],
    CoordinateSystem? newCoordinateSystem,
  });

  /// Creates a copy of this layer with the specified changes.
  /// 
  /// This is the base method for all immutable updates to the layer.
  IDiagramLayer copyWith({
    CoordinateSystem? coordinateSystem,
    List<DrawableElement>? elements,
    bool? showAxes,
  });
}
