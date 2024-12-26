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

#### Core Elements

1. **AxisElement**
   - Renders coordinate axes
   - Properties:
     - `x`, `y`: Origin position
     - `color`: Axis color
     - `strokeWidth`: Line thickness

2. **GridElement**
   - Renders background grid
   - Properties:
     - `x`, `y`: Grid origin
     - `majorSpacing`: Major grid line spacing
     - `minorSpacing`: Minor grid line spacing
     - `majorColor`: Major line color
     - `minorColor`: Minor line color

3. **FrameElement**
   - Renders a customizable frame around the diagram
   - Properties:
     - `strokeWidth`: Frame border thickness
     - `color`: Frame border color
     - `fillColor`: Optional frame background color
     - `opacity`: Frame transparency

#### Geometric Elements

1. **CircleElement**
   - Renders a circle
   - Properties:
     - `x`, `y`: Center position
     - `radius`: Circle radius
     - `color`: Stroke color
     - `fillColor`: Optional fill color

2. **LineElement**
   - Renders a straight line
   - Properties:
     - `x1`, `y1`: Start position
     - `x2`, `y2`: End position
     - `color`: Line color
     - `strokeWidth`: Line thickness

3. **PolygonElement**
   - Renders a polygon
   - Properties:
     - `points`: List of vertices
     - `color`: Stroke color
     - `fillColor`: Optional fill color
     - `strokeWidth`: Line thickness

4. **BezierCurveElement**
   - Renders a bezier curve
   - Properties:
     - `x`, `y`: Start position
     - `endPoint`: End position
     - `controlPoint1`: First control point
     - `controlPoint2`: Second control point (cubic only)
     - `type`: Curve type (quadratic/cubic)

#### Text and Labels

1. **TextElement**
   - Renders text
   - Properties:
     - `x`, `y`: Text position
     - `text`: Text content
     - `style`: Text style
     - `color`: Text color

### 4. Element Ordering

Elements are rendered in the order they are added to the diagram layer. The recommended order is:

1. Frame (if enabled)
2. Grid (if enabled)
3. Axes (if enabled)
4. Background elements
5. Main diagram elements
6. Foreground elements
7. Text and labels

### 5. Element Examples

```dart
// Frame element
final frame = FrameElement(
  strokeWidth: 2.0,
  color: Colors.blueAccent,
  fillColor: Colors.grey.shade100,
  opacity: 0.8,
);

// Grid element
final grid = GridElement(
  x: 0,
  y: 0,
  majorSpacing: 1.0,
  minorSpacing: 0.2,
  majorColor: Colors.grey.withOpacity(0.5),
  minorColor: Colors.grey.withOpacity(0.2),
);

// Circle with fill
final circle = CircleElement(
  x: 0,
  y: 0,
  radius: 5.0,
  color: Colors.black,
  fillColor: Colors.blue.withOpacity(0.5),
);

// Text label
final label = TextElement(
  x: 0,
  y: 0,
  text: 'Origin',
  style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  color: Colors.black,
);
```

### 6. Element Equality

Elements implement value equality based on their properties:

```dart
final circle1 = CircleElement(x: 0, y: 0, radius: 10);
final circle2 = CircleElement(x: 0, y: 0, radius: 10);
final circle3 = CircleElement(x: 1, y: 0, radius: 10);

assert(circle1 == circle2);  // true
assert(circle1 != circle3);  // true
```

## Best Practices

### 1. Element Creation
- Use named constructors for clarity
- Provide all required parameters
- Use optional parameters with defaults
- Consider element visibility in ordering

### 2. Element Composition
- Group related elements
- Use appropriate element types
- Consider performance impact
- Maintain logical ordering

### 3. Style Management
- Use consistent colors
- Consider opacity for overlays
- Match UI theme when appropriate
- Use appropriate stroke widths

### 4. Performance
- Minimize element count
- Use simpler elements when possible
- Consider caching complex paths
- Group similar elements

### 5. Error Prevention
- Validate all parameters
- Handle edge cases
- Use appropriate defaults
- Test different configurations
