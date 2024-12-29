# Bounds Calculation Design

## Current Problem

### Part 1: Coordinate Systems
The core issue is inconsistent coordinate systems between elements:

1. **Rectangle Coordinates**:
   - RectangleElement uses (x,y) as top-left corner in its constructor
   - But GroupElement's getRelativeBounds() treats rectangle's (x,y) as center point
   - This mismatch causes the -0.5 offset seen in process flow diagrams

2. **Group Coordinates**:
   - GroupElement has its own (x,y) reference point
   - Child elements are positioned relative to this point
   - But the bounds calculation mixes center-based and corner-based math

### Part 2: Connector System
The current connector system has limitations:

1. **Fixed Socket Positions**:
   - Currently limited to T(op), B(ottom), L(eft), R(ight) midpoints
   - No support for arbitrary connection points
   - Doesn't take advantage of center points

2. **Connection Specification**:
   ```dart
   // Current approach
   ConnectorElement(
     startElement: rect1,
     startSocket: SocketPosition.bottom,
     endElement: rect2,
     endSocket: SocketPosition.top,
   )
   ```

## Proposed Solution

### 1. Standardize on Center Points
```dart
class RectangleElement extends DrawableElement {
  // Change constructor to use center point
  const RectangleElement({
    required double centerX,
    required double centerY,
    required this.width,
    required this.height,
    ...
  }) : super(x: centerX, y: centerY, ...);

  // Add helpers for different reference points
  Point get topLeft => Point(x - width/2, y - height/2);
  Point get center => Point(x, y);
  
  // New: Calculate any point on rectangle's perimeter
  Point getPerimeterPoint(double angle) {
    // Returns point where a line from center at given angle intersects perimeter
    // Useful for dynamic connector attachment points
  }
}
```

### 2. Enhanced Connector System

#### Option A: Relative Position Connectors
```dart
class ConnectorElement extends DrawableElement {
  // Connect using relative positions (-1.0 to 1.0 on each axis)
  const ConnectorElement({
    required DrawableElement start,
    required Point startRelative, // (-1,-1) is top-left, (1,1) is bottom-right
    required DrawableElement end,
    required Point endRelative,
  });
  
  // Example: Connect from 75% up right side to 25% down left side
  // startRelative: Point(1.0, -0.5)  // Right side, 25% from top
  // endRelative: Point(-1.0, 0.5)    // Left side, 25% from bottom
}
```

#### Option B: Center-Based Smart Connectors
```dart
class SmartConnectorElement extends DrawableElement {
  // Connect centers, but draw only between rectangles
  const SmartConnectorElement({
    required DrawableElement start,
    required DrawableElement end,
    ConnectorStyle style = ConnectorStyle.direct,
  });
  
  @override
  void render(Canvas canvas) {
    // 1. Calculate line between centers
    // 2. Find intersection points with rectangles
    // 3. Draw only the segment between rectangles
    // 4. Apply style (direct, manhattan, curved)
  }
}
```

#### Option C: Hybrid System
```dart
class FlexibleConnectorElement extends DrawableElement {
  // Supports both specific points and automatic routing
  const FlexibleConnectorElement({
    required DrawableElement start,
    ConnectionPoint startPoint = ConnectionPoint.auto,
    required DrawableElement end,
    ConnectionPoint endPoint = ConnectionPoint.auto,
    RoutingStyle routingStyle = RoutingStyle.smart,
  });
}

enum ConnectionPoint {
  auto,        // Calculate best point based on relative positions
  center,      // Use element's center
  topMid,      // Traditional socket positions
  bottomMid,
  leftMid,
  rightMid,
  custom,      // Use custom relative position
}
```

### Benefits of New Design
1. **Consistency**: All elements use center-based coordinates
2. **Flexibility**: Connectors can attach anywhere on rectangle perimeter
3. **Simplicity**: Smart routing reduces need for manual socket placement
4. **Compatibility**: Can still support traditional T,B,L,R sockets if needed

## Testing

1. **Basic Tests**:
   - 2x1 rectangle standalone vs. in group
   - Verify bounds and positioning are identical

2. **Connector Tests**:
   - Test all connection point types
   - Verify smart routing between rectangles
   - Check center-point calculations
   - Test relative position connections

## Migration Path

1. **Update Elements**:
   - Convert to center-based coordinates
   - Add perimeter calculation methods
   - Update bounds calculations

2. **Enhance Connectors**:
   - Add new connector types
   - Implement smart routing
   - Add relative position support

3. **Update Diagrams**:
   - Remove manual offsets
   - Convert to new connector system
   - Test all connection scenarios

## Future Enhancements

### 1. Mermaid-Style Smart Routing
```dart
class SmartRoutingConnector extends ConnectorElement {
  void route() {
    // 1. Find all potential obstacles (rectangles) between start and end
    // 2. Calculate optimal path avoiding obstacles
    // 3. Add curved segments around obstacles
    // 4. Minimize line crossings
  }
}
```

### 2. Auto-Orientation & Layout
```dart
enum DiagramOrientation {
  topToBottom,    // Traditional flow
  leftToRight,    // Horizontal flow
  bottomToTop,    // Reverse flow
  rightToLeft     // RTL support
}

class DiagramLayout {
  void applyLayout({
    required DiagramOrientation orientation,
    required List<DrawableElement> elements,
    required List<ConnectorElement> connections,
  }) {
    // Automatically position elements based on orientation
    // Adjust connector routing
    // Optimize spacing and distribution
  }
}
```

### 3. Text-Based Diagram Specification
```
// Example syntax
diagram LR                    // Left to Right orientation
A[Start] -> B[Process]       // Simple connection
B -> {                       // Branch
  C[Path 1]                  // Multiple paths
  D[Path 2]
}
C -> E[End]                  // Merge paths
D -> E
```

Benefits:
1. **Quick Creation**: Rapidly prototype diagrams using text
2. **Version Control**: Easy to track changes in text format
3. **Programmatic Generation**: Generate diagrams from code or data
4. **Consistent Styling**: Automatic layout ensures consistent look

### Implementation Strategy

#### 1. Smart Routing Algorithm
```dart
class PathFinder {
  List<Point> findPath({
    required Point start,
    required Point end,
    required List<Rectangle> obstacles,
  }) {
    // 1. Create visibility graph
    // 2. Apply A* pathfinding
    // 3. Smooth path with Bezier curves
    // 4. Optimize corner rounding
  }
}
```

#### 2. Layout Engine
```dart
class AutoLayout {
  // Layout algorithms
  void applyHierarchicalLayout() {
    // Layered approach for flow diagrams
    // 1. Assign layers
    // 2. Minimize crossings
    // 3. Assign coordinates
  }

  void applyForceDirectedLayout() {
    // For more organic layouts
    // Uses spring forces between nodes
  }
}
```

#### 3. Text Parser
```dart
class DiagramParser {
  static Diagram fromText(String spec) {
    // Grammar for diagram specification:
    // diagram [orientation] [theme?]
    // node [options]
    // connection [type] [source] [target]
    // group { ... }
  }
}
```

### Phased Implementation Plan

1. **Phase 1: Foundation**
   - Complete center-based coordinate system
   - Implement basic connector routing

2. **Phase 2: Smart Routing**
   - Add obstacle detection
   - Implement path smoothing
   - Add corner rounding

3. **Phase 3: Auto Layout**
   - Add orientation support
   - Implement hierarchical layout
   - Add force-directed layout option

4. **Phase 4: Text Format**
   - Design specification language
   - Implement parser
   - Add diagram generation