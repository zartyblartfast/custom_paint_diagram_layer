import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/line_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/rectangle_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/text_element.dart';

void main() {
  runApp(const DiagramApp());
}

class DiagramApp extends StatelessWidget {
  const DiagramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Paint Diagram Layer Example'),
        ),
        body: const Center(
          child: DiagramWidget(),
        ),
      ),
    );
  }
}

class DiagramWidget extends StatefulWidget {
  const DiagramWidget({super.key});

  @override
  State<DiagramWidget> createState() => _DiagramWidgetState();
}

class _DiagramWidgetState extends State<DiagramWidget> {
  late Diagram _diagram;
  bool _showAxes = true;

  @override
  void initState() {
    super.initState();
    _initializeDiagram();
  }

  void _initializeDiagram() {
    _diagram = Diagram(
      coordinateSystem: CoordinateSystem(
        origin: const Offset(200, 200), // Center of canvas
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: -10,
        yRangeMax: 10,
        scale: 15,
      ),
      elements: [
        LineElement(x1: -5, y1: -5, x2: 5, y2: 5, color: Colors.red),
        LineElement(x1: -5, y1: 5, x2: 5, y2: -5, color: Colors.blue),
        RectangleElement(x: 0, y: 0, width: 4, height: 3, color: Colors.green.withOpacity(0.5)),
        TextElement(x: 0, y: 0, text: 'Center', color: Colors.black),
        TextElement(x: -5, y: -5, text: '(-5,-5)', color: Colors.red),
        TextElement(x: 5, y: 5, text: '(5,5)', color: Colors.red),
        TextElement(x: -5, y: 5, text: 'topLeft', color: Colors.blue),
      ],
      showAxes: _showAxes,
    ).addAxesToDiagram();
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
            painter: CustomPaintRenderer(_diagram),
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Show Coordinate Axes'),
          value: _showAxes,
          onChanged: (bool value) {
            setState(() {
              _showAxes = value;
              _diagram = _diagram.toggleAxes();
            });
          },
        ),
      ],
    );
  }
}
