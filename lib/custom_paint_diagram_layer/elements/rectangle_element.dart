import 'package:flutter/material.dart';
import '../coordinate_system.dart';
import '../drawable_element.dart';

/// Represents a rectangle in the diagram.
/// 
/// The rectangle can be positioned either by its center point or its top-left corner.
/// For backward compatibility, top-left positioning is the default mode.
/// New code should prefer center-referenced positioning for consistency with other elements.
class RectangleElement extends DrawableElement {
  /// The width of the rectangle
  final double width;

  /// The height of the rectangle
  final double height;

  /// The width of the stroke used to draw the rectangle
  final double strokeWidth;

  /// The fill color of the rectangle. If null, the rectangle will not be filled.
  final Color? fillColor;

  /// The opacity of the fill, ranging from 0.0 (fully transparent) to 1.0 (fully opaque).
  /// Only used when fillColor is not null.
  final double fillOpacity;

  /// The radius of the rectangle's corners. If null, sharp corners will be drawn.
  final double? borderRadius;

  /// Whether the rectangle's position (x, y) refers to its center point.
  /// If false (default), the position refers to the top-left corner.
  final bool centerReferenced;

  /// Creates a new rectangle element.
  /// 
  /// By default, the rectangle's top-left corner is at (x, y) with the specified width and height.
  /// If centerReferenced is true, (x, y) specifies the center point instead.
  /// The color parameter is used to set the rectangle's stroke color.
  /// The strokeWidth parameter sets the thickness of the rectangle's border (defaults to 1.0).
  /// The fillColor parameter, if provided, fills the rectangle with that color.
  /// The fillOpacity parameter controls the transparency of the fill (defaults to 1.0).
  /// The borderRadius parameter, if provided, creates rounded corners with the specified radius.
  const RectangleElement({
    required double x,
    required double y,
    required this.width,
    required this.height,
    required Color color,
    this.strokeWidth = 1.0,
    this.fillColor,
    this.fillOpacity = 1.0,
    this.borderRadius,
    this.centerReferenced = false,
  }) : assert(fillOpacity >= 0.0 && fillOpacity <= 1.0),
       assert(borderRadius == null || borderRadius >= 0.0),
       super(x: x, y: y, color: color);

  /// Creates a background rectangle element.
  /// 
  /// This factory always uses top-left positioning and is intended for
  /// creating background elements that fill a specific region.
  factory RectangleElement.background({
    required double x,
    required double y,
    required double width,
    required double height,
    required Color color,
    Color? fillColor,
    double strokeWidth = 0.0,
  }) {
    return RectangleElement(
      x: x,
      y: y,
      width: width,
      height: height,
      color: color,
      fillColor: fillColor ?? color,
      strokeWidth: strokeWidth,
      centerReferenced: false,  // Always use top-left for backgrounds
    );
  }

  /// Creates a centered rectangle element.
  /// 
  /// This factory uses center positioning and is the recommended way
  /// to create new rectangle elements.
  factory RectangleElement.centered({
    required double centerX,
    required double centerY,
    required double width,
    required double height,
    required Color color,
    Color? fillColor,
    double strokeWidth = 1.0,
    double fillOpacity = 1.0,
    double? borderRadius,
  }) {
    return RectangleElement(
      x: centerX,
      y: centerY,
      width: width,
      height: height,
      color: color,
      fillColor: fillColor,
      strokeWidth: strokeWidth,
      fillOpacity: fillOpacity,
      borderRadius: borderRadius,
      centerReferenced: true,
    );
  }

  @override
  void render(Canvas canvas, CoordinateSystem coordinateSystem) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Calculate position based on reference mode
    final double renderX = centerReferenced ? x - width / 2 : x;
    final double renderY = centerReferenced ? y - height / 2 : y;

    // Get the top-left corner in diagram coordinates
    final topLeft = coordinateSystem.mapValueToDiagram(renderX, renderY);
    
    // Calculate the bottom-right point in value coordinates
    final bottomRight = coordinateSystem.mapValueToDiagram(
      renderX + width,
      renderY + height,
    );

    // Create the rectangle from the two points
    final rect = Rect.fromPoints(topLeft, bottomRight);

    // Draw fill if fillColor is provided
    if (fillColor != null) {
      final fillPaint = Paint()
        ..color = fillColor!.withOpacity(fillOpacity)
        ..style = PaintingStyle.fill;
      
      if (borderRadius != null) {
        final scaledRadius = borderRadius! * coordinateSystem.scale;
        final rrect = RRect.fromRectAndRadius(rect, Radius.circular(scaledRadius));
        canvas.drawRRect(rrect, fillPaint);
      } else {
        canvas.drawRect(rect, fillPaint);
      }
    }
    
    // Draw stroke
    if (borderRadius != null) {
      final scaledRadius = borderRadius! * coordinateSystem.scale;
      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(scaledRadius));
      canvas.drawRRect(rrect, paint);
    } else {
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RectangleElement &&
           other.x == x &&
           other.y == y &&
           other.width == width &&
           other.height == height &&
           other.color == color &&
           other.strokeWidth == strokeWidth &&
           other.fillColor == fillColor &&
           other.fillOpacity == fillOpacity &&
           other.borderRadius == borderRadius &&
           other.centerReferenced == centerReferenced;
  }

  @override
  int get hashCode => Object.hash(
    x, y, width, height, color, strokeWidth, 
    fillColor, fillOpacity, borderRadius, centerReferenced
  );
}
