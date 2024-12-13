# Current Architecture

## Core Pattern
All diagram modifications MUST go through the diagram layer's methods to ensure consistent behavior and state management.

## Key Components

### IDiagramLayer
```dart
abstract class IDiagramLayer {
  CoordinateSystem get coordinateSystem;
  List<DrawableElement> get elements;
  bool get showAxes;
  
  IDiagramLayer addElement(DrawableElement element);
  IDiagramLayer removeElement(DrawableElement element);
  IDiagramLayer toggleAxes();
  void render(Canvas canvas, Size size);
}
```

### Implementation Pattern
```dart
// Creating diagram
final layer = BasicDiagramLayer(
  coordinateSystem: CoordinateSystem(...),
  showAxes: true,
);

// Modifying diagram (returns new instance)
final newLayer = layer.addElement(LineElement(...));

// Widget state management
setState(() {
  _layer = newLayer;
});
```

## Validation Points
1. ✓ All modifications through layer methods
2. ✓ Immutable state management
3. ✓ Proper coordinate system usage
4. ✓ Clean separation of concerns

## Current Examples
1. Spring Balance Diagram
   - Uses layer methods for all changes
   - Maintains immutability
   - Proper coordinate system integration

2. Original Test Diagram
   - Maintains existing functionality
   - Uses same layer architecture
   - Clean axis management
