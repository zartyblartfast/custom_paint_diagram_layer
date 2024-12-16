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

## Common Pitfalls
- Don't subtract relative bounds from target position
- Remember to include both endpoints in height calculation
- Position represents group's center, not its edges

See full debugging case study in: `docs/case_studies/group_positioning_debug.md` 