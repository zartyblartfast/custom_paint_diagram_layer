# Project Core Principles

## Primary Objective
Create a flexible, maintainable diagram system in Flutter that supports multiple diagram types while maintaining clean architecture.

## Core Design Principles

### 1. Diagram Layer as Single Source of Truth
- All modifications MUST go through diagram layer methods
- No direct element modification allowed
- Clean separation between diagram logic and UI

### 2. Immutable State Management
```dart
// Correct pattern
layer = layer.addElement(element)  // Returns new instance

// Incorrect pattern
layer.elements.add(element)        // Direct modification
```

### 3. Clean Separation of Concerns
- Diagram Layer: Manages diagram state and operations
- Elements: Handle their own rendering
- Coordinate System: Manages all transformations
- Widget Layer: Handles UI and user interaction

## Implementation Pattern
```dart
// 1. Create diagram layer
final layer = BasicDiagramLayer(
  coordinateSystem: CoordinateSystem(...),
  showAxes: true,
);

// 2. Modify through layer methods
final newLayer = layer
    .addElement(element)
    .toggleAxes();

// 3. Update state immutably
setState(() => _layer = newLayer);
```

## Validation Checklist
- [ ] All modifications go through layer methods
- [ ] No direct state mutation
- [ ] Clean separation of concerns
- [ ] Proper coordinate system usage
- [ ] Immutable state management
- [ ] Clear error handling
