# Flutter Diagram Prompt Template

## 1. Context
**Task:** Create a diagram using the custom software layer designed for Flutter.

**Available Classes:**
- `CoordinateSystem`: For defining coordinate transformations
- `Diagram`: For managing and rendering elements
- `LineElement`, `RectangleElement`, and `TextElement`: For adding primitives
- `CustomPaintRenderer`: For rendering the diagram

## 2. Diagram Setup
**Coordinate System Configuration:**
- Origin: `(100, 100)`
- X-Axis Range: `-50` to `50`
- Y-Axis Range: `0` to `100`
- Scale: `1.5`

## 3. Diagram Elements
Add the following elements:
1. A red line from `(-30, 20)` to `(30, 80)`
2. A blue rectangle at `(-20, 10)` with width `40` and height `20`
3. A label at `(0, 50)` with the text "Center" and black color

## 4. Expected Output
Return a Flutter widget as a `CustomPaint` implementation that renders the above diagram. The axes should be visible for debugging purposes.

## 5. Example Code Structure
```dart
class ExampleDiagramWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Step 1: Define the coordinate system
    CoordinateSystem coordinateSystem = CoordinateSystem(
      origin: Offset(100, 100),
      xRangeMin: -50,
      xRangeMax: 50,
      yRangeMin: 0,
      yRangeMax: 100,
      scale: 1.5,
    );

    // Step 2: Create the diagram
    Diagram diagram = Diagram(coordinateSystem: coordinateSystem);

    // Step 3: Add elements
    diagram.addElement(LineElement(-30, 20, 30, 80, Colors.red));
    diagram.addElement(RectangleElement(-20, 10, 40, 20, Colors.blue));
    diagram.addElement(TextElement(0, 50, "Center"));

    // Step 4: Enable debugging axes
    diagram.toggleAxes();

    // Step 5: Render using CustomPaintRenderer
    return CustomPaint(
      painter: CustomPaintRenderer(diagram),
      size: Size.infinite,
    );
  }
}
```

## 6. Follow-Up Instructions
1. **Testing:**
   - Verify all elements are placed correctly
2. **Debugging:**
   - If elements appear misplaced, verify coordinates using `CoordinateSystem` mapping methods
3. **Iterative Changes:**
   - Modify elements or add new ones using the `addElement` method on the `Diagram` class
