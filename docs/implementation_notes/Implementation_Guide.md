# Implementation Guide

## Core Principle
The fundamental principle of our implementation is that **all diagram modifications must go through the diagram layer**. This ensures consistent behavior, proper state management, and maintainable code.

## Testing Infrastructure

### 1. Base Test Classes
- Use `DiagramTestBase` for standard test setup
- Provides coordinate system, grid, and axes
- Handles element boundary positioning
- Includes standard UI controls

### 2. Layer Management
```dart
// CORRECT: Chain operations and capture new instance
var newLayer = BasicDiagramLayer(...)
    .addElement(_grid)
    .addElement(element);

// INCORRECT: Direct modification
diagramLayer.elements.add(element);  // Don't do this!
```

### 3. State Updates
- Always capture new layer instances
- Use setState() to update layer reference
- Never modify layer or elements directly
- Chain operations for multiple changes

### 4. Initialization Pattern
```dart
// Create coordinate system first
_coordSystem = CoordinateSystem(...);

// Create static elements
_grid = GridElement(...);

// Initialize layer with chained operations
diagramLayer = BasicDiagramLayer(
  coordinateSystem: _coordSystem,
  showAxes: true,
).addElement(_grid);
```

## Key Use Cases

### 1. Static Diagrams
- Fixed educational illustrations
- Technical documentation
- System architecture diagrams

### 2. Dynamic Diagrams
- Interactive learning tools
- Real-time data visualization
- Animated demonstrations
- User-controlled element positioning
- Physics simulations
- Step-by-step diagram construction

## Architecture Overview

### Diagram Layer
- Creates and manages diagrams
- Provides methods for diagram modification
- Maintains immutability (each change creates a new instance)
- Handles coordinate system transformations
- Manages element rendering

## Element Documentation

### Base Element Properties
All elements inherit from `DrawableElement` and include these base properties:
- `x`: X-coordinate (required)
- `y`: Y-coordinate (required)
- `color`: Element color (defaults to black)

### Element Types and Parameters
- Group Element: Container for multiple elements
- Line Element: Simple line between two points
- Circle Element: Circle with radius
- Rectangle Element: Rectangle with width and height
- Text Element: Text with font settings
- Grid Element: Background grid with major/minor lines
