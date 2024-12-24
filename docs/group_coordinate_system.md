# Understanding Group Coordinate Systems in Custom Paint Diagrams

## Overview
This document explains how coordinate systems work in our diagram system, specifically focusing on the relationship between groups and their child elements. Groups serve as containers that provide local coordinate systems for their children.

## Key Concepts

### 1. Group Positioning
- Groups serve as local coordinate systems for their children
- A group's position (x, y) becomes the reference point for its children
- All child positions are relative to their parent group's position
- Groups maintain their own coordinate system transformation

### 2. Coordinate System Transformation
The group's coordinate system is created by:
1. Saving the current canvas state
2. Creating a translated coordinate system for children
3. Rendering children using the translated system
4. Restoring the canvas state

```dart
@override
void render(Canvas canvas, CoordinateSystem coordinateSystem) {
  // Save canvas state
  canvas.save();
  
  // Get group position in diagram coordinates
  final groupPosition = coordinateSystem.mapValueToDiagram(x, y);
  
  // Create translated coordinate system
  final groupCoordinateSystem = CoordinateSystem(
    origin: coordinateSystem.origin + Offset(
      groupPosition.dx - coordinateSystem.origin.dx,
      groupPosition.dy - coordinateSystem.origin.dy
    ),
    xRangeMin: coordinateSystem.xRangeMin,
    xRangeMax: coordinateSystem.xRangeMax,
    yRangeMin: coordinateSystem.yRangeMin,
    yRangeMax: coordinateSystem.yRangeMax,
    scale: coordinateSystem.scale,
  );

  // Render children with translated system
  for (final child in children) {
    child.render(canvas, groupCoordinateSystem);
  }

  // Restore canvas state
  canvas.restore();
}
```

### 3. Bounds Calculation
Groups calculate bounds in two ways:

#### Relative Bounds
```dart
// Returns bounds relative to group position
({double minX, double maxX, double minY, double maxY}) getRelativeBounds() {
  // Handle empty groups
  if (children.isEmpty) {
    return (minX: 0, maxX: 0, minY: 0, maxY: 0);
  }

  // Calculate bounds for each child type
  for (final child in children) {
    if (child is RectangleElement) {
      minX = math.min(minX, child.x - child.width / 2);
      maxX = math.max(maxX, child.x + child.width / 2);
      // ... similar for Y coordinates
    } else if (child is CircleElement) {
      minX = math.min(minX, child.x - child.radius);
      maxX = math.max(maxX, child.x + child.radius);
      // ... similar for Y coordinates
    }
    // ... handle other element types
  }
}
```

#### Absolute Bounds
```dart
// Returns bounds in absolute coordinates
({double minX, double maxX, double minY, double maxY}) getBounds() {
  final relativeBounds = getRelativeBounds();
  return (
    minX: x + relativeBounds.minX,
    maxX: x + relativeBounds.maxX,
    minY: y + relativeBounds.minY,
    maxY: y + relativeBounds.maxY,
  );
}
```

## Bounds Testing and Validation

The engineering coordinates test (`devtest/demos/engineering_coords_test.dart`) demonstrates advanced group bounds handling, particularly for:
1. Bounds calculation with nested elements
2. Out-of-bounds detection
3. Position adjustment to keep groups in bounds

### Bounds Calculation Example

```dart
// Create a group with overlapping elements
var group = GroupElement(
  x: proposedX,
  y: proposedY,
  children: [
    RectangleElement(
      x: -1,    // Left edge relative to group
      y: -2,    // Bottom edge relative to group
      width: 2,
      height: 2,
      color: Colors.blue,
    ),
    CircleElement(
      x: 0,     // Center on vertical line
      y: 1,     // One unit up from group center
      radius: 1,
      color: Colors.red,
    ),
  ],
);
```

### Bounds Validation and Adjustment

