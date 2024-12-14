import 'dart:ui';

import '../drawable_element.dart';
import '../coordinate_system.dart';

/// The type of Bezier curve to draw
enum BezierType {
  /// Quadratic Bezier curve with one control point
  quadratic,
  /// Cubic Bezier curve with two control points
  cubic
}

/// A drawable Bezier curve element that can create smooth curves.
class BezierCurveElement extends DrawableElement {
  /// The end point of the curve
  final Point endPoint;

  /// First control point
  final Point controlPoint1;

  /// Second control point (only used for cubic curves)
  final Point? controlPoint2;

  /// The type of Bezier curve
  final BezierType type;

  /// The width of the stroke
  final double strokeWidth;

  /// Whether to show the control points
  final bool showControlPoints;

  /// The color of the control points (if shown)
  final Color controlPointColor;

  /// The size of the control points (if shown)
  final double controlPointSize;

  /// Creates a new Bezier curve element.
  ///
  /// [x] and [y] specify the start point of the curve.
  /// [endPoint] specifies the end point.
  /// [controlPoint1] is the first control point.
  /// [controlPoint2] is only used for cubic curves (required if type is cubic).
  /// [type] determines if it's a quadratic or cubic curve.
  /// [showControlPoints] determines if control points should be visible.
  const BezierCurveElement({
    required double x,
    required double y,
    required this.endPoint,
    required this.controlPoint1,
    this.controlPoint2,
    required this.type,
    Color color = const Color(0xFF000000),
    this.strokeWidth = 1.0,
    this.showControlPoints = false,
    this.controlPointColor = const Color(0xFF888888),
    this.controlPointSize = 4.0,
  })  : assert(
          type != BezierType.cubic || controlPoint2 != null,
          'Cubic curves require a second control point',
        ),
        super(
          x: x,
          y: y,
          color: color,
        );

  @override
  void render(Canvas canvas, CoordinateSystem coordinates) {
    final startPoint = coordinates.mapValueToDiagram(x, y);
    final mappedEndPoint = coordinates.mapValueToDiagram(endPoint.x, endPoint.y);
    final mappedControlPoint1 = coordinates.mapValueToDiagram(
      controlPoint1.x,
      controlPoint1.y,
    );
    final mappedControlPoint2 = controlPoint2 != null
        ? coordinates.mapValueToDiagram(controlPoint2!.x, controlPoint2!.y)
        : null;

    // Draw the curve
    final path = Path()..moveTo(startPoint.dx, startPoint.dy);

    if (type == BezierType.quadratic) {
      path.quadraticBezierTo(
        mappedControlPoint1.dx,
        mappedControlPoint1.dy,
        mappedEndPoint.dx,
        mappedEndPoint.dy,
      );
    } else {
      path.cubicTo(
        mappedControlPoint1.dx,
        mappedControlPoint1.dy,
        mappedControlPoint2!.dx,
        mappedControlPoint2!.dy,
        mappedEndPoint.dx,
        mappedEndPoint.dy,
      );
    }

    // Draw the curve
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);

    // Draw control points and lines if enabled
    if (showControlPoints) {
      final controlPaint = Paint()
        ..color = controlPointColor
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      // Draw lines to control points
      canvas.drawLine(startPoint, mappedControlPoint1, controlPaint);
      canvas.drawLine(mappedEndPoint, mappedControlPoint1, controlPaint);
      
      if (type == BezierType.cubic && mappedControlPoint2 != null) {
        canvas.drawLine(mappedEndPoint, mappedControlPoint2, controlPaint);
      }

      // Draw control points
      final controlPointPaint = Paint()
        ..color = controlPointColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(mappedControlPoint1, controlPointSize, controlPointPaint);
      if (type == BezierType.cubic && mappedControlPoint2 != null) {
        canvas.drawCircle(mappedControlPoint2, controlPointSize, controlPointPaint);
      }
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BezierCurveElement &&
        other.x == x &&
        other.y == y &&
        other.endPoint == endPoint &&
        other.controlPoint1 == controlPoint1 &&
        other.controlPoint2 == controlPoint2 &&
        other.type == type &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.showControlPoints == showControlPoints &&
        other.controlPointColor == controlPointColor &&
        other.controlPointSize == controlPointSize;
  }

  @override
  int get hashCode => Object.hash(
        x,
        y,
        endPoint,
        controlPoint1,
        controlPoint2,
        type,
        color,
        strokeWidth,
        showControlPoints,
        controlPointColor,
        controlPointSize,
      );
}

/// A simple point class for specifying coordinates
class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Point && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);
}
