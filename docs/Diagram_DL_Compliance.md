# Diagram Layer (DL) Compliance Guide

This document defines the requirements for a diagram to be 100% compliant with the DL framework.

## Core Requirements

### 1. Renderer Architecture
- Must extend `DiagramRendererBase` for all diagram implementations
- Override `createCoordinateSystem()` to define coordinate space
- Override `createElements()` to define diagram elements
- Use provided mixins for additional functionality:
  - `DiagramControllerMixin` for state management
  - `DiagramMigrationHelper` for slider support

### 2. Coordinate System Setup
- Must use `CoordinateSystem` class for all coordinate transformations
- Define logical coordinate ranges in `createCoordinateSystem()`
- Initialize scale appropriately for the diagram's needs
- Example:
  ```dart
  @override
  CoordinateSystem createCoordinateSystem() {
    return CoordinateSystem(
      origin: Offset.zero,
      xRangeMin: -10,
      xRangeMax: 10,
      yRangeMin: -10,
      yRangeMax: 10,
      scale: 1.0,
    );
  }
  ```

### 3. Element Usage
- All drawing MUST use DL element classes
- Never use Flutter's Canvas directly
- Elements must be created in `createElements()`
- All elements require:
  - Position parameters (x, y)
  - Color parameter for stroke
- Example:
  ```dart
  @override
  List<DrawableElement> createElements() {
    return [
      CircleElement(
        x: 0,
        y: 0,
        radius: 1.0,
        color: Colors.black,
      ),
      // Other elements...
    ];
  }
  ```

### 4. State Management
- Use `DiagramController` for all state changes
- Define control points as static constants
- Update elements through controller methods
- Example:
  ```dart
  static const String controlKey = 'control1';
  
  void updateState(double value) {
    controller.setValue(controlKey, value);
    updateElements();
  }
  ```

### 5. Integration Patterns
- Support both standalone and embedded modes
- Use proper widget hierarchy
- Handle controls appropriately
- Example:
  ```dart
  class MyDiagramDemo extends StatefulWidget {
    final bool useStandalone;
    final bool showControls;
    // ...
  }
  ```

## Implementation Checklist

### Renderer Setup
- [ ] Extends `DiagramRendererBase`
- [ ] Implements required methods
- [ ] Uses appropriate mixins
- [ ] Proper constructor with config

### Coordinate System
- [ ] Defined in `createCoordinateSystem()`
- [ ] Appropriate coordinate ranges
- [ ] Proper scale initialization
- [ ] Origin handling

### Elements
- [ ] Created in `createElements()`
- [ ] Using DL element classes only
- [ ] Required parameters provided
- [ ] Proper positioning

### State Management
- [ ] Using `DiagramController`
- [ ] Control points defined
- [ ] Proper update methods
- [ ] State initialization

## Common Issues and Solutions

### 1. Direct Canvas Usage
**Issue**: Using Flutter's Canvas directly
**Solution**: 
- Always use DL element classes
- Create custom elements if needed by extending `DrawableElement`

### 2. State Management
**Issue**: Direct state modification
**Solution**:
- Use controller for all state changes
- Update through proper methods
- Initialize state in constructor

### 3. Coordinate System
**Issue**: Incorrect coordinate mapping
**Solution**:
- Define appropriate ranges
- Use proper scale
- Let coordinate system handle transformations

### 4. Element Creation
**Issue**: Elements created outside `createElements()`
**Solution**:
- Create all elements in `createElements()`
- Update through controller
- Rebuild when needed

## Best Practices

### Element Creation
```dart
// Good
CircleElement(
  x: 0,
  y: 0,
  radius: 1.0,
  color: Colors.black,
)

// Bad - Don't use Canvas directly
canvas.drawCircle(...)
```

### State Management
```dart
// Good
controller.setValue(key, value);
updateElements();

// Bad - Don't modify state directly
_value = newValue;
```

### Coordinate System
```dart
// Good
createCoordinateSystem() {
  return CoordinateSystem(
    origin: Offset.zero,
    xRangeMin: -10,
    xRangeMax: 10,
    yRangeMin: -10,
    yRangeMax: 10,
    scale: 1.0,
  );
}

// Bad - Don't create outside method
CoordinateSystem(...) // in constructor
```

## Compliance Checker

Use the `DiagramComplianceChecker` to verify your implementation:

```dart
void checkCompliance() {
  final checker = DiagramComplianceChecker();
  final results = checker.checkDiagram(MyDiagram());
  
  for (final issue in results.issues) {
    print('${issue.severity}: ${issue.message}');
  }
}
```

## Reference Examples

See these compliant implementations:
- `migrated_butterfly_art.dart` - Full featured example
- `standalone_migrated_main.dart` - Standalone integration
- `embedded_migrated_main.dart` - Embedded integration
