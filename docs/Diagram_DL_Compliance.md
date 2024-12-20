# Diagram Layer (DL) Compliance Guide

This document defines the requirements for a diagram to be 100% compliant with the DL framework.

## Core Requirements

### 1. Coordinate System Setup
- Must use `CoordinateSystem` class for all coordinate transformations
- Origin must be set using `Offset.zero` to let DL's `CanvasAlignment` handle centering
- Must define logical coordinate ranges (xRangeMin, xRangeMax, yRangeMin, yRangeMax)
- Scale should be initialized to 1.0 (will be adjusted by `CanvasAlignment.updateScale()`)

### 2. Canvas Alignment
- Must use `CanvasAlignment` class for diagram positioning
- Call `alignCenter()` to properly center the diagram
- Let `updateScale()` handle aspect ratio and scaling automatically
- Never manually position or scale the diagram

### 3. Axis Visualization
- Must use DL's axis elements (`XAxisElement`, `YAxisElement`) for coordinate visualization
- Axes should be positioned at x=0 and y=0 respectively
- Set appropriate tick intervals for the coordinate scale
- Do not create custom axis implementations

### 4. Element Management
- All elements must inherit from `DrawableElement`
- Elements must use `coordinateSystem.mapValueToDiagram()` for all coordinate transformations
- Group elements must properly translate coordinates for their children
- Elements must implement proper bounds calculation

### 5. Layer Operations
- All diagram modifications must go through layer methods
- Never modify elements directly
- Maintain immutability - all changes create new instances
- Use `updateDiagram()` for batch updates

### 6. Rendering Pipeline
```dart
void render(Canvas canvas, Size size) {
  final alignment = CanvasAlignment(
    canvasSize: size,
    coordinateSystem: coordinateSystem,
  );
  
  alignment.alignCenter();

  for (final element in elements) {
    element.render(canvas, alignment.coordinateSystem);
  }
}
```

## Implementation Checklist

### Coordinate System
- [ ] Origin set to `Offset.zero`
- [ ] Logical coordinate ranges defined
- [ ] Scale initialized to 1.0
- [ ] Using `CanvasAlignment` for positioning

### Axes
- [ ] `XAxisElement` at y=0
- [ ] `YAxisElement` at x=0
- [ ] Appropriate tick intervals
- [ ] Proper axis labeling

### Elements
- [ ] Inheriting from `DrawableElement`
- [ ] Using `mapValueToDiagram()` for coordinates
- [ ] Implementing proper bounds
- [ ] Handling group transformations

### Layer Operations
- [ ] Using layer methods for changes
- [ ] Maintaining immutability
- [ ] Proper element management
- [ ] Batch updates when needed

## Common Issues and Solutions

### 1. Centering Problems
**Issue**: Diagram not centered properly
**Solution**: 
- Use `Offset.zero` for origin
- Let `CanvasAlignment.alignCenter()` handle positioning

### 2. Scaling Issues
**Issue**: Incorrect aspect ratio or size
**Solution**:
- Let `CanvasAlignment.updateScale()` handle scaling
- Define proper coordinate ranges
- Don't manually scale elements

### 3. Axis Problems
**Issue**: Axes not visible or misaligned
**Solution**:
- Use DL's axis elements
- Position at x=0 and y=0
- Set appropriate tick intervals

### 4. Element Positioning
**Issue**: Elements not positioned correctly
**Solution**:
- Always use `mapValueToDiagram()`
- Check coordinate system ranges
- Verify element bounds

## Running Compliance Checks

### Using the CLI Tool
The DL framework provides a command-line tool to check diagrams for compliance:

```bash
# Check a single file
dart run bin/check_diagram_compliance.dart path/to/diagram.dart

# Check all diagrams in a directory
dart run bin/check_diagram_compliance.dart path/to/diagrams/
```

The tool will analyze your diagram files and report:
- Violations: Critical issues that must be fixed
- Warnings: Potential issues that should be reviewed
- Suggestions: Best practices for better diagram implementation

Example output:
```bash
Checking kaleidoscope_art.dart...
 Class inheritance: Properly extends DiagramTestBase
 State inheritance: Properly extends DiagramTestBaseState
 Coordinate system: Uses DL's coordinate transformations
 Element creation: Uses DL's drawable elements
```

### Programmatic Compliance Checking
The DL framework provides a programmatic API for compliance checking through the `DiagramComplianceChecker` class:

