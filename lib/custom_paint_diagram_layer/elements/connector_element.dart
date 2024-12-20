import 'dart:math' show Point, pi;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../coordinate_system.dart';
import '../drawable_element.dart';
import 'arrowhead_element.dart';
import 'line_element.dart';
import 'arrow_element.dart';
import 'bezier_curve_element.dart' show Point;
import 'group_element.dart';
import 'rectangle_element.dart';

/// Define socket positions (T, B, L, R for each rectangle)
enum Socket { T, B, L, R }

/// Specifies how the connector should be routed between points
enum ConnectorRouting {
  /// Direct line between points
  direct,
  /// Orthogonal routing with right angles
  orthogonal,
}

/// Defines the style of the connector endpoints
enum ConnectorEndpoint {
  /// No decoration
  none,
  /// Arrow head
  arrow,
  /// Filled circle
  dot,
  /// Diamond shape
  diamond,
}

/// A connector element that can connect between two points with various styles
/// and routing options. Can be used to create flowchart connections, system
/// diagram links, etc.
class ConnectorElement extends DrawableElement {
  /// Start point of the connector in logical coordinates
  final Point start;
  
  /// End point of the connector in logical coordinates
  final Point end;
  
  /// How the connector should be routed between points
  final ConnectorRouting routing;
  
  /// Style for the start of the connector
  final ConnectorEndpoint startEndpoint;
  
  /// Style for the end of the connector
  final ConnectorEndpoint endEndpoint;
  
  /// Width of the connector line
  final double strokeWidth;
  
  /// Whether to use dashed lines
  final bool dashed;
  
  /// Length of dashes if dashed is true
  final double dashLength;
  
  /// Length of gaps between dashes if dashed is true
  final double gapLength;

  /// Length of arrowhead in logical coordinates
  final double arrowheadLength;

