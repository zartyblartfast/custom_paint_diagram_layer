# Group Element Positioning Implementation Notes

## Critical Concepts

1. **Center Point vs Visual Extent**
   - Group's position (x,y) represents its CENTER point
   - Visual extent is determined by child elements' bounds
   - Must account for distance from center to edges when positioning

2. **Bounds and Height Calculation**
   ```dart
   // Example group:
   GroupElement(
     children: [
       RectangleElement(y: -1, height: 2),  // Extends -2 to 0
       CircleElement(y: 0, radius: 1),      // Extends -1 to +1
     ]
   )
   // Total height = maxY - minY + 1 = 4 units (include endpoints)
   ```

3. **Position Calculation for Margins**
   ```dart
   // To touch bottom margin:
   bottomPosition = (yMin + margin) - relativeBounds.minY
   
   // To touch top margin:
   topPosition = yMax - margin  // Direct target for center
   ```

## Asymmetric Boundary Handling

The calculation for top and bottom boundaries must be handled differently:

1. **Bottom Boundary**
   ```dart
   yMin = coordinateSystem.yRangeMin + margin + (elementHeight / 2)
   ```
   - Must include elementHeight/2 because we position from center
   - Ensures bottom edge stays margin units above diagram bottom

2. **Top Boundary**
   ```dart
   yMax = coordinateSystem.yRangeMax - margin
   ```
   - Does NOT subtract elementHeight/2
   - Center position at yMax-margin puts top edge at correct position
   - Adding elementHeight/2 would double-count the element height

## Position Mapping Formula
```dart
position = yMin + (sliderValue - yRangeMin) / (yRangeMax - yRangeMin) * (yMax - yMin)
```

### Example Calculations (4-unit tall element, 1-unit margin)
1. At slider minimum (-10):
   - Position = -7 (edges: -9 to -5)
   - Bottom edge 1 unit above diagram bottom

2. At slider maximum (10):
   - Position = 9 (edges: 7 to 11)
   - Top edge 1 unit below diagram top

## Common Pitfalls
- Don't subtract relative bounds from target position
- Remember to include both endpoints in height calculation
- Position represents group's center, not its edges
- Don't assume symmetric calculations for top/bottom boundaries
- Validate edge cases with actual position calculations

## Layer Management Lessons

1. **Immutability Requirements**
   ```dart
   // CORRECT: Chain operations and capture new instance
   var newLayer = BasicDiagramLayer(...)
       .addElement(_grid)
       .addElement(element);
   
   // INCORRECT: Direct modification
   diagramLayer.elements.add(element);
   ```

2. **State Updates**
   - Always capture new layer instances
   - Use setState() to update layer reference
   - Never modify layer or elements directly
   - Chain operations for multiple changes

3. **Initialization Pattern**
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

4. **Testing Infrastructure**
   - Use base classes for common functionality
   - Maintain consistent coordinate system setup
   - Handle grid and axes uniformly
   - Provide standard UI controls

See full debugging case study in: `docs/case_studies/group_positioning_debug.md` 