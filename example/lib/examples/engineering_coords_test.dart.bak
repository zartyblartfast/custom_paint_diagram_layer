import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/testing/diagram_test_base.dart';

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
    return [
      GroupElement(
        x: mapper.mapSliderToPosition(sliderValue: xSliderValue, isXAxis: true),
        y: mapper.mapSliderToPosition(sliderValue: ySliderValue, isXAxis: false),
        children: [
          // Rectangle centered at x=0 (extends -1 to +1), y=-1 (extends -2 to 0)
          RectangleElement(
            x: -1,   // Left edge at x=-1 to center width=2 rectangle
            y: 0,    // Top edge at y=0
            width: 2,
            height: 2,
            color: Colors.blue,
            fillColor: Colors.blue.withOpacity(0.3),
          ),
          // Circle centered at x=0, y=1 (bottom edge at y=0)
          CircleElement(
            x: 0,    // Center on x=0
            y: 1,    // Center at y=1, bottom edge at y=0
            radius: 1,
            color: Colors.red,
            fillColor: Colors.red.withOpacity(0.3),
          ),
        ],
      ),
    ];
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