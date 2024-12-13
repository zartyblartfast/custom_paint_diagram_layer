import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/line_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/rectangle_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/text_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/axis_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/layers/layers.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/custom_paint_renderer.dart';
import 'spring_balance/spring_balance_main.dart';

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
          title: const Text('Custom Paint Diagram Layer Examples'),
        ),
        body: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: DiagramWidget(),
              ),
              Expanded(
                child: SpringBalanceDiagram(),
              ),
            ],
          ),
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
  late IDiagramLayer _layer;
  bool _showAxes = true;

  @override
  void initState() {
    super.initState();
    _initializeDiagram();
  }

  void _initializeDiagram() {
    _layer = BasicDiagramLayer(
      coordinateSystem: CoordinateSystem(
        origin: const Offset(200, 400), // Bottom center
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: 0,  // No negative y values
        yRangeMax: 20, // Doubled to maintain same scale
        scale: 15,
      ),
      showAxes: _showAxes,
    );

    // Add axes if needed
    if (_showAxes) {
      _layer = _layer
        .addElement(const XAxisElement(yValue: 0))
        .addElement(const YAxisElement(xValue: 0));
    }

    // Add example elements
    _layer = _layer
      .addElement(
        LineElement(x1: -5, y1: 5, x2: 5, y2: 15, color: Colors.red),
      )
      .addElement(
        LineElement(x1: -5, y1: 15, x2: 5, y2: 5, color: Colors.blue),
      )
      .addElement(
        RectangleElement(x: 0, y: 10, width: 4, height: 3, color: Colors.green.withOpacity(0.5)),
      )
      .addElement(
        TextElement(x: 0, y: 10, text: 'Center', color: Colors.black),
      )
      .addElement(
        TextElement(x: -5, y: 5, text: '(-5,5)', color: Colors.red),
      )
      .addElement(
        TextElement(x: 5, y: 15, text: '(5,15)', color: Colors.red),
      )
      .addElement(
        TextElement(x: -5, y: 15, text: 'topLeft', color: Colors.blue),
      );
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
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showAxes = !_showAxes;
              if (_showAxes) {
                _layer = _layer
                  .addElement(const XAxisElement(yValue: 0))
                  .addElement(const YAxisElement(xValue: 0));
              } else {
                _layer = BasicDiagramLayer(
                  coordinateSystem: _layer.coordinateSystem,
                  elements: _layer.elements.where((e) => 
                    !(e is XAxisElement || e is YAxisElement)
                  ).toList(),
                  showAxes: false,
                );
              }
            });
          },
          child: Text(_showAxes ? 'Hide Axes' : 'Show Axes'),
        ),
      ],
    );
  }
}