```dart
import 'package:custom_paint_diagram_layer/src/diagram_compliance_checker.dart';

// Check a single file
Future<ComplianceResult> checkFile() async {
  final result = await DiagramComplianceChecker.checkFile('path/to/diagram.dart');
  
  // Access results
  print('Violations: ${result.violations}');
  print('Warnings: ${result.warnings}');
  
  // Check if diagram is fully compliant
  if (result.violations.isEmpty && result.warnings.isEmpty) {
    print('Diagram is fully DL compliant!');
  }
}

// Check multiple files in a directory
Future<void> checkDirectory() async {
  final results = await DiagramComplianceChecker.checkDirectory('path/to/diagrams/');
  
  for (final result in results) {
    print('\nChecking ${result.filePath}:');
    print('Violations: ${result.violations}');
    print('Warnings: ${result.warnings}');
  }
}
```

This is useful for:
- Integrating compliance checks into your test suite
- Running checks during CI/CD pipelines
- Building custom compliance reporting tools
- Automating diagram validation in your workflow

### Common Issues
1. Incorrect class inheritance:
   - Diagram classes must extend `DiagramTestBase`
   - State classes must extend `DiagramTestBaseState`
2. Missing coordinate transformations:
   - Use `mapValueToDiagram()` for all coordinate conversions
   - Never draw directly to canvas coordinates
3. Direct canvas manipulation:
   - Always use DL's drawable elements
   - Never call canvas methods directly

### Best Practices
1. Run compliance checks before committing changes
2. Fix all violations and review warnings
3. Document any intentional deviations from DL standards

## Available DL Elements

All diagram elements inherit from the base `DrawableElement` class and must be rendered through the DL framework's coordinate system.

### Basic Shapes

#### RectangleElement
- Properties: x, y, width, height, color, fillColor, strokeWidth, borderRadius
- Usage: Basic rectangular shapes, boxes, containers
- Example: `RectangleElement(x: 0, y: 0, width: 2, height: 1, color: Colors.black)`

#### CircleElement
- Properties: x, y, radius, color, fillColor, strokeWidth
- Usage: Dots, nodes, circular markers
- Example: `CircleElement(x: 0, y: 0, radius: 1, color: Colors.blue)`

#### EllipseElement
- Properties: x, y, radiusX, radiusY, color, fillColor, strokeWidth
- Usage: Oval shapes, stretched circles
- Example: `EllipseElement(x: 0, y: 0, radiusX: 2, radiusY: 1, color: Colors.green)`

#### PolygonElement
- Properties: points, color, fillColor, strokeWidth, closed
- Usage: Custom multi-point shapes, open/closed paths
- Example: `PolygonElement(points: [Point2D(0,0), Point2D(1,1)], color: Colors.red)`

#### ParallelogramElement
- Properties: x, y, width, height, skewAngle, color, fillColor
- Usage: 3D-effect boxes, data flow shapes
- Example: `ParallelogramElement(x: 0, y: 0, width: 2, height: 1, skewAngle: pi/6)`

#### IsoscelesTriangleElement
- Properties: x, y, width, height, color, fillColor
- Usage: Arrows, pointers, warning symbols
- Example: `IsoscelesTriangleElement(x: 0, y: 0, width: 1, height: 1)`

#### RightTriangleElement
- Properties: x, y, width, height, color, fillColor
- Usage: Corner markers, mathematical diagrams
- Example: `RightTriangleElement(x: 0, y: 0, width: 1, height: 1)`

#### StarElement
- Properties: x, y, points, innerRadius, outerRadius, color
- Usage: Ratings, decorative elements, markers
- Example: `StarElement(x: 0, y: 0, points: 5, innerRadius: 0.5, outerRadius: 1)`

### Lines and Curves

#### LineElement
- Properties: x1, y1, x2, y2, color, strokeWidth
- Usage: Basic connections, grid lines
- Example: `LineElement(x1: 0, y1: 0, x2: 1, y2: 1, color: Colors.black)`

#### DottedLineElement
- Properties: x1, y1, x2, y2, dashLength, gapLength, color
- Usage: Dashed connections, boundaries
- Example: `DottedLineElement(x1: 0, y1: 0, x2: 1, y2: 1, dashLength: 0.1)`

