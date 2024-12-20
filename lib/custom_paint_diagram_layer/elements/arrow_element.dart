import 'dart:math' as math;
import 'dart:ui';

import '../drawable_element.dart';
import '../coordinate_system.dart';

/// Defines different styles of arrowheads
enum ArrowStyle {
  /// Classic V-shaped arrowhead (open)
  open,
  /// Filled triangular arrowhead
  filled,
  /// Square bracket style
  bracket,
  /// Circle end (dot)
  dot,
  /// Diamond shaped
  diamond
}

class ArrowElement extends DrawableElement {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final double headLength;
  final double headAngle;
  final double strokeWidth;
  final ArrowStyle style;

  ArrowElement({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    this.headLength = 20.0,
    this.headAngle = math.pi / 6, // 30 degrees
    Color color = const Color(0xFF000000),
    this.strokeWidth = 1.0,
    this.style = ArrowStyle.open,
  }) : super(
          x: x1,
          y: y1,
          color: color,
        );

  @override
  void render(Canvas canvas, CoordinateSystem coordinates) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Convert coordinates
    final start = coordinates.mapValueToDiagram(x1, y1);
    final end = coordinates.mapValueToDiagram(x2, y2);

    // Draw the main line
    canvas.drawLine(start, end, paint);

    // Draw the arrowhead
    renderArrowhead(canvas, coordinates, start, end);
  }

  /// Renders just the arrowhead portion of the arrow
  void renderArrowhead(Canvas canvas, CoordinateSystem coordinates, Offset start, Offset end) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Calculate arrow head points
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final angle = math.atan2(dy, dx);
    
    // Convert head length from diagram coordinates to pixel space
    final pixelHeadLength = headLength * coordinates.scale;

    switch (style) {
      case ArrowStyle.open:
        _drawOpenArrow(canvas, end, angle, pixelHeadLength, paint);
        break;
      case ArrowStyle.filled:
        _drawFilledArrow(canvas, end, angle, pixelHeadLength, paint);
        break;
      case ArrowStyle.bracket:
        _drawBracketArrow(canvas, end, angle, pixelHeadLength, paint);
        break;
      case ArrowStyle.dot:
        _drawDotArrow(canvas, end, pixelHeadLength, paint);
        break;
      case ArrowStyle.diamond:
        _drawDiamondArrow(canvas, end, angle, pixelHeadLength, paint);
        break;
    }
  }

  void _drawOpenArrow(Canvas canvas, Offset end, double angle, double length, Paint paint) {
    final leftPoint = Offset(
      end.dx - length * math.cos(angle + headAngle),
      end.dy - length * math.sin(angle + headAngle),
    );
    
    final rightPoint = Offset(
      end.dx - length * math.cos(angle - headAngle),
      end.dy - length * math.sin(angle - headAngle),
    );

    final path = Path()
      ..moveTo(leftPoint.dx, leftPoint.dy)
      ..lineTo(end.dx, end.dy)
      ..lineTo(rightPoint.dx, rightPoint.dy);

    canvas.drawPath(path, paint);
  }

  void _drawFilledArrow(Canvas canvas, Offset end, double angle, double length, Paint paint) {
    final leftPoint = Offset(
      end.dx - length * math.cos(angle + headAngle),
      end.dy - length * math.sin(angle + headAngle),
    );
    
    final rightPoint = Offset(
      end.dx - length * math.cos(angle - headAngle),
      end.dy - length * math.sin(angle - headAngle),
    );

    final path = Path()
      ..moveTo(leftPoint.dx, leftPoint.dy)
      ..lineTo(end.dx, end.dy)
      ..lineTo(rightPoint.dx, rightPoint.dy)
      ..close();

    canvas.drawPath(path, paint..style = PaintingStyle.fill);
  }

  void _drawBracketArrow(Canvas canvas, Offset end, double angle, double length, Paint paint) {
    final leftPoint = Offset(
      end.dx - length * math.cos(angle + math.pi / 2),
      end.dy - length * math.sin(angle + math.pi / 2),
    );
    
    final rightPoint = Offset(
      end.dx - length * math.cos(angle - math.pi / 2),
      end.dy - length * math.sin(angle - math.pi / 2),
    );

    canvas.drawLine(leftPoint, rightPoint, paint);
  }

  void _drawDotArrow(Canvas canvas, Offset end, double length, Paint paint) {
    canvas.drawCircle(end, length / 2, paint..style = PaintingStyle.fill);
  }

  void _drawDiamondArrow(Canvas canvas, Offset end, double angle, double length, Paint paint) {
    final tip = end;
    final back = Offset(
      end.dx - length * math.cos(angle),
      end.dy - length * math.sin(angle),
    );
    final left = Offset(
      back.dx - (length/2) * math.cos(angle + math.pi/2),
      back.dy - (length/2) * math.sin(angle + math.pi/2),
    );
    final right = Offset(
      back.dx - (length/2) * math.cos(angle - math.pi/2),
      back.dy - (length/2) * math.sin(angle - math.pi/2),
    );

    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(back.dx, back.dy)
      ..lineTo(right.dx, right.dy)
      ..close();

    canvas.drawPath(path, paint..style = PaintingStyle.fill);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ArrowElement &&
        other.x1 == x1 &&
        other.y1 == y1 &&
        other.x2 == x2 &&
        other.y2 == y2 &&
        other.headLength == headLength &&
        other.headAngle == headAngle &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.style == style;
  }

  @override
  int get hashCode => Object.hash(
        x1,
        y1,
        x2,
        y2,
        headLength,
        headAngle,
        color,
        strokeWidth,
        style,
      );
}
