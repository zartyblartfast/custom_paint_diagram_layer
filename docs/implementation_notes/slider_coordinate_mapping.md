# Slider to Coordinate Mapping Design

This document outlines the design for mapping between slider values (0 to 1) and diagram coordinates while supporting boundary constraints.

## Class Design

### UML-Style Representation

```
+-------------------------------------+
|           DiagramLayer              |
+-------------------------------------+
| - xMin: Float                       |  // Min X-coordinate of the diagram
| - xMax: Float                       |  // Max X-coordinate of the diagram
| - yMin: Float                       |  // Min Y-coordinate of the diagram
| - yMax: Float                       |  // Max Y-coordinate of the diagram
+-------------------------------------+
| + mapSliderToDiagram(value: Float,  |  // Maps slider (0-1) to diagram coord.
|   axis: String): Float              |
| + mapDiagramToSlider(value: Float,  |  // Maps diagram coord. to slider (0-1)
|   axis: String): Float              |
| + constrainElement(x: Float,        |  // Constrains element within diagram
|   y: Float, radius: Float):         |
|   {x: Float, y: Float}              |
+-------------------------------------+

+-------------------------------------+
|          SliderController           |
+-------------------------------------+
| - diagramLayer: DiagramLayer        |  // Reference to DiagramLayer
| - sliderX: Float                    |  // Slider value for X-axis (0-1)
| - sliderY: Float                    |  // Slider value for Y-axis (0-1)
+-------------------------------------+
| + updatePosition(): {x: Float,      |  // Converts slider values to diagram
|   y: Float}                         |  // coordinates and applies constraints
+-------------------------------------+
```

## Detailed Component Specifications

### DiagramLayer

#### Attributes
- `xMin`, `xMax`, `yMin`, `yMax`: Define the coordinate system boundaries
  - Can vary between diagrams (e.g., x: -5 to 5, y: 0 to 10)
  - Determined by the diagram's requirements

#### Methods

##### `mapSliderToDiagram(value, axis)`
Converts a slider value [0, 1] to diagram coordinates.

```dart
double mapSliderToDiagram(double value, String axis) {
  if (axis == "x") {
    return xMin + value * (xMax - xMin);
  } else {
    return yMin + value * (yMax - yMin);
  }
}
```

##### `mapDiagramToSlider(value, axis)`
Converts diagram coordinates back to slider values [0, 1].

```dart
double mapDiagramToSlider(double value, String axis) {
  if (axis == "x") {
    return (value - xMin) / (xMax - xMin);
  } else {
    return (value - yMin) / (yMax - yMin);
  }
}
```

##### `constrainElement(x, y, radius)`
Ensures elements stay within diagram boundaries.

```dart
({double x, double y}) constrainElement(double x, double y, double radius) {
  final constrainedX = max(xMin + radius, min(x, xMax - radius));
  final constrainedY = max(yMin + radius, min(y, yMax - radius));
  return (x: constrainedX, y: constrainedY);
}
```

### SliderController

#### Attributes
- `diagramLayer`: Reference to DiagramLayer instance
- `sliderX`, `sliderY`: Current slider values [0, 1]

#### Methods

##### `updatePosition()`
Converts slider values to constrained diagram coordinates.

```dart
({double x, double y}) updatePosition() {
  final x = diagramLayer.mapSliderToDiagram(sliderX, "x");
  final y = diagramLayer.mapSliderToDiagram(sliderY, "y");
  return diagramLayer.constrainElement(x, y, radius);
}
```

## Usage Example

```dart
// Initialize diagram with engineering coordinates
final diagram = DiagramLayer(
  xMin: -5,
  xMax: 5,
  yMin: 0,
  yMax: 10
);

// Create slider controller
final slider = SliderController(diagram);

// Set slider positions (middle of x-axis, 30% up y-axis)
slider.sliderX = 0.5;
slider.sliderY = 0.3;

// Get constrained position in diagram coordinates
final position = slider.updatePosition();
// position.x ≈ 0 (middle of x-axis)
// position.y ≈ 3 (30% up the y-axis)
```

## Design Benefits

### 1. Flexibility
- Supports any coordinate layout
- Universal mapping regardless of diagram type
- Handles both centered and non-centered coordinate systems

### 2. Encapsulation
- Mapping logic contained within DiagramLayer
- Constraint handling separated from UI concerns
- Clear separation of responsibilities

### 3. Reusability
- SliderController works with any diagram configuration
- Easy to extend for different element types
- Consistent interface across the application

### 4. Simplicity
- Fixed 0 to 1 slider range simplifies UI interaction
- Complex coordinate mapping hidden from consumers
- Intuitive percentage-based slider values

## Implementation Notes

1. All coordinate transformations should go through DiagramLayer
2. Slider values should always be normalized to [0, 1]
3. Boundary constraints are applied in diagram coordinates
4. Element dimensions (radius, height, etc.) are in diagram coordinates 