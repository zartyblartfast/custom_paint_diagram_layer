# Diagram Layer Architecture

## Overview

The Custom Paint Diagram Layer system uses a hybrid architecture that maintains compatibility with existing code while enabling new style-aware features. This document describes the layer system and how it integrates with the style architecture.

## Core Architecture

### Layer Hierarchy

```
IDiagramLayer (interface)
├── BasicDiagramLayer
│   └── Legacy element support
└── StyledDiagramLayer
    └── Style-aware element support
```

### Key Components

1. **Base Interface**
```dart
abstract class IDiagramLayer {
  CoordinateSystem get coordinateSystem;
  void render(Canvas canvas, Size size);
  // ... common interface methods
}
```

2. **Layer Implementations**
```dart
// Legacy support
class BasicDiagramLayer implements IDiagramLayer {
  final List<DrawableElement> elements;
  // ... existing implementation
}

// Style-aware implementation
class StyledDiagramLayer implements IDiagramLayer {
  final DiagramElementManager elementManager;
  final StyleSystem styleSystem;
  // ... new implementation
}
```

3. **Factory**
```dart
class DiagramLayerFactory {
  static IDiagramLayer create({
    required CoordinateSystem coordinateSystem,
    bool useStyleSystem = false,
  });
}
```

## Integration Points

### 1. Coordinate System

The coordinate system remains a core concept shared between both implementations:

- Used by both legacy and styled elements
- Maintains consistent transformation logic
- Shared between all layer types

### 2. Rendering Pipeline

Each layer type manages its own rendering pipeline while adhering to common interfaces:

```dart
abstract class IRenderable {
  void render(Canvas canvas, CoordinateSystem coordinateSystem);
}

abstract class ITransformable {
  Offset mapToCanvas(CoordinateSystem coordinateSystem);
}
```

### 3. Element Management

Different approaches for each layer type:

- **BasicDiagramLayer**: Simple list of elements
- **StyledDiagramLayer**: Managed through DiagramElementManager with z-index support

## Usage Patterns

### 1. Creating Diagram Layers

```dart
// Legacy approach
final basicLayer = DiagramLayerFactory.create(
  coordinateSystem: myCoordinateSystem,
  useStyleSystem: false,
);

// Style-aware approach
final styledLayer = DiagramLayerFactory.create(
  coordinateSystem: myCoordinateSystem,
  useStyleSystem: true,
);
```

### 2. Adding Elements

```dart
// Legacy layer
basicLayer.addElement(LegacyRectangleElement(...));

// Styled layer
styledLayer.addElement(StyledRectangleElement(
  style: myStyle,
  ...
));
```

### 3. Rendering

Both layers implement the same rendering interface:

```dart
void buildDiagram(Canvas canvas, Size size) {
  // Works with any layer type
  diagramLayer.render(canvas, size);
}
```

## Implementation Considerations

### 1. Coordinate System Integration

The existing `CoordinateSystem` class remains the foundation for both layer types:

```dart
abstract class IDiagramLayer {
  CoordinateSystem get coordinateSystem;
  
  // Optional method to update coordinate system
  IDiagramLayer updateCoordinateSystem(CoordinateSystem newSystem);
}
```

### 2. Canvas Alignment

Both layer types will use `CanvasAlignment` for consistent behavior:

```dart
class BasicDiagramLayer implements IDiagramLayer {
  @override
  void render(Canvas canvas, Size size) {
    final alignment = CanvasAlignment(
      canvasSize: size,
      coordinateSystem: coordinateSystem,
    );
    alignment.alignCenter();
    // ... render elements
  }
}

class StyledDiagramLayer implements IDiagramLayer {
  @override
  void render(Canvas canvas, Size size) {
    final alignment = CanvasAlignment(
      canvasSize: size,
      coordinateSystem: coordinateSystem,
    );
    alignment.alignCenter();
    // ... render styled elements
  }
}
```

### 3. Style System Integration

The style system will maintain immutability:

```dart
class DiagramStyle {
  final StrokeStyle? stroke;
  final FillStyle? fill;
  
  const DiagramStyle({this.stroke, this.fill});
  
  // Immutable updates
  DiagramStyle copyWith({
    StrokeStyle? stroke,
    FillStyle? fill,
  });
}
```

### 4. Z-Index Handling

Z-index will be managed consistently across layers:

```dart
class DiagramElementManager {
  // Maintain sorted order during element addition
  void addElement(DiagramElement element) {
    _elements.insert(
      _findInsertionIndex(element.zIndex),
      element,
    );
  }
  
  // Ensure consistent ordering during rendering
  List<DiagramElement> getOrderedElements() {
    return List.unmodifiable(_elements);
  }
}
```

## Extension Points

### 1. New Layer Types

The architecture supports adding new layer types:

```dart
class AnimatedDiagramLayer implements IDiagramLayer {
  final StyledDiagramLayer baseLayer;
  final AnimationController controller;
  // ... animation specific implementation
}
```

### 2. Shared Behaviors

Common behaviors can be added through mixins:

```dart
mixin ZoomableDiagramLayer on IDiagramLayer {
  void zoom(double factor);
  void pan(Offset delta);
}
```

### 3. Layer Composition

Layers can be composed for complex behaviors:

```dart
class CompositeLayer implements IDiagramLayer {
  final List<IDiagramLayer> layers;
  // ... composite implementation
}
```

## Best Practices

1. **Layer Selection**
   - Use BasicDiagramLayer for simple diagrams
   - Use StyledDiagramLayer for complex styling needs
   - Consider future needs when choosing

2. **Coordinate System Usage**
   - Share coordinate system between layers when possible
   - Maintain consistent transformation logic
   - Consider viewport management

3. **Element Management**
   - Keep elements in appropriate layer type
   - Use factory methods for element creation
   - Consider element lifecycle management

4. **Style Integration**
   - Use style system only in StyledDiagramLayer
   - Maintain style consistency across elements
   - Consider style inheritance and overrides

## Migration Considerations

1. **Choosing Layer Type**
   - Evaluate styling needs
   - Consider performance requirements
   - Plan for future features

2. **Mixed Usage**
   - Can use both layer types in same application
   - Consider adapter patterns for conversion
   - Plan for eventual consolidation

3. **Testing Strategy**
   - Test layers independently
   - Verify common interface compliance
   - Test layer interaction when composed

## Future Considerations

1. **Layer Features**
   - Interactive elements
   - Animation support
   - Export capabilities

2. **Performance Optimization**
   - Layer-specific optimizations
   - Caching strategies
   - Lazy rendering

3. **Style System Evolution**
   - Theme support
   - Dynamic styling
   - Style transitions
