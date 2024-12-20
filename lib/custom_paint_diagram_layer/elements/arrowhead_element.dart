import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

import '../coordinate_system.dart';
import 'drawable_element.dart';

/// An element that draws just an arrowhead without a line
class ArrowheadElement extends DrawableElement {
  final double x;
  final double y;
  final double angle;
  final double headLength;
  final double headAngle;
  final double strokeWidth;

  ArrowheadElement({
    required this.x,
    required this.y,
    required this.angle,
    this.headLength = 20.0,
    this.headAngle = math.pi / 6, // 30 degrees
    Color color = const Color(0xFF000000),
    this.strokeWidth = 1.0,
  }) : super(
          x: x,
          y: y,
          color: color,
        );

  @override
  void render(Canvas canvas, CoordinateSystem coordinates) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill;

    // Convert point to canvas coordinates
    final point = coordinates.mapValueToDiagram(x, y);
    
    // Convert head length from diagram coordinates to pixel space
    final pixelHeadLength = headLength * coordinates.scale;

    // Calculate arrowhead points
    final leftPoint = Offset(
      point.dx - pixelHeadLength * math.cos(angle + headAngle),
      point.dy - pixelHeadLength * math.sin(angle + headAngle),
    );
    
    final rightPoint = Offset(
      point.dx - pixelHeadLength * math.cos(angle - headAngle),
      point.dy - pixelHeadLength * math.sin(angle - headAngle),
    );

    // Draw filled arrowhead
    final path = Path()
      ..moveTo(point.dx, point.dy)
      ..lineTo(leftPoint.dx, leftPoint.dy)
      ..lineTo(rightPoint.dx, rightPoint.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  Rect getBounds() {
    // Convert head length from diagram coordinates to pixel space
    final pixelHeadLength = headLength * 1.0; // Use base scale

    // Calculate maximum extent of arrowhead
    final extent = pixelHeadLength * math.cos(headAngle);
    
    return Rect.fromCenter(
      center: Offset(x, y),
      width: extent * 2,
      height: extent * 2,
    );
  }
}
