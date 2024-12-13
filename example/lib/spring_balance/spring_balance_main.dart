import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/line_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/custom_paint_renderer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/layers/layers.dart';

class SpringBalanceDiagram extends StatefulWidget {
  const SpringBalanceDiagram({super.key});

  @override
  State<SpringBalanceDiagram> createState() => _SpringBalanceDiagramState();
}

class _SpringBalanceDiagramState extends State<SpringBalanceDiagram> {
  late IDiagramLayer _layer;
  double _springLength = 5.0; // Initial spring length
  bool _showAxes = true;

  @override
  void initState() {
    super.initState();
    _initializeDiagram();
  }

  void _initializeDiagram() {
    // Create initial layer with coordinate system
    _layer = BasicDiagramLayer(
      coordinateSystem: CoordinateSystem(
        origin: const Offset(200, 200),  // Center of canvas
        xRangeMin: -5,
        xRangeMax: 5,
        yRangeMin: -10,  // More vertical space for spring
        yRangeMax: 10,
        scale: 20, // Pixels per unit
      ),
      showAxes: _showAxes,
    );

    // Add initial spring line
    _layer = _layer.addElement(
      LineElement(
        x1: 0.5,  // Slightly offset from y-axis
        y1: 0,
        x2: 0.5,  // Keep same x to make vertical
        y2: -_springLength,   // Use state variable for length
        color: Colors.black,
      ),
    );
  }

  void _updateSpring(double newLength) {
    setState(() {
      _springLength = newLength;
      
      // Create new layer with updated spring
      _layer = BasicDiagramLayer(
        coordinateSystem: _layer.coordinateSystem,
        showAxes: _layer.showAxes,
      ).addElement(
        LineElement(
          x1: 0.5,
          y1: 0,
          x2: 0.5,
          y2: -newLength,
          color: Colors.black,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: CustomPaint(
            painter: CustomPaintRenderer(_layer),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text('Spring Length: ${_springLength.toStringAsFixed(1)}'),
                SizedBox(
                  width: 200,
                  child: Slider(
                    value: _springLength,
                    min: 1.0,
                    max: 9.0,
                    divisions: 80,
                    label: _springLength.toStringAsFixed(1),
                    onChanged: _updateSpring,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showAxes = !_showAxes;
                  _layer = _layer.toggleAxes();
                });
              },
              child: Text(_showAxes ? 'Hide Axes' : 'Show Axes'),
            ),
          ],
        ),
      ],
    );
  }
}
