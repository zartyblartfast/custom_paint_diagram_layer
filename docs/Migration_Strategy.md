# Migration Strategy: Element Style Architecture

## Overview

This document outlines the strategy for migrating from the current element implementation to the new Element Style Architecture. The migration is designed to be gradual and non-breaking, allowing for smooth transition while maintaining functionality throughout the process.

## Migration Phases

### Phase 1: Parallel Implementation
**Goal**: Set up new architecture alongside existing code without breaking changes.

1. **Directory Structure**
   ```
   lib/
   ├── custom_paint_diagram_layer/
   │   ├── elements/           # Current elements
   │   └── styled/            # New styled implementation
   │       ├── styles/        # Style system
   │       ├── properties/    # Property interfaces
   │       └── elements/      # New element implementations
   ```

2. **Implementation Steps**
   - Create new `styled` directory structure
   - Implement base style system (`DiagramStyle`, etc.)
   - Implement property interfaces and mixins
   - Create element manager
   - Add new element implementations with "v2" suffix (e.g., `RectangleElementV2`)

3. **Version Strategy**
   ```dart
   // Current implementation remains unchanged
   export 'elements/rectangle_element.dart';
   
   // New implementation available but not exported by default
   export 'styled/elements/rectangle_element.dart' show RectangleElementV2;
   ```

### Phase 2: Adapter Layer
**Goal**: Allow gradual migration of existing code.

1. **Create Adapters**
   ```dart
   /// Adapts legacy elements to new style system
   class LegacyElementAdapter {
     static DiagramElement adapt(DrawableElement legacy) {
       if (legacy is RectangleElement) {
         return _adaptRectangle(legacy);
       }
       // ... other element adaptations
     }
     
     static RectangleElementV2 _adaptRectangle(RectangleElement legacy) {
       return RectangleElementV2(
         id: 'legacy_${legacy.hashCode}',
         x: legacy.x,
         y: legacy.y,
         width: legacy.width,
         height: legacy.height,
         strokeStyle: StrokeStyle(color: legacy.color),
         fillStyle: DiagramStyles.transparent,
       );
     }
   }
   ```

2. **Update Diagram Class**
   ```dart
   class Diagram {
     // Add support for both legacy and new elements
     final List<DrawableElement> _legacyElements;
     final DiagramElementManager _styledElements;
     
     void render(Canvas canvas, Size size) {
       // Render legacy elements
       for (final element in _legacyElements) {
         element.render(canvas, _coordinateSystem);
       }
       
       // Render styled elements
       for (final element in _styledElements.getOrderedElements()) {
         element.render(canvas, _coordinateSystem);
       }
     }
   }
   ```

### Phase 3: Gradual Migration
**Goal**: Migrate existing code piece by piece.

1. **Migration Path for Example App**
   ```dart
   // Before
   final diagram = Diagram(
     elements: [
       LineElement(x1: -5, y1: 5, x2: 5, y2: 15, color: Colors.red),
     ],
   );
   
   // After
   final diagram = Diagram(
     elements: [
       LineElementV2(
         id: 'line1',
         x1: -5,
         y1: 5,
         x2: 5,
         y2: 15,
         strokeStyle: DiagramStyles.createStroke(color: Colors.red),
       ),
     ],
   );
   ```

2. **Update Strategy**
   - Start with new features using new system
   - Gradually migrate existing features
   - Use adapters for mixed usage
   - Add tests for both systems

### Phase 4: Legacy Cleanup
**Goal**: Remove old implementation when migration is complete.

1. **Deprecation Notices**
   ```dart
   @Deprecated('Use RectangleElementV2 instead')
   class RectangleElement extends DrawableElement {
     // ... existing implementation
   }
   ```

2. **Cleanup Steps**
   - Mark old classes as deprecated
   - Update documentation to reference new system
   - Remove "V2" suffix from new implementations
   - Remove adapter layer
   - Delete legacy code

## Layer-Based Migration Strategy

The migration leverages the hybrid layer architecture to provide a smooth transition:

### Phase 1: Layer Interface
1. **Create Base Interfaces**
   ```dart
   // Define common layer behavior
   abstract class IDiagramLayer {
     CoordinateSystem get coordinateSystem;
     void render(Canvas canvas, Size size);
   }
   
   // Wrap existing implementation
   class BasicDiagramLayer implements IDiagramLayer {
     // ... existing diagram implementation
   }
   ```

