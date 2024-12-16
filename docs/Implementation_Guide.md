# Implementation Guide

## Core Principle
The fundamental principle of our implementation is that **all diagram modifications must go through the diagram layer**. This ensures consistent behavior, proper state management, and maintainable code.

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

#### TextElement
Text display with styling support.
```dart
TextElement(
  x: 0,
  y: 0,
  text: 'Sample Text',
  color: Colors.black,
  style: TextStyle(...),  // Optional Flutter TextStyle
)
```
- Use `style` parameter for text formatting (fontSize, fontWeight, etc.)
- Color can be set via `color` parameter or in `style`
- Text is centered at (x, y) coordinates

#### DottedLineElement
Line with various dash/dot patterns and automatic scaling.
```dart
DottedLineElement(
  x: 0,           // Start x
  y: 0,           // Start y
  endX: 1,        // End x
  endY: 1,        // End y
  color: Colors.black,
  strokeWidth: 1.0,
  pattern: DashPattern.dotted,  // dotted, dashed, dashDot, custom
  spacing: 0.3,    // Base spacing unit (will be scaled)
  customPattern: [0.8, 0.3, 0.4, 0.3],  // Required for custom pattern
)
```

**Pattern Types:**
- `dotted`: Regular dots (...) with even spacing
- `dashed`: Regular dashes (---) with length 3x spacing
- `dashDot`: Alternating dash and dot (-.-.) with proportional spacing
- `custom`: User-defined pattern of dashes and gaps

**Spacing and Scaling:**
- Base spacing is automatically scaled by coordinate system
- Pattern lengths are relative to spacing:
  - Dotted: `[0, spacing]`
  - Dashed: `[spacing * 3, spacing]`
  - DashDot: `[spacing * 2, spacing * 0.8, spacing * 0.5, spacing]`
  - Custom: Each value scaled independently

**Implementation Notes:**
- Dots are rendered as filled circles
- Dashes are rendered as line segments
- Patterns automatically adjust to line angle
- Validates spacing > 0 and strokeWidth > 0
- Early return if start and end points are identical

**Best Practices:**
- Use small spacing (0.2-0.5) for dense patterns
- Adjust strokeWidth based on scale
- Test patterns at different zoom levels
- Consider line length when choosing pattern
- Use custom patterns for special effects

**Example Usage:**
```dart
// Dense dotted line
DottedLineElement(
  x: 0, y: 0, endX: 5, endY: 0,
  pattern: DashPattern.dotted,
  spacing: 0.3,
  strokeWidth: 2,
),

// Medium dashed line
DottedLineElement(
  x: 0, y: 1, endX: 5, endY: 1,
  pattern: DashPattern.dashed,
  spacing: 0.4,
  strokeWidth: 2,
),

// Dash-dot line
DottedLineElement(
  x: 0, y: 2, endX: 5, endY: 2,
  pattern: DashPattern.dashDot,
  spacing: 0.35,
  strokeWidth: 2,
),

// Custom pattern
DottedLineElement(
  x: 0, y: 3, endX: 5, endY: 3,
  pattern: DashPattern.custom,
  customPattern: [0.8, 0.3, 0.4, 0.3],
  strokeWidth: 2,
),
```

#### LineElement
Basic solid or dashed line.
```dart
LineElement(
  x1: 0,          // Start x
  y1: 0,          // Start y
  x2: 1,          // End x
  y2: 1,          // End y
  color: Colors.black,
  strokeWidth: 1.0,
  dashPattern: [5, 5],  // Optional dash pattern
)
```
- Use `dashPattern` for simple dashed lines
- Pattern alternates between dash and gap lengths
- Solid line when dashPattern is null

#### CircleElement
Circle with optional fill.
```dart
CircleElement(
  x: 0,           // Center x
  y: 0,           // Center y
  radius: 1.0,
  color: Colors.black,
  strokeWidth: 1.0,
  fillColor: Colors.blue,  // Optional
  fillOpacity: 1.0,       // Optional, 0.0 to 1.0
)
```
- Center position at (x, y)
- Fill is disabled if fillColor is null
- Stroke only affects outline

