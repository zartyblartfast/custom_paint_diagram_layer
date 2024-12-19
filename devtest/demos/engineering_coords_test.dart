import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import '../utils/diagram_test_base.dart';

/// Demonstrates element positioning with engineering-style coordinates.
/// 
/// Key features demonstrated:
/// - X-axis at bottom of diagram (y = 0)
/// - Y-axis extends up from X-axis (positive only)
/// - Group element with overlapping shapes
void main() {
  runApp(const MaterialApp(home: EngineeringCoordsTest()));
}

/// Test widget showing engineering coordinate system layout
class EngineeringCoordsTest extends DiagramTestBase {
  const EngineeringCoordsTest({super.key}) 
      : super(title: 'Engineering Coordinates Test');

  @override
  EngineeringCoordsTestState createState() => EngineeringCoordsTestState();
}

/// State for the engineering coordinates test
class EngineeringCoordsTestState extends DiagramTestBaseState<EngineeringCoordsTest> {
  @override
  double get elementHeight => 4.0;

  // Slider values (normalized 0-1)
  double xSliderValue = 0.5;  // Start at center
  double ySliderValue = 0.5;  // Start at center

  void updateXPosition(double value) {
    setState(() {
      xSliderValue = value;
      final oldElements = diagramLayer.elements.whereType<GroupElement>().toList();
      final newElements = createElements(ySliderValue);
      diagramLayer = diagramLayer.updateDiagram(
        elementUpdates: newElements,
        removeElements: oldElements,
      );
    });
  }

  void updateYPosition(double value) {
    setState(() {
      ySliderValue = value;
      final oldElements = diagramLayer.elements.whereType<GroupElement>().toList();
      final newElements = createElements(ySliderValue);
      diagramLayer = diagramLayer.updateDiagram(
        elementUpdates: newElements,
        removeElements: oldElements,
      );
    });
  }

  @override
  List<DrawableElement> createElements(double sliderValue) {
    final mapper = CoordinateMapper(diagramLayer.coordinateSystem);

    // Get the desired positions from the sliders
    var proposedX = mapper.mapSliderToPosition(sliderValue: xSliderValue, isXAxis: true);
    var proposedY = mapper.mapSliderToPosition(sliderValue: ySliderValue, isXAxis: false);

    // Create the group element at the proposed position
    var group = GroupElement(
      x: proposedX,
      y: proposedY,
      children: [
        RectangleElement(
          x: -1,    // Center at x=0: left edge = center - width/2 = 0 - 2/2 = -1
          y: -2,    // Center at y=-1: top edge = center - height/2 = -1 - 2/2 = -2
          width: 2,
          height: 2,
          color: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.3),
        ),
        CircleElement(
          x: 0,     // Center on vertical line
          y: 1,     // One unit up from group center
          radius: 1,
          color: Colors.red,
          fillColor: Colors.red.withOpacity(0.3),
        ),
      ],
    );

    // Check the group bounds
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

    if (dx != 0.0 || dy != 0.0) {
      group = GroupElement(
        x: group.x + dx,
        y: group.y + dy,
        children: group.children,
      );
    }

    return [group];
  }

  @override
  Widget build(BuildContext context) {
    // Get coordinate system info from diagram layer
    final coords = diagramLayer.coordinateSystem;

    // Get group element
    final group = diagramLayer.elements.whereType<GroupElement>().first;
    final bounds = ElementBounds(group, coords);

    return Scaffold(
      appBar: AppBar(
        title: SelectableText(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Row(
        children: [
          // Diagram area (left side)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 600,
                        height: 600,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: CustomPaint(
                          painter: CustomPaintRenderer(diagramLayer),
                          size: const Size(600, 600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // X slider (horizontal, below diagram)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 20),  // Space for label
                      const Text('X:'),
                      SizedBox(
                        width: 150,  // 25% of diagram width
                        child: Slider(
                          min: 0,
                          max: 1,
                          value: xSliderValue,
                          onChanged: updateXPosition,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Y slider (vertical, right of diagram)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Y:'),
                SizedBox(
                  height: 150,  // 25% of diagram height
                  child: RotatedBox(
                    quarterTurns: 3,  // Rotate slider to vertical
                    child: Slider(
                      min: 0,
                      max: 1,
                      value: ySliderValue,
                      onChanged: updateYPosition,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Diagnostic info (right side)
          SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SelectableRegion(
                selectionControls: materialTextSelectionControls,
                focusNode: FocusNode(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Coordinate System:',
                        style: Theme.of(context).textTheme.titleMedium),
                    Text('X range: ${coords.xRangeMin} to ${coords.xRangeMax}'),
                    Text('Y range: ${coords.yRangeMin} to ${coords.yRangeMax}'),
                    const SizedBox(height: 16),
                    Text('Group Element Position:',
                        style: Theme.of(context).textTheme.titleMedium),
                    Text('Center: (${group.x.toStringAsFixed(1)}, ${group.y.toStringAsFixed(1)})'),
                    
                    const SizedBox(height: 8),
                    Text('Element Bounds:',
                        style: Theme.of(context).textTheme.titleMedium),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Width: ${bounds.width.toStringAsFixed(1)}'),
                        Text('Height: ${bounds.height.toStringAsFixed(1)}'),
                        Text('Center: (${bounds.centerX.toStringAsFixed(1)}, ${bounds.centerY.toStringAsFixed(1)})'),
                        Text('Top-Left: (${bounds.minX.toStringAsFixed(1)}, ${bounds.maxY.toStringAsFixed(1)})'),
                        Text('Top-Right: (${bounds.maxX.toStringAsFixed(1)}, ${bounds.maxY.toStringAsFixed(1)})'),
                        Text('Bottom-Left: (${bounds.minX.toStringAsFixed(1)}, ${bounds.minY.toStringAsFixed(1)})'),
                        Text('Bottom-Right: (${bounds.maxX.toStringAsFixed(1)}, ${bounds.minY.toStringAsFixed(1)})'),
                        const SizedBox(height: 16),
                        Text('Boundary Check:',
                            style: Theme.of(context).textTheme.titleMedium),
                        Text('Outside Diagram Bounds: ${bounds.isOutsideDiagramBounds() ? "Yes" : "No"}'),
                        if (bounds.isOutsideDiagramBounds()) ...[
                          const SizedBox(height: 8),
                          Text('Out of Bounds Edges:', 
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                          ...bounds.getOutOfBoundsEdges().entries.map(
                            (e) => Text('${e.key.toUpperCase()}: ${e.value ? "Yes" : "No"}')
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