2. **Factory Setup**
   ```dart
   class DiagramLayerFactory {
     static IDiagramLayer create({
       required CoordinateSystem coordinateSystem,
       bool useStyleSystem = false,
     }) {
       return useStyleSystem
         ? StyledDiagramLayer(coordinateSystem: coordinateSystem)
         : BasicDiagramLayer(coordinateSystem: coordinateSystem);
     }
   }
   ```

### Phase 2: Parallel Implementation
Instead of creating a parallel element hierarchy, we create a new layer implementation:

```dart
lib/
├── custom_paint_diagram_layer/
│   ├── layers/
│   │   ├── basic_layer.dart    # Existing functionality
│   │   └── styled_layer.dart   # New style-aware layer
│   ├── styles/                 # Style system
│   └── elements/              # Shared elements
```

### Phase 3: Gradual Migration
Users can opt-in to the new system on a per-diagram basis:

```dart
// Legacy usage remains unchanged
final basicDiagram = DiagramLayerFactory.create(
  coordinateSystem: myCoordinateSystem,
);

// Opt-in to styled system
final styledDiagram = DiagramLayerFactory.create(
  coordinateSystem: myCoordinateSystem,
  useStyleSystem: true,
);
```

## Migration Guidelines

### 0. Implementation Notes and Pitfalls

This section documents key learnings from implementation attempts to help avoid common pitfalls:

#### Critical Mistakes to Avoid
1. **Don't Modify Base Interfaces Prematurely**
   - ❌ Adding generics to `IDiagramLayer`
   - ❌ Modifying existing element interfaces
   - ✅ Keep existing interfaces stable during parallel implementation

2. **Don't Skip the Directory Structure**
   - ❌ Modifying code in place
   - ❌ Mixing new and old implementations
   - ✅ Set up proper directory structure first:
     ```
     lib/
     ├── custom_paint_diagram_layer/
     │   ├── elements/           # Existing code stays here
     │   └── styled/            # All new code goes here
     ```

3. **Don't Force Early Integration**
   - ❌ Using generics for compatibility
   - ❌ Modifying existing tests
   - ✅ Use the adapter layer as designed

#### Correct Implementation Order
1. Set up new directory structure completely
2. Implement style system in isolation
3. Create new elements with "v2" suffix
4. Build adapter layer for compatibility
5. Allow opt-in through factory pattern
6. Gradually migrate as needed

#### Key Principles
- Existing code remains untouched
- New features built in parallel
- Adapters handle compatibility
- Migration is optional and gradual

### 1. Testing Strategy
- Maintain existing tests for legacy code
- Write tests for new implementations
- Add tests for adapter layer
- Test mixed usage scenarios

### 2. Documentation
- Document both systems during transition
- Update examples to use new system
- Provide migration guides for each element type
- Keep track of migration progress

### 3. Version Management
- Use semantic versioning
- Major version bump for new system
- Maintain compatibility in minor versions
- Document breaking changes

## Timeline and Milestones

1. **Phase 1: Parallel Implementation**
   - Week 1: Set up new directory structure
   - Week 1-2: Implement style system
   - Week 2-3: Implement new elements

2. **Phase 2: Adapter Layer**
   - Week 3: Create adapter system
   - Week 3-4: Update diagram class
   - Week 4: Testing and documentation

3. **Phase 3: Gradual Migration**
   - Week 4+: Begin migrating example app
   - Ongoing: Support migration of existing code
   - Ongoing: Add new features using new system

4. **Phase 4: Legacy Cleanup**
   - After migration complete: Add deprecation notices
   - Future version: Remove legacy code

## Risk Mitigation

1. **Compatibility Issues**
   - Extensive testing of adapter layer
   - Clear documentation of differences
   - Support for mixed usage

2. **Performance Impact**
   - Benchmark both systems
   - Optimize adapter layer
   - Profile memory usage

3. **Migration Challenges**
   - Provide migration scripts if needed
   - Offer support for complex cases
   - Allow extended transition period

## Success Criteria

1. **Functionality**
   - All features work in new system
   - No regression in existing features
   - Performance meets or exceeds current system

2. **Code Quality**
   - Clean separation of concerns
   - Improved maintainability
   - Better extensibility

3. **User Impact**
   - Smooth transition for users
   - Clear migration path
   - Minimal disruption

## Next Steps

1. Begin with Phase 1:
   - Create new directory structure
   - Implement base style system
   - Create first new element implementation

2. Review and adjust plan based on:
   - Implementation feedback
   - User needs
   - Timeline constraints
