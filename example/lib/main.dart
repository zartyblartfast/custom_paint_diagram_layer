import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

void main() {
  runApp(const MaterialApp(home: GroupElementDemo()));
}

class GroupElementDemo extends StatefulWidget {
  const GroupElementDemo({super.key});

  @override
  State<GroupElementDemo> createState() => _GroupElementDemoState();
}

class _GroupElementDemoState extends State<GroupElementDemo> {
  late IDiagramLayer _diagramLayer;
  double _groupY = 0.0;
  double _sliderValue = 0.0;
  late GroupElement _group;

  // Constants for coordinate system
  static const double coordRange = 10.0;
  static const double margin = 1.0;

  @override
  void initState() {
    super.initState();
    _initDiagramLayer();
  }

  void _initDiagramLayer() {
    _createDiagramLayer(_groupY);
  }

  void _createDiagramLayer(double yPosition) {
    // Create a group with overlapping elements
    _group = GroupElement(
      x: 0,
      y: yPosition,
      children: [
        // A semi-transparent blue rectangle
        RectangleElement(
          x: -1,
          y: -1,
          width: 2,
          height: 2,
          color: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.3),
        ),
        // An overlapping semi-transparent red circle
        CircleElement(
          x: 0,
          y: 0,
          radius: 1,
          color: Colors.red,
          fillColor: Colors.red.withOpacity(0.3),
        ),
      ],
    );

    // Initialize the diagram layer with coordinate axes and the group
    _diagramLayer = BasicDiagramLayer(
      coordinateSystem: const CoordinateSystem(
        origin: Offset.zero,  // Will be set by CanvasAlignment
        xRangeMin: -coordRange,
        xRangeMax: coordRange,
        yRangeMin: -coordRange,
        yRangeMax: coordRange,
        scale: 1.0,  // Will be adjusted by CanvasAlignment
      ),
      showAxes: false,  // We'll toggle axes on after adding elements
    )
      .addElement(GridElement(
        x: 0,
        y: 0,
        majorSpacing: 1.0,
        minorSpacing: 0.2,
        majorColor: Colors.grey.withOpacity(0.5),
        minorColor: Colors.grey.withOpacity(0.2),
      ))
      .addElement(_group)
      .toggleAxes();  // Add axes last as per Implementation Guide
  }

  void _updateGroupPosition(double newSliderValue) {
    // Get the relative bounds of the group
    final relativeBounds = _group.getRelativeBounds();
    print('Group bounds: $relativeBounds');
    
    // Get the coordinate system bounds
    final yMin = _diagramLayer.coordinateSystem.yRangeMin;
    final yMax = _diagramLayer.coordinateSystem.yRangeMax;
    print('Coordinate system Y range: $yMin to $yMax');
    
    // Calculate the total height of the group
    // Rectangle extends from y=-2 to y=0 (2 units)
    // Circle extends from y=-1 to y=1 (2 units)
    // Total extent is from y=-2 to y=+1 (3 units)
    // Total height = maxY - minY + 1 (to include both endpoints) = 4 units
    final groupHeight = relativeBounds.maxY - relativeBounds.minY + 1;  // Add 1 to include both endpoints
    print('Group height: $groupHeight');
    
    // Calculate the position that will keep the group within bounds
    final normalizedSlider = (newSliderValue + coordRange) / (coordRange * 2);
    print('Normalized slider: $normalizedSlider');
    
    // Calculate the actual range where the group can move
    // When slider is at minimum (0.0):
    // - Want group's minY (-2) at yMin + margin (-9)
    // - Since position is group's center, position = -9 - (-2) = -7
    final bottomPosition = (yMin + margin) - relativeBounds.minY;
    
    // When slider is at maximum (1.0):
    // - Want group's maxY (1) to be at yMax - margin (9)
    // - Since maxY is 1 unit above center, center must be at 9
    final topPosition = yMax - margin;
    
    // Calculate the group's position by directly interpolating between bottom and top positions
    final position = bottomPosition + ((topPosition - bottomPosition) * normalizedSlider);
    print('Final position: $position (bottom=$bottomPosition, top=$topPosition)');

    setState(() {
      _sliderValue = newSliderValue;
      _groupY = position;
      _createDiagramLayer(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overlapping Group Elements Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
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
                    painter: CustomPaintRenderer(_diagramLayer),
                    size: const Size(600, 600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Move Group:'),
                Expanded(
                  child: Slider(
                    min: -coordRange,
                    max: coordRange,
                    value: _sliderValue,
                    onChanged: _updateGroupPosition,
                    label: _sliderValue.toStringAsFixed(1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
