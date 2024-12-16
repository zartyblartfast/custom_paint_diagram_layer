# Implementation Guide

## Core Principle
The fundamental principle of our implementation is that **all diagram modifications must go through the diagram layer**. This ensures consistent behavior, proper state management, and maintainable code.

+ ## Key Use Cases
+ 
+ ### 1. Static Diagrams
+ - Fixed educational illustrations
+ - Technical documentation
+ - System architecture diagrams
+ 
+ ### 2. Dynamic Diagrams
+ - Interactive learning tools
+ - Real-time data visualization
+ - Animated demonstrations
+ - User-controlled element positioning
+ - Physics simulations
+ - Step-by-step diagram construction
+ 
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

#### AxisElement
Coordinate axis with ticks and labels.
```dart
XAxisElement(
  yValue: 0,           // Position on Y-axis
  tickInterval: 1.0,   // Space between ticks
  color: Colors.black,
)

YAxisElement(
  xValue: 0,           // Position on X-axis
  tickInterval: 1.0,   // Space between ticks
  color: Colors.black,
)
```
- Automatically handles tick marks and labels
- Scales with coordinate system
- Can be toggled via `layer.toggleAxes()`
- Initial visibility set via `showAxes` parameter in BasicDiagramLayer
+ 
+ **Important Note on Axis Initialization:**
+ When you want axes to be visible on initial diagram creation, use this pattern:
+ ```dart
+ // Create layer with showAxes: false initially
+ var layer = BasicDiagramLayer(
+   coordinateSystem: coordSystem,
+   showAxes: false,
+ );
+ 
+ // Add your elements...
+ layer = layer.addElement(...);
+ 
+ // Toggle axes on before returning the layer
+ return layer.toggleAxes();
+ ```
+ This ensures the coordinate axes are properly displayed when the diagram first loads.

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
  - Coordinate axes can be toggled with `toggleAxes()`
- **Example**:
  ```dart
  // Correct - using diagram layer methods
  _layer = _layer.addElement(newElement);
  _layer = _layer.toggleAxes();  // Toggle coordinate axes visibility

  // Incorrect - bypassing diagram layer
  _layer.elements.add(element);  // Don't do this!
  _layer.showAxes = false;      // Don't do this!
  ```

### 3. Coordinate System
- **Implementation**:
  - CoordinateSystem class handles all transformations
  - Used by all elements for rendering
  - Maintained by diagram layer

+ **Coordinate System Configuration:**
+ ```dart
+ final coordSystem = CoordinateSystem(
+   // For bottom-center X-axis with Y-axis going up:
+   origin: Offset(canvasWidth/2, canvasHeight),  // Place origin at bottom center
+   scale: 50,  // Pixels per unit
+   xRangeMin: -5,  // X-axis extends left from origin
+   xRangeMax: 5,   // X-axis extends right from origin
+   yRangeMin: 0,   // Y-axis starts at origin
+   yRangeMax: 10,  // Y-axis extends up from origin
+ );
+ ```
+ 
+ **Common Configurations:**
+ 1. Center Origin (traditional Cartesian):
+    ```dart
+    origin: Offset(canvasWidth/2, canvasHeight/2),
+    yRangeMin: -5,  // Extends down from origin
+    yRangeMax: 5,   // Extends up from origin
+    ```
+ 
+ 2. Bottom X-axis (engineering/graphing):
+    ```dart
+    origin: Offset(canvasWidth/2, canvasHeight),
+    yRangeMin: 0,    // Starts at origin
+    yRangeMax: 10,   // Extends up only
+    ```
+ 
+ **Important Notes:**
+ - Origin position affects entire coordinate system
+ - Scale factor determines pixels per coordinate unit
+ - Y-axis is inverted in screen coordinates (positive down)
+ - Coordinate ranges should match diagram content needs
+ - Consider canvas size when setting ranges and scale

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

+ ### Interactive Element Positioning
+ One of the key strengths of the Diagram Layer is its ability to create dynamic, interactive diagrams. This is particularly useful for:
+ - Educational tools where students can manipulate elements
+ - Interactive demonstrations of concepts
+ - Real-time visualization of data or calculations
+ - User-driven diagram modifications
+ 
+ To implement interactive control of element positions:
+ 
+ 1. **State Management**
+ ```dart
+ class _MyWidgetState extends State<MyWidget> {
+   late IDiagramLayer _layer;
+   double _elementPosition = 0.0;  // Track position
+ 
+   @override
+   void initState() {
+     super.initState();
+     _layer = _createDiagram();
+   }
+ }
+ ```
+ 
+ 2. **Slider Implementation**
+ ```dart
+ // For vertical movement, rotate the slider
+ SizedBox(
+   height: diagramHeight,
+   child: RotatedBox(
+     quarterTurns: 3,  // Make slider vertical
+     child: Slider(
+       value: _elementPosition,
+       min: -5.0,
+       max: 5.0,
+       onChanged: (value) {
+         setState(() {
+           _elementPosition = value;
+           _layer = _createDiagram();  // Recreate diagram with new position
+         });
+       },
+     ),
+   ),
+ ),
+ ```
+ 
+ 3. **Element Positioning**
+ ```dart
+ // Use the tracked position in element creation
+ layer.addElement(
+   CircleElement(
+     x: 0,
+     y: _elementPosition,  // Use controlled position
+     radius: 0.3,
+     color: Colors.blue,
+   ),
+ );
+ ```
+ 
+ **Important Notes:**
+ - Slider range should match coordinate system range
+ - Recreate entire diagram on position changes to maintain immutability
+ - Consider performance with complex diagrams
+ - Use appropriate step values for precise control

### 3. Performance Optimization
- Caching strategies
- Efficient rendering
- State management optimization

## Guidelines
1. Always use diagram layer methods for modifications
2. Never modify diagram elements directly
3. Maintain immutability
4. Keep UI logic separate from diagram logic
