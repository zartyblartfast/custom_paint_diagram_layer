# Understanding Group Coordinate Systems in Process Flow Diagrams

## Overview
This document explains how coordinate systems work in our process flow diagrams, specifically focusing on the relationship between groups, rectangles, labels, and connectors.

## Key Concepts

### 1. Group Positioning
- Groups serve as local coordinate systems for their children
- A group's position becomes (0,0) for its children
- All child positions are relative to their parent group's position
- We position groups where we want the connection points (sockets) to be

### 2. Rectangle Positioning
- Rectangles are positioned relative to their parent group
- The rectangle's position is its center point
- Width and height extend equally in both directions from this center

### 3. Label Positioning
- Labels are positioned relative to their parent group
- To center a label in a rectangle, we need to:
  - Match the rectangle's center X position
  - Match the rectangle's center Y position

## Example Implementation

```dart
// Create a group with a rectangle and label
final group = GroupElement(
  x: -2,  // Group X position (where we want the socket)
  y: -2,  // Group Y position (where we want the socket)
  children: [
    RectangleElement(
      x: -1,   // Left-aligned relative to group
      y: 0.5,  // 0.5 units up from socket
      width: 2,
      height: 1,
    ),
    TextElement(
      x: 0,    // Center of rectangle (x = -1 + width/2)
      y: 1.0,  // Center of rectangle (y = 0.5 + height/2)
      text: 'R1',
    ),
  ],
);
```

## Coordinate System Breakdown

### Absolute Coordinates (Main Diagram)
```
Y = 0   ─────────────────────────
Y = -1  ─────────────────────────
Y = -1.5  Rectangle Center
Y = -2  ─── Group/Socket Position
```

### Relative Coordinates (Group's Local System)
```
Y = 1.0   Label Position
Y = 0.5   Rectangle Position
Y = 0     Group Origin
```

## Socket Points
- Socket points are calculated directly from the group's position
- No additional offset needed since we position groups where we want sockets

```dart
static Point _getSocketPoint(GroupElement group, Socket socket) {
  switch (socket) {
    case Socket.L:
      return Point(group.x - 1, group.y);  // Left socket
    case Socket.R:
      return Point(group.x + 1, group.y);  // Right socket
  }
}
```

## Best Practices

1. **Position Groups Strategically**
   - Place groups where you want connection points
   - Use group position as the reference point for sockets

2. **Child Element Positioning**
   - Position rectangles relative to desired socket point
   - Center labels by accounting for rectangle dimensions

3. **Coordinate Transformations**
   - Remember that child coordinates are relative to group
   - Final position = group position + relative position

## Common Pitfalls

1. **Incorrect Label Centering**
   - Remember to account for rectangle width/height
   - Label position should be at rectangle's center

2. **Socket Point Calculations**
   - Keep socket calculations simple
   - Use group position as the base reference

3. **Coordinate System Confusion**
   - Always be clear about which coordinate system you're working in
   - Document whether positions are absolute or relative

## Summary
By positioning groups at socket locations and using relative positioning for children, we create a simpler and more intuitive coordinate system. This approach makes it easier to:
- Position elements correctly
- Calculate connection points
- Maintain and modify the diagram layout
