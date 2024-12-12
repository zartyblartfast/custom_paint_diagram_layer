import 'dart:ui';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/coordinate_system.dart';

/// Abstract base class for drawable elements in the diagram.
abstract class DrawableElement {
  /// The x-coordinate of the element in diagram space
  final double x;

  /// The y-coordinate of the element in diagram space
  final double y;

  /// The color of the element
  final Color color;

  /// Constructor for initializing position coordinates and color.
  const DrawableElement({
    required this.x,
    required this.y,
    required this.color,
  });

  /// Abstract method for rendering the element.
  /// 
  /// [canvas] - The canvas to draw on
  /// [coordinateSystem] - The coordinate system to use for transformations
  void render(Canvas canvas, CoordinateSystem coordinateSystem);
}
