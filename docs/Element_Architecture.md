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

  void render(Canvas canvas, CoordinateSystem coordinateSystem);
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
├── GridElement
├── RulerElement
├── LineElement
├── ArrowElement
├── RightTriangleElement
├── DottedLineElement
└── ImageElement
```

## Implementation Details

### 1. Creating Elements

Each element type:
1. Extends `DrawableElement`
2. Implements the `render` method
3. Defines element-specific properties
4. Handles its own rendering logic

Example:
```dart
class ImageElement extends DrawableElement {
  final ImageSource source;
  final String? path;
  final double width;
  final double height;
  final double opacity;

  // Constructor and implementation
}
```

### 2. Element Properties

Elements can have various properties:
- Position (x, y coordinates)
- Dimensions (width, height)
- Color
- Element-specific properties (e.g., image path, line thickness)

### 3. Rendering

Elements implement the `render` method to draw themselves:
1. Convert coordinates using the coordinate system
2. Set up the canvas paint properties
3. Draw the element using Flutter's Canvas APIs

Example:
```dart
@override
void render(Canvas canvas, CoordinateSystem coordinates) {
  final point = coordinates.mapValueToDiagram(x, y);
  canvas.drawSomething(point, paint);
}
```

## Usage Guidelines

### 1. Adding Elements to a Diagram

Elements are added to the diagram using the builder pattern:

```dart
diagram
  .addElement(GridElement())
  .addElement(RulerElement())
  .addElement(ImageElement(
    x: 0,
    y: 2,
    width: 4,
    height: 4,
    source: ImageSource.network,
    path: 'https://example.com/image.jpg',
  ));
```

### 2. Custom Elements

To create a new element type:

1. Extend `DrawableElement`
2. Implement required properties
3. Implement the `render` method
4. Handle coordinate transformations

Example:
```dart
class CustomElement extends DrawableElement {
  CustomElement({
    required double x,
    required double y,
    Color color = const Color(0xFF000000),
  }) : super(x: x, y: y, color: color);

  @override
  void render(Canvas canvas, CoordinateSystem coordinates) {
    // Implementation
  }
}
```

## Best Practices

1. **Coordinate Handling**
   - Always use the coordinate system for transformations
   - Remember the bottom-left origin when calculating positions
   - Test elements at different scales and positions

2. **Element Design**
   - Keep elements focused on a single responsibility
   - Handle errors gracefully (e.g., failed image loading)
   - Use meaningful parameter names and defaults

3. **Performance**
   - Minimize calculations in render methods
   - Cache values when possible
   - Clean up resources (e.g., image streams) when done

4. **Testing**
   - Test elements at different scales
   - Verify coordinate transformations
   - Test error cases and edge conditions

## Extension Points

The system can be extended by:

1. **New Element Types**
   - Create new subclasses of `DrawableElement`
   - Add specialized rendering logic
   - Implement new visual features

2. **Enhanced Properties**
   - Add new properties to elements
   - Implement new rendering effects
   - Add animation support

3. **Coordinate System**
   - Add new coordinate transformation methods
   - Support different coordinate spaces
   - Add viewport management
