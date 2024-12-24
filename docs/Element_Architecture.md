# Element Architecture

## Overview

This document describes the architectural design for diagram elements in the Custom Paint Diagram Layer system. The architecture is based on composable elements that can be added to a diagram layer, each responsible for rendering a specific type of visual component.

## Core Concepts

### 1. Base Element Class

All diagram elements inherit from the abstract `DrawableElement` class, which defines the basic contract for any element that can be drawn on the diagram.

```dart
abstract class DrawableElement {
  final double x;
  final double y;
  final Color color;

  const DrawableElement({
    required this.x,
    required this.y,
    this.color = Colors.black,
  });

  void render(Canvas canvas, CoordinateSystem coordinateSystem);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DrawableElement &&
           other.x == x &&
           other.y == y &&
           other.color == color;
  }

  @override
  int get hashCode => Object.hash(x, y, color);
}
```

### 2. Coordinate System

Elements use a coordinate system that:
- Has its origin at the bottom-left corner
- Y-axis increases upward
- X-axis increases rightward
- Converts between diagram space and screen space coordinates

### 3. Element Types

The system includes several types of elements:

```
DrawableElement (abstract)
├── Basic Shapes
│   ├── CircleElement
│   ├── EllipseElement
│   ├── RectangleElement
│   ├── RightTriangleElement
│   ├── IsoscelesTriangleElement
│   ├── ParallelogramElement
│   ├── PolygonElement
│   └── StarElement
├── Lines and Connectors
│   ├── LineElement
│   ├── DottedLineElement
│   ├── ConnectorElement
│   ├── ArrowElement
│   └── ArrowheadElement
├── Curves
│   ├── BezierCurveElement
│   ├── ArcElement
│   └── SpiralElement
├── Measurement and Reference
│   ├── AxisElement
│   ├── GridElement
│   └── RulerElement
├── Groups
│   └── GroupElement (contains child elements)
└── Media
    ├── TextElement
    └── ImageElement
```

### 4. Element Properties

#### Common Properties
All elements inherit these base properties:
```dart
required double x;      // X position in diagram coordinates
required double y;      // Y position in diagram coordinates
Color color;           // Stroke color (defaults to Colors.black)
```

#### Element-Specific Properties

**Basic Shapes**
```dart
// CircleElement
final double radius;
final Color? fillColor;

// RectangleElement
final double width;
final double height;
final Color? fillColor;
final double? borderRadius;

// PolygonElement
final List<Point<double>> points;
final Color? fillColor;
final bool closed;
```

**Lines and Connectors**
```dart
// LineElement
final double x2;
final double y2;
final double strokeWidth;

// ArrowElement
final double headSize;
final double headAngle;
final ArrowStyle style;

// DottedLineElement
final double dashLength;
final double gapLength;
```

**Curves**
```dart
// BezierCurveElement
final Point<double> endPoint;
final Point<double> controlPoint1;
final Point<double>? controlPoint2;
final BezierType type;

// ArcElement
final double radius;
final double startAngle;
final double endAngle;
final bool useCenter;
```

**Measurement**
```dart
// AxisElement
final double length;
final double tickInterval;
final bool showLabels;
final AxisOrientation orientation;

// GridElement
final double spacing;
final bool showSubdivisions;
```

**Media**
```dart
// TextElement
final String text;
final TextStyle? style;
final TextAlign align;

// ImageElement
final ui.Image image;
final double width;
final double height;
final BoxFit fit;
```

### 5. Element Creation

Elements should be created through their constructors with required parameters:

```dart
// Basic shape
final circle = CircleElement(
  x: 0,
  y: 0,
  radius: 50,
  color: Colors.black,
  fillColor: Colors.blue.withOpacity(0.5),
);

// Line with arrow
final arrow = ArrowElement(
  x1: 0,
  y1: 0,
  x2: 100,
  y2: 100,
  headSize: 10,
  style: ArrowStyle.filled,
  color: Colors.black,
);

// Curve
final curve = BezierCurveElement(
  x: 0,
  y: 0,
  endPoint: Point(100, 100),
  controlPoint1: Point(50, 150),
  type: BezierType.quadratic,
  color: Colors.black,
);

// Group
final group = GroupElement(
  x: 0,
  y: 0,
  elements: [circle, arrow, curve],
);
```

### 6. Element Equality

Elements implement value equality based on their properties:

```dart
// Two elements with same properties are equal
final circle1 = CircleElement(x: 0, y: 0, radius: 10);
final circle2 = CircleElement(x: 0, y: 0, radius: 10);
assert(circle1 == circle2);  // true

// Different properties = different elements
final circle3 = CircleElement(x: 1, y: 0, radius: 10);
assert(circle1 != circle3);  // true
```

## Best Practices

### 1. Element Creation
- Always provide required parameters
- Use named parameters for clarity
- Consider optional parameters for customization
- Initialize elements with const when possible

### 2. Coordinate System
- Use diagram coordinates, not screen coordinates
- Let coordinate system handle transformations
- Consider scale when setting sizes and distances

### 3. Groups
- Use GroupElement for related elements
- Keep group hierarchies shallow
- Consider performance with large groups

### 4. Performance
- Minimize element creation in tight loops
- Cache complex calculations
- Use appropriate stroke widths for scale

### 5. Testing
- Test element creation with various parameters
- Verify coordinate transformations
- Test edge cases (zero size, negative values)
- Validate group transformations

## Reference Examples

See these implementations for examples:
- `migrated_butterfly_art.dart` - Complex shape composition
- `standalone_migrated_main.dart` - Basic element usage
- `embedded_migrated_main.dart` - Interactive elements