#### ArrowElement
- Properties: x1, y1, x2, y2, headLength, headAngle, style
- Usage: Flow indicators, pointers
- Styles: open, filled, bracket, dot, diamond
- Example: `ArrowElement(x1: 0, y1: 0, x2: 1, y2: 1, style: ArrowStyle.filled)`

#### BezierCurveElement
- Properties: start, control1, control2, end, color, strokeWidth
- Usage: Smooth curves, path animations
- Example: `BezierCurveElement(start: Point2D(0,0), end: Point2D(1,1))`

#### SpiralElement
- Properties: x, y, startRadius, endRadius, turns, color
- Usage: Decorative elements, special effects
- Example: `SpiralElement(x: 0, y: 0, startRadius: 0, endRadius: 1, turns: 2)`

#### ArcElement
- Properties: x, y, radius, startAngle, endAngle, color
- Usage: Pie charts, circular progress indicators
- Example: `ArcElement(x: 0, y: 0, radius: 1, startAngle: 0, endAngle: pi)`

### Measurement and Reference

#### AxisElement
- Properties: x, y, length, tickInterval, showLabels
- Usage: Coordinate system visualization
- Example: `XAxisElement(y: 0, length: 10, tickInterval: 1)`

#### GridElement
- Properties: xStart, xEnd, yStart, yEnd, spacing, color
- Usage: Background grids, graph paper effect
- Example: `GridElement(spacing: 1, color: Colors.grey.withOpacity(0.2))`

#### RulerElement
- Properties: x, y, length, orientation, units, color
- Usage: Measurement tools, scale indicators
- Example: `RulerElement(x: 0, y: 0, length: 10, orientation: Orientation.horizontal)`

### Containers and Groups

#### GroupElement
- Properties: elements, x, y, rotation
- Usage: Composite shapes, transformable groups
- Example: `GroupElement(elements: [circle, rectangle], x: 0, y: 0)`

### Text and Images

#### TextElement
- Properties: x, y, text, color, style
- Usage: Labels, descriptions, annotations
- Example: `TextElement(x: 0, y: 0, text: "Label", color: Colors.black)`

#### ImageElement
- Properties: x, y, width, height, image
- Usage: Icons, imported graphics
- Example: `ImageElement(x: 0, y: 0, width: 1, height: 1, image: myImage)`

### Best Practices
1. Always use the most specific element for your needs (e.g., ArrowElement instead of manual arrow construction)
2. Set appropriate strokeWidth values based on your coordinate system scale
3. Use GroupElement for complex shapes that need to be transformed together
4. Consider using fillColor with opacity for better visual hierarchy
5. Implement proper bounds calculation for custom elements

## TODO: Additional Compliance Checks
The following checks will be added to improve diagram validation:

1. **Coordinate System Compliance**
   - Proper use of `Point2D` for all point-based operations
   - No direct use of Flutter's `Offset` for diagram coordinates
   - Correct coordinate transformations using `mapValueToDiagram`
   - Consistent handling of nested element coordinates
   - Proper x/y vs dx/dy property usage

2. **Element Position Validation**
   - Check element bounds against coordinate system ranges
   - Validate nested element positions relative to parents
   - Ensure proper scaling of coordinates with zoom/pan

3. **Render Method Analysis**
   - Verify all canvas operations use transformed coordinates
   - Check for direct canvas manipulation
   - Validate proper use of DL's drawing primitives

These checks will help catch common coordinate-related issues early in development.

## Notes and Uncertainties

1. **Axis Handling**
   - The framework supports both automatic axis addition through `showAxes` and manual axis elements
   - Need clarification on preferred approach for different use cases

2. **Coordinate Ranges**
   - No strict requirements on range values
   - Should be chosen based on diagram content and desired aspect ratio

3. **Scale Management**
   - Initial scale value's impact on final rendering
   - Interaction between manual scale and `CanvasAlignment`

4. **Group Elements**
   - Optimal handling of nested coordinate transformations
   - Performance implications of deep nesting

## References

1. `Layer_Architecture.md` - Core architecture principles
2. `Element_Architecture.md` - Element implementation details
3. `engineering_coords_test.dart` - Reference implementation
4. `BasicDiagramLayer` implementation - Source of truth for layer behavior
   - Performance implications of deep nesting

## References

1. `Layer_Architecture.md` - Core architecture principles
2. `Element_Architecture.md` - Element implementation details
3. `engineering_coords_test.dart` - Reference implementation
4. `BasicDiagramLayer` implementation - Source of truth for layer behavior
