# Element Style Architecture

## Overview

This document describes the architectural design for managing element styles and properties in the Custom Paint Diagram Layer system. The architecture separates visual styling from geometric properties, enabling better maintainability, reusability, and extensibility.

## Core Concepts

### 1. Style System

The style system is built around a hierarchy of style classes that handle different aspects of visual presentation.

#### Style Hierarchy

```
DiagramStyle (abstract)
├── StrokeStyle
├── FillStyle
└── TextStyle
```

#### Key Terms

- **DiagramStyle**: Base abstract class for all styles
- **StrokeStyle**: Defines line properties (width, dash pattern, caps)
- **FillStyle**: Defines fill properties (color, gradient, opacity)
- **TextStyle**: Defines text rendering properties (font, size, alignment)

### 2. Property System

The property system defines interfaces and mixins that elements can implement to gain specific capabilities.

#### Property Interfaces

```
IStrokeable
├── StrokeStyle property
└── Stroke-related methods

IFillable
├── FillStyle property
└── Fill-related methods

ITextual
├── TextStyle property
└── Text-related methods
```

#### Key Terms

- **Property Interface**: Defines the contract for a specific capability
- **Property Mixin**: Provides default implementations of property-related behaviors
- **Capability**: A specific feature an element can have (e.g., being strokeable)

### 3. Element Structure

Elements are built by composing properties and styles.

#### Element Hierarchy

```
DiagramElement (abstract)
├── Properties
│   ├── id: String
│   └── zIndex: int
└── Implementations
    ├── RectangleElement
    ├── LineElement
    ├── TextElement
    └── ... other elements
```

## Usage Guidelines

### 1. Creating New Elements

When creating a new element type:

1. Extend `DiagramElement`
2. Implement required property interfaces
3. Mix in appropriate property mixins
4. Define element-specific properties
5. Implement the `render` method

Example:
```dart
class CircleElement extends DiagramElement 
    with StrokeableElement, FillableElement {
  final double radius;
  
  // ... constructor and implementation
}
```

### 2. Styling Elements

Use the style system to define element appearance:

1. Create style instances using `DiagramStyles` factory
2. Apply styles to elements through constructors
3. Reuse common styles across elements

Example:
```dart
final commonStroke = DiagramStyles.createStroke(
  color: Colors.blue,
  width: 2.0
);

final circle = CircleElement(
  strokeStyle: commonStroke,
  fillStyle: DiagramStyles.transparent,
  // ... other properties
);
```

### 3. Managing Elements

Use `DiagramElementManager` to organize elements:

1. Add elements with unique IDs
2. Manage z-index ordering
3. Query and update elements

Example:
```dart
final manager = DiagramElementManager();
manager.addElement(circle);
final orderedElements = manager.getOrderedElements();
```

## Integration with Layer System

The style system is primarily integrated through the `StyledDiagramLayer` implementation of the `IDiagramLayer` interface. This provides a clean separation between styled and non-styled elements while maintaining compatibility with the existing system.

### Layer Integration

```dart
// Style system works within StyledDiagramLayer
class StyledDiagramLayer implements IDiagramLayer {
  final DiagramElementManager elementManager;
  final StyleSystem styleSystem;
  
  void addElement(DiagramElement element) {
    elementManager.addElement(element);
  }
  
  @override
  void render(Canvas canvas, Size size) {
    // Render elements with style support
    for (final element in elementManager.getOrderedElements()) {
      element.render(canvas, coordinateSystem);
    }
  }
}
```

### Factory Support

Elements can be created through a factory that supports both styled and non-styled variants:

```dart
class DiagramElementFactory {
  static DrawableElement createElement({
    required ElementType type,
    bool useStyles = false,
    // ... other parameters
  }) {
    return useStyles
      ? _createStyledElement(type, ...)
      : _createBasicElement(type, ...);
  }
}
```

## Best Practices

1. **Style Reuse**
   - Create common styles using `DiagramStyles` factory
   - Share styles across similar elements
   - Use style presets for consistent appearance

2. **Property Composition**
   - Only implement needed properties
   - Use mixins for common functionality
   - Keep property implementations focused

3. **Element Design**
   - Keep elements focused on single responsibility
   - Separate geometry from appearance
   - Use meaningful IDs for elements

4. **Performance**
   - Reuse style objects when possible
   - Cache computed values
   - Use z-index for efficient rendering

## Extension Points

The architecture can be extended in several ways:

1. **New Styles**
   - Create new style classes for specific needs
   - Extend existing styles with new properties
   - Add new style presets

2. **New Properties**
   - Define new property interfaces
   - Create corresponding mixins
   - Add to relevant elements

3. **New Elements**
   - Create new element types
   - Compose existing properties
   - Add element-specific features

## Implementation Notes

1. **Style Immutability**
   - All style objects should be immutable
   - Use `copyWith` for modifications
   - Cache style objects when possible

2. **Property Validation**
   - Validate style properties in constructors
   - Use assert statements for development checks
   - Provide meaningful error messages

3. **Rendering Order**
   - Fill before stroke
   - Respect z-index ordering
   - Handle transparency correctly

## Migration Guide

When migrating existing elements to this architecture:

1. Extract style properties into appropriate style classes
2. Implement relevant interfaces
3. Add property mixins
4. Update constructors and render methods
5. Update any client code

## Future Considerations

1. **Style Themes**
   - Theme-based style collections
   - Dynamic style updates
   - Style inheritance

2. **Animation Support**
   - Style transitions
   - Property animations
   - Coordinated animations

3. **State Management**
   - Element state tracking
   - Style state management
   - Undo/redo support
