# Implementation Patterns

## Core Patterns

### 1. Layer Modification
```dart
// CORRECT: Using layer methods
layer = layer.addElement(element)
layer = layer.toggleAxes()

// INCORRECT: Direct modification
layer.elements.add(element)
layer.showAxes = false
```

### 2. State Management
```dart
// CORRECT: Immutable updates
void updateDiagram() {
  setState(() {
    _layer = BasicDiagramLayer(...)
        .addElement(element);
  });
}

// INCORRECT: Mutable updates
void updateDiagram() {
  _layer.elements.add(element);
  setState(() {});
}
```

### 3. Coordinate System Usage
```dart
// CORRECT: Using coordinate system
void render(Canvas canvas, CoordinateSystem coords) {
  final point = coords.mapValueToDiagram(x, y);
  canvas.drawCircle(point, radius, paint);
}

// INCORRECT: Direct canvas manipulation
void render(Canvas canvas) {
  canvas.drawCircle(Offset(x, y), radius, paint);
}
```

## Validated Examples

### 1. Spring Balance Diagram
- Uses layer methods for updates
- Maintains immutability
- Proper coordinate system usage
```dart
_layer = BasicDiagramLayer(
  coordinateSystem: _layer.coordinateSystem,
  showAxes: _layer.showAxes,
).addElement(LineElement(...));
```

### 2. Original Test Diagram
- Follows same patterns
- Clean axis management
- Proper element handling
```dart
_layer = BasicDiagramLayer(...)
    .addElement(AxisElement(...))
    .addElement(LineElement(...));
```

## Anti-Patterns to Avoid

### 1. Direct State Mutation
```dart
// NEVER do this
layer.elements.add(element);
layer.showAxes = false;
```

### 2. Bypassing Coordinate System
```dart
// NEVER do this
void render(Canvas canvas) {
  final screenX = x * someScale + offset;
  final screenY = y * someScale + offset;
  canvas.drawCircle(Offset(screenX, screenY), radius, paint);
}
```

### 3. Mixed Responsibilities
```dart
// NEVER do this
class DiagramWidget extends StatefulWidget {
  void addElement() {
    elements.add(element);  // Direct modification
    updateCanvas();        // Mixed responsibility
  }
}
```

## Testing Patterns

### 1. Layer Tests
```dart
test('layer modifications return new instances', () {
  final layer = BasicDiagramLayer(...);
  final newLayer = layer.addElement(element);
  expect(identical(layer, newLayer), isFalse);
});
```

### 2. Element Tests
```dart
test('elements use coordinate system', () {
  final element = LineElement(...);
  final coords = CoordinateSystem(...);
  element.render(canvas, coords);
  // Verify proper coordinate transformation
});
```
