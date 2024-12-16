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
  late DiagramLayer _diagramLayer;
  double _groupY = 0.0;

  @override
  void initState() {
    super.initState();
    _initDiagramLayer();
  }

  void _initDiagramLayer() {
    // Create a group of elements
    final group = GroupElement(
      x: 0,
      y: _groupY,
      children: [
        // A circle
        CircleElement(
          x: -2,
          y: 0,
          radius: 1,
          color: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.3),
        ),
        // A rectangle
        RectangleElement(
          x: 1,
          y: 0,
          width: 2,
          height: 2,
          color: Colors.red,
          fillColor: Colors.red.withOpacity(0.3),
        ),
        // A connecting line
        LineElement(
          x1: -2,
          y1: 0,
          x2: 1,
          y2: 0,
          color: Colors.green,
          strokeWidth: 2,
        ),
      ],
    );

    // Initialize the diagram layer with the group
    _diagramLayer = DiagramLayer()
      .addElement(GridElement(
        x: 0,
        y: 0,
        majorSpacing: 1.0,
        minorSpacing: 0.2,
        majorColor: Colors.grey.withOpacity(0.5),
        minorColor: Colors.grey.withOpacity(0.2),
      ))
      .addElement(group);
  }

  void _updateGroupPosition(double newY) {
    setState(() {
      _groupY = newY;
      // Update the diagram with a new group at the new position
      _diagramLayer = _diagramLayer.copyWith(
        elements: [
          _diagramLayer.elements.first, // Keep the grid
          (_diagramLayer.elements.last as GroupElement).copyWith(y: newY), // Update group position
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Element Demo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: CustomPaint(
                  painter: CustomPaintRenderer(_diagramLayer),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Move Group:'),
                Expanded(
                  child: Slider(
                    min: -5,
                    max: 5,
                    value: _groupY,
                    onChanged: _updateGroupPosition,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 