```dart
// Check if group is within diagram bounds
final coords = diagramLayer.coordinateSystem;
final bounds = ElementBounds(group, coords);

// If out of bounds, adjust position
double dx = 0.0;
double dy = 0.0;
if (bounds.minX < coords.xRangeMin) {
  dx = coords.xRangeMin - bounds.minX;
}
if (bounds.maxX > coords.xRangeMax) {
  dx = coords.xRangeMax - bounds.maxX;
}
if (bounds.minY < coords.yRangeMin) {
  dy = coords.yRangeMin - bounds.minY;
}
if (bounds.maxY > coords.yRangeMax) {
  dy = coords.yRangeMax - bounds.maxY;
}

// Create new group with adjusted position if needed
if (dx != 0.0 || dy != 0.0) {
  group = GroupElement(
    x: group.x + dx,
    y: group.y + dy,
    children: group.children,
  );
}
```

### Bounds Diagnostics

The test provides detailed bounds information:
- Group center position
- Element bounds dimensions
- Corner coordinates
- Out-of-bounds detection
- Affected edges when out of bounds

Example diagnostic output:
```
Group Element Position:
Center: (2.5, 3.0)

Element Bounds:
Width: 4.0
Height: 4.0
Center: (2.5, 3.0)
Top-Left: (0.5, 5.0)
Top-Right: (4.5, 5.0)
Bottom-Left: (0.5, 1.0)
Bottom-Right: (4.5, 1.0)

Boundary Check:
Outside Diagram Bounds: No
```

### Best Practices for Bounds Handling

1. **Proactive Bounds Checking**
   - Check bounds before finalizing group position
   - Adjust position to keep elements visible
   - Consider both group position and child elements

2. **Bounds Calculation**
   - Account for all child element types
   - Include element dimensions (width, height, radius)
   - Consider element transformations

3. **Position Adjustment**
   - Adjust position incrementally
   - Maintain relative positions of child elements
   - Use copyWith for immutable updates

4. **Diagnostic Support**
   - Add bounds visualization in development
   - Include detailed bounds information
   - Track out-of-bounds conditions

### Common Bounds Issues

1. **Calculation Errors**
   - Not including all element dimensions
   - Incorrect relative position calculations
   - Missing element type handling

2. **Adjustment Problems**
   - Over-aggressive bounds correction
   - Lost relative positioning
   - Infinite adjustment loops

3. **Performance Impact**
   - Excessive bounds recalculation
   - Unnecessary position adjustments
   - Complex bounds checking logic

## Example Implementation

```dart
// Create a group with a rectangle and label
final group = GroupElement(
  x: 100,  // Group reference point X
  y: 100,  // Group reference point Y
  children: [
    RectangleElement(
      x: 0,     // Centered on group
      y: 0,     // Centered on group
      width: 200,
      height: 100,
      color: Colors.blue,
    ),
    TextElement(
      x: 0,     // Centered on group
      y: 0,     // Centered on group
      text: 'Hello',
      color: Colors.black,
    ),
    CircleElement(
      x: -100,  // Left of group center
      y: 0,     // At group center Y
      radius: 10,
      color: Colors.red,
    ),
  ],
);

// Create a copy with updated position
final movedGroup = group.copyWith(
  x: 200,  // New X position
  y: 150,  // New Y position
);
```

## Best Practices

### 1. Group Organization
- Use groups to organize related elements
- Keep group hierarchies shallow for better performance
- Consider bounds when positioning child elements

### 2. Coordinate System Usage
- Remember that child coordinates are relative to group
- Use getRelativeBounds() for internal calculations
- Use getBounds() when needing absolute positions

### 3. Element Positioning
- Position elements relative to group center (0, 0)
- Account for element dimensions in positioning
- Use copyWith() for position updates

### 4. Performance Considerations
- Minimize deep group nesting
- Cache bounds calculations when possible
- Use appropriate coordinate system scaling

## Common Pitfalls

### 1. Coordinate Confusion
- Mixing absolute and relative coordinates
- Not accounting for group position in calculations
- Incorrect bounds calculation for complex elements

### 2. Transformation Issues
- Not saving/restoring canvas state
- Incorrect coordinate system translation
- Scale factor mismatches

### 3. Performance Problems
- Excessive group nesting
- Unnecessary bounds recalculation
- Too many child elements in a single group

## Reference Examples

See these implementations for practical examples:
- `migrated_butterfly_art.dart` - Complex group usage
- `standalone_migrated_main.dart` - Basic group positioning
- `embedded_migrated_main.dart` - Interactive group manipulation
