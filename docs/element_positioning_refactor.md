# Element Positioning and Bounds Refactoring

## Current Issues

### 1. Inconsistent Positioning Systems
- RectangleElement uses top-left corner as reference point
- CircleElement uses center as reference point
- GroupElement uses center as reference point for children
- This inconsistency makes bounds calculations complex and error-prone

### 2. Duplicate Bounds Calculation
- `GroupElement.getRelativeBounds()` calculates bounds one way
- `ElementBounds._calculateBounds()` calculates bounds another way
- These can give different results for the same elements
- Maintenance burden of keeping two implementations in sync

### 3. Rectangle-Group Alignment Issues
- Current inconsistency makes it difficult to align rectangles within groups
- Cannot reliably create a group with the same dimensions as its contained rectangle
- Bounds calculations assume center-based positioning for rectangles while implementation uses top-left

### 4. Connector Design Considerations
- Current socket-based approach (Top, Bottom, Left, Right) may be too restrictive
- Need to support arbitrary connection points around element perimeters
- Connectors should visually terminate at element boundaries, not centers
- Arrow heads need to be properly positioned at element boundaries
- Key questions to resolve:
  1. Should we keep fixed socket positions or allow dynamic connection points?
  2. How to calculate intersection points between connector lines and element boundaries?
  3. How to handle different element shapes (rectangles, circles, custom shapes)?
  4. Should routing be automatic or manual?

## Proposed Solutions

### 1. Standardize on Center-Based Positioning
- Update RectangleElement to use center-point positioning
- Align with existing CircleElement and GroupElement behavior
- Benefits:
  - Consistent mental model across all elements
  - Simpler bounds calculations
  - Easier alignment and grouping
  - More intuitive rotation (when implemented)

### 2. Consolidate Bounds Calculation
- Remove `getRelativeBounds()` from GroupElement
- Use `ElementBounds` as the single source of truth
- Add helper methods to ElementBounds if needed for relative bounds
- Benefits:
  - Single implementation to maintain
  - Consistent results across codebase
  - Clearer responsibility separation

### 3. Enhance Group-Rectangle Relationship
- Make it possible for a group to match its rectangle's bounds
- Add convenience methods for common group-rectangle operations
- Consider adding padding/margin options
- Benefits:
  - More intuitive group creation
  - Better support for common use cases
  - Cleaner diagram layouts

### 4. Redesign Connector System
- Use center-based positioning for initial connection vectors
- Calculate intersection points with element boundaries dynamically
- Support both fixed sockets and dynamic connection points
- Add smart routing to avoid element overlaps
- Benefits:
  - More flexible connection options
  - Cleaner visual appearance (lines stop at boundaries)
  - Better support for different element shapes
  - Proper arrow head positioning

Implementation approach:
1. Start with center-to-center vectors
2. Calculate intersection points with element boundaries
3. Trim connector lines to these points
4. Position arrow heads at intersection points
5. Add optional fixed socket positions as an overlay
6. Implement smart routing between intersection points

## Implementation Steps

### Phase 1: Rectangle Refactoring
1. Update RectangleElement:
   - Change reference point to center
   - Update constructor and documentation
   - Update render method calculations
   - Add migration notes for existing code

### Phase 2: Bounds Consolidation
1. Audit current bounds usage
2. Enhance ElementBounds as needed
3. Remove GroupElement bounds calculation
4. Update any code depending on group bounds

### Phase 3: Connector System
1. Create intersection calculation utilities
2. Update ConnectorElement to use center-based approach
3. Add dynamic boundary intersection
4. Implement arrow head positioning
5. Add smart routing (optional)
6. Test with different element types

### Phase 4: Testing and Validation
1. Create test cases for:
   - Rectangle positioning
   - Group-rectangle alignment
   - Bounds calculations
2. Visual validation of diagrams
3. Migration guide for existing code

### Phase 5: Documentation
1. Update element positioning documentation
2. Add examples of proper element alignment
3. Document best practices for groups and bounds

## Breaking Changes

This refactoring will introduce breaking changes:
1. RectangleElement positioning will change
2. GroupElement bounds API will change
3. Existing diagrams may need updates

## Migration Strategy

1. Create new versions of affected elements
2. Deprecate old versions with migration notes
3. Provide migration examples
4. Update existing diagrams in phases

## Next Steps

1. Review and refine this plan
2. Create test cases for current behavior
3. Implement RectangleElement changes
4. Test with template diagram
5. Update documentation