#### GridElement
Reference grid with major and minor lines.
```dart
GridElement(
  x: 0,              // Grid origin x
  y: 0,              // Grid origin y
  majorSpacing: 1.0,
  minorSpacing: 0.2,
  majorColor: Colors.grey,
  minorColor: Colors.grey.withOpacity(0.5),
  majorStrokeWidth: 1.0,
  minorStrokeWidth: 0.5,
  majorStyle: GridLineStyle.solid,  // solid, dotted, dashed
  minorStyle: GridLineStyle.solid,
  opacity: 1.0,
)
```
- Extends to diagram boundaries
- Major lines more prominent than minor
- Different styles for major/minor lines

#### ArrowElement
Line with arrowhead.
```dart
ArrowElement(
  x1: 0,             // Start x
  y1: 0,             // Start y
  x2: 1,             // End x
  y2: 1,             // End y
  color: Colors.black,
  strokeWidth: 1.0,
  headLength: 20.0,  // Length of arrowhead
  headAngle: pi/6,   // Angle of arrowhead (radians)
  style: ArrowStyle.open,  // open, filled, bracket, dot, diamond
)
```
- Multiple arrowhead styles
- Head size controlled by length and angle
- Consistent stroke width throughout

### Best Practices

1. **Parameter Validation**
   - Check for positive values (width, radius, spacing)
   - Validate ranges (opacity 0.0-1.0)
   - Ensure required parameters for patterns

2. **Style Consistency**
   - Use similar stroke widths for related elements
   - Maintain consistent color schemes
   - Consider opacity for overlapping elements

3. **Pattern Usage**
   - Use appropriate spacing for visibility
   - Consider scale when setting sizes
   - Test patterns at different zoom levels

4. **Text Handling**
   - Use TextStyle for consistent formatting
   - Consider text alignment and overflow
   - Test with different text lengths

## Implementation Pattern

### 1. State Management
- **Approach**: 
  - Immutable diagram layer - all changes create new instances
  - Widget state holds layer reference
  - Changes reflected through setState()
- **Example**:
  ```dart
  _layer = BasicDiagramLayer(
    coordinateSystem: CoordinateSystem(...),
    showAxes: true,
  );
  ```

### 2. Element Management
- **Approach**:
  - All element operations go through layer methods
  - Elements are immutable
  - New instances created for modifications
- **Example**:
  ```dart
  // Correct - using diagram layer methods
  _layer = _layer.addElement(newElement);
  _layer = _layer.toggleAxes();

  // Incorrect - bypassing diagram layer
  _layer.elements.add(newElement);  // Don't do this!
  ```

### 3. Coordinate System
- **Implementation**:
  - CoordinateSystem class handles all transformations
  - Used by all elements for rendering
  - Maintained by diagram layer

## Example: Spring Balance Diagram
```dart
void _updateSpring(double newLength) {
  setState(() {
    _springLength = newLength;
    
    // Using diagram layer methods for modification
    _layer = BasicDiagramLayer(
      coordinateSystem: _layer.coordinateSystem,
      showAxes: _layer.showAxes,
    ).addElement(
      LineElement(
        x1: 0.5,
        y1: 0,
        x2: 0.5,
        y2: -newLength,
        color: Colors.black,
      ),
    );
  });
}
```

## Current Considerations

### 1. Performance
- **Challenge**: Impact of immutability on performance
- **Solutions**:
  - Efficient element management
  - Careful state updates
  - Consider caching if needed

### 2. Extensibility
- **Challenge**: Adding new diagram types
- **Solutions**:
  - Follow established pattern
  - Use diagram layer methods
  - Maintain immutability

### 3. Testing
- **Approach**:
  - Test layer methods
  - Verify immutability
  - Check coordinate transformations

## Future Considerations

### 1. Style System
- Integration with style system while maintaining architecture principles
- Keep immutability

### 2. Advanced Features
- Animation support
- Interactive elements
- Multiple diagram types

### 3. Performance Optimization
- Caching strategies
- Efficient rendering
- State management optimization

## Guidelines
1. Always use diagram layer methods for modifications
2. Never modify diagram elements directly
3. Maintain immutability
4. Keep UI logic separate from diagram logic
