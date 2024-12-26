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

### 2. Configuration Management
- Use `DiagramConfig` for initial display settings:
  ```dart
  DiagramConfig(
    width: 500,      // Canvas width
    height: 500,     // Canvas height
    showAxes: true,  // Show coordinate axes
    showGrid: true,  // Show background grid
    showFrame: true, // Show diagram frame
  )
  ```
- Update configuration through `updateConfig()` method
- Maintain state consistency with display flags

### 3. Coordinate System Setup
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

### 4. Element Usage
- All drawing MUST use DL element classes
- Never use Flutter's Canvas directly
- Elements must be created in `createElements()`
- Add elements in correct order (frame, grid, axes, custom elements)
- All elements require:
  - Position parameters (x, y)
  - Color parameter for stroke
- Example:
  ```dart
  @override
  List<DrawableElement> createElements() {
    final elements = <DrawableElement>[];

    // Add frame if enabled
    if (_showFrame) {
      elements.add(FrameElement(
        color: _frameStrokeColor,
        strokeWidth: _frameStrokeWidth,
        fillColor: _frameFillColor,
        opacity: _frameOpacity,
      ));
    }

    // Add grid if enabled
    if (_showGrid) {
      elements.add(GridElement(
        x: 0,
        y: 0,
        majorSpacing: 1.0,
        minorSpacing: 0.2,
        majorColor: Colors.grey.withOpacity(0.5),
        minorColor: Colors.grey.withOpacity(0.2),
      ));
    }

    // Add custom elements
    elements.add(CircleElement(
      x: 0,
      y: 0,
      radius: 1.0,
      color: Colors.black,
    ));

    return elements;
  }
  ```

### 5. State Management
- Use private variables for element state
- Provide getters/setters for controlled access
- Call `updateElements()` when state changes
- Example:
  ```dart
  // State variables
  bool _showFrame = true;
  double _frameStrokeWidth = 1.0;
  Color _frameStrokeColor = Colors.blueAccent;

  // Getters/Setters
  bool get showFrame => _showFrame;
  set showFrame(bool value) {
    _showFrame = value;
    updateElements();
  }
  ```

### 6. UI Integration
- Use `buildDiagramWidget()` for Flutter integration
- Center diagram in display area
- Match UI colors for consistency
- Example:
  ```dart
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(_title),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: diagram.buildDiagramWidget(context),
        ),
      ),
    );
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
- [ ] Using private variables with getters/setters
- [ ] Controlled access to state
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
- Use private variables with getters/setters
- Call `updateElements()` after state changes
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
