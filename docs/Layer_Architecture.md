# Diagram Layer Architecture

## Core Principle
The diagram layer is the single source of truth for all diagram operations. All modifications to diagrams MUST go through the diagram layer's methods to ensure consistent behavior and state management.

## Architecture Overview

### Layer System

```
IDiagramLayer (interface)
└── BasicDiagramLayer
    ├── Manages coordinate system
    ├── Handles element operations
    └── Maintains immutability
```

### Key Components

1. **IDiagramLayer Interface**
```dart
abstract class IDiagramLayer {
  CoordinateSystem get coordinateSystem;
  List<DrawableElement> get elements;
  bool get showAxes;
  bool get showGrid;
  bool get showFrame;
  
  IDiagramLayer updateCoordinateSystem(CoordinateSystem newSystem);
  IDiagramLayer addElement(DrawableElement element);
  IDiagramLayer removeElement(DrawableElement element);
  IDiagramLayer toggleAxes();
  IDiagramLayer toggleGrid();
  IDiagramLayer toggleFrame();
  void render(Canvas canvas, Size size);
}
```

2. **Basic Implementation**
```dart
class BasicDiagramLayer implements IDiagramLayer {
  final CoordinateSystem coordinateSystem;
  final List<DrawableElement> elements;
  final bool showAxes;
  final bool showGrid;
  final bool showFrame;
  
  // All operations return new instances
  // No direct element modification allowed
  
  @override
  IDiagramLayer updateCoordinateSystem(CoordinateSystem newSystem) {
    // Returns new layer with updated coordinate system
  }
}
```

## Implementation Pattern

### 1. Diagram Creation
- Diagrams are created through the diagram layer
- Initial state includes coordinate system and axes settings
- Elements can be added during or after creation

### 2. Element Management
- Elements are added/removed through layer methods
- Each operation creates a new immutable instance
- No direct element modification allowed

### 3. Rendering Pipeline
- Layer handles all rendering operations
- Coordinate transformations managed by layer
- Elements render themselves using provided coordinate system

## Usage Example

```dart
// Create initial layer
var layer = BasicDiagramLayer(
  coordinateSystem: CoordinateSystem(...),
  showAxes: true,
  showGrid: true,
  showFrame: true,
);

// Add elements using layer methods
layer = layer.addElement(LineElement(...));

// Toggle axes using layer methods
layer = layer.toggleAxes();

// Toggle frame using layer methods
layer = layer.toggleFrame();
```

## State Management
1. Layer is immutable - all changes create new instances
2. Widget state can hold layer reference
3. Changes reflected through setState() in Flutter

## Guidelines

### Do's
- Use layer methods for all modifications
- Maintain immutability
- Keep UI logic separate from diagram logic

### Don'ts
- Don't modify elements directly
- Don't bypass layer methods
- Don't mutate layer state

## Integration Points

### 1. Coordinate System
- Handles all coordinate transformations
- Maintains consistent mapping between engineering and screen spaces
- Supports dynamic updates through `updateCoordinateSystem`
- Used by all elements for rendering

### 2. Element Management
- Elements are managed through the layer's API
- Support for various element types (lines, rectangles, text, etc.)
- Each element handles its own rendering using the layer's coordinate system
- Elements can be added, removed, or updated through layer methods

### 3. Canvas Integration
- Direct integration with Flutter's Canvas API
- Efficient rendering through custom paint
- Support for various paint styles and configurations
- Handles proper ordering of element rendering

## Best Practices

1. **State Management**
   - Always use layer methods for modifications
   - Maintain immutability for predictable behavior
   - Use setState() or state management solution of choice
   - Never modify elements directly

2. **Coordinate System Usage**
   - Use engineering coordinates for logical positioning
   - Let the coordinate system handle screen transformations
   - Update coordinate system for zoom/pan operations

3. **Performance**
   - Minimize unnecessary layer updates
   - Use appropriate element types for better performance
   - Consider element complexity in large diagrams

4. **Element Management**
   - Always use layer methods to add/remove elements
   - Maintain immutability by creating new instances
   - Use appropriate element types for different drawing needs

5. **Visibility Control**
   - Use DiagramConfig for initial visibility settings
   - Use toggle methods for runtime visibility changes
   - Maintain consistent state across updates

6. **Frame Customization**
   - Configure frame appearance through FrameElement properties
   - Use opacity for subtle visual effects
   - Consider coordinate system bounds for proper positioning

## Future Considerations
1. Style system integration
2. Enhanced element management
3. Advanced coordinate systems