  /// Creates a new connector element
  ConnectorElement({
    required this.start,
    required this.end,
    this.routing = ConnectorRouting.direct,
    this.startEndpoint = ConnectorEndpoint.none,
    this.endEndpoint = ConnectorEndpoint.none,
    this.strokeWidth = 1.0,
    this.dashed = false,
    this.dashLength = 5.0,
    this.gapLength = 5.0,
    this.arrowheadLength = 0.1,
    Color color = Colors.black,
  }) : super(
          x: start.x.toDouble(),
          y: start.y.toDouble(),
          color: color,
        );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConnectorElement &&
           other.start == start &&
           other.end == end &&
           other.routing == routing &&
           other.startEndpoint == startEndpoint &&
           other.endEndpoint == endEndpoint &&
           other.strokeWidth == strokeWidth &&
           other.dashed == dashed &&
           other.dashLength == dashLength &&
           other.gapLength == gapLength &&
           other.arrowheadLength == arrowheadLength &&
           other.color == color;
  }

  @override
  int get hashCode => Object.hash(
    start,
    end,
    routing,
    startEndpoint,
    endEndpoint,
    strokeWidth,
    dashed,
    dashLength,
    gapLength,
    arrowheadLength,
    color,
  );

  @override
  void render(Canvas canvas, CoordinateSystem coordinates) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Map points to canvas coordinates
    final startPoint = coordinates.mapValueToDiagram(start.x.toDouble(), start.y.toDouble());
    final endPoint = coordinates.mapValueToDiagram(end.x.toDouble(), end.y.toDouble());

    // Draw the connector based on routing style
    switch (routing) {
      case ConnectorRouting.direct:
        _renderDirect(canvas, coordinates, startPoint, endPoint, paint);
        break;
      case ConnectorRouting.orthogonal:
        _renderOrthogonal(canvas, coordinates, startPoint, endPoint, paint);
        break;
    }

    // Draw start endpoint decoration
    if (startEndpoint != ConnectorEndpoint.none) {
      _renderEndpoint(
        canvas, 
        coordinates, 
        startPoint, 
        endPoint, 
        startEndpoint, 
        paint,
        isStart: true,
      );
    }

    // Draw end endpoint decoration
    if (endEndpoint != ConnectorEndpoint.none) {
      _renderEndpoint(
        canvas, 
        coordinates, 
        startPoint, 
        endPoint, 
        endEndpoint, 
        paint,
        isStart: false,
      );
    }
  }

  void _renderDirect(
    Canvas canvas,
    CoordinateSystem coordinates,
    Offset start,
    Offset end,
    Paint paint,
  ) {
    if (dashed) {
      _drawDashedLine(canvas, start, end, paint);
    } else {
      canvas.drawLine(start, end, paint);
    }
  }

  void _renderOrthogonal(
    Canvas canvas,
    CoordinateSystem coordinates,
    Offset start,
    Offset end,
    Paint paint,
  ) {
    // Calculate midpoint for orthogonal routing
    final mid = Offset(
      start.dx + (end.dx - start.dx) / 2,
      start.dy + (end.dy - start.dy) / 2,
    );

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(mid.dx, start.dy)
      ..lineTo(mid.dx, end.dy)
      ..lineTo(end.dx, end.dy);

    if (dashed) {
      // Convert path to a series of points and draw dashed lines
      // This is a simplified version - would need more complex logic
      // to properly dash around corners
      canvas.drawPath(path, paint);
    } else {
      canvas.drawPath(path, paint);
    }
  }

  void _renderEndpoint(
    Canvas canvas,
    CoordinateSystem coordinates,
    Offset canvasStart,
    Offset canvasEnd,
    ConnectorEndpoint style,
    Paint paint, {
    required bool isStart,
  }) {
    if (style == ConnectorEndpoint.arrow) {
      // Create a temporary arrow element for rendering just the arrowhead
      final arrow = ArrowElement(
        x1: isStart ? canvasStart.dx : canvasEnd.dx,
        y1: isStart ? canvasStart.dy : canvasEnd.dy,
        x2: isStart ? canvasEnd.dx : canvasStart.dx,
        y2: isStart ? canvasEnd.dy : canvasStart.dy,
        color: color,
        strokeWidth: strokeWidth,
        style: ArrowStyle.filled,
        headLength: arrowheadLength,
      );
      arrow.renderArrowhead(canvas, coordinates, canvasStart, canvasEnd);
    } else {
      // Implement other endpoint styles (dot, diamond) here
      // ...
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    final path = Path()
      ..moveTo(start.dx, start.dy);

    final distance = (end - start).distance;
    final direction = (end - start) / distance;
    var currentDistance = 0.0;

    while (currentDistance < distance) {
      final dashEnd = currentDistance + dashLength;
      if (dashEnd > distance) {
        path.lineTo(end.dx, end.dy);
        break;
      }

      final dashEndPoint = start + direction * dashEnd;
      path.lineTo(dashEndPoint.dx, dashEndPoint.dy);

      final gapEnd = dashEnd + gapLength;
      if (gapEnd > distance) {
        break;
      }

      final gapEndPoint = start + direction * gapEnd;
      path.moveTo(gapEndPoint.dx, gapEndPoint.dy);

      currentDistance = gapEnd;
    }

    canvas.drawPath(path, paint);
  }

  @override
  Rect getBounds() {
    final startPoint = Point(start.x.toDouble(), start.y.toDouble());
    final endPoint = Point(end.x.toDouble(), end.y.toDouble());

    final left = [startPoint.x, endPoint.x].reduce((a, b) => a < b ? a : b);
    final top = [startPoint.y, endPoint.y].reduce((a, b) => a < b ? a : b);
    final right = [startPoint.x, endPoint.x].reduce((a, b) => a > b ? a : b);
    final bottom = [startPoint.y, endPoint.y].reduce((a, b) => a > b ? a : b);

    // Add padding for arrow heads or other decorations
    const padding = 10.0;
    return Rect.fromLTRB(
      left - padding,
      top - padding,
      right + padding,
      bottom + padding,
    );
  }

  /// Calculates connection points between two grouped rectangles in DL coordinates
  /// Returns the start and end points for the connector
  static (Point start, Point end) calculateConnectionPoints({
    required GroupElement startGroup,
    required Socket startSocket,
    required GroupElement endGroup,
    required Socket endSocket,
    required CoordinateSystem coordSystem,
  }) {
    // Find the rectangle elements in each group
    final startRect = startGroup.children.whereType<RectangleElement>().first;
    final endRect = endGroup.children.whereType<RectangleElement>().first;

    // Calculate connection points based on socket positions
    final start = _getSocketPoint(startGroup, startSocket);
    final end = _getSocketPoint(endGroup, endSocket);

    return (start, end);
  }

  /// Calculate the connection point for a given socket using rectangle properties
  static Point _getSocketPoint(GroupElement group, Socket socket) {
    // The group position IS the socket position
    switch (socket) {
      case Socket.L:
        return Point(group.x - 1, group.y);
      case Socket.R:
        return Point(group.x + 1, group.y);
      case Socket.T:
        return Point(group.x, group.y + 0.5);  // Move up from group y by offset
      case Socket.B:
        return Point(group.x, group.y - 0.5);  // Move down from group y by offset
    }
  }
}