import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/line_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/rectangle_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/text_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/axis_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/layers/layers.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/coordinate_system.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/custom_paint_renderer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diagram Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Diagram Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late IDiagramLayer _diagramLayer;

  @override
  void initState() {
    super.initState();
    _diagramLayer = BasicDiagramLayer(
      coordinateSystem: CoordinateSystem(
        origin: const Offset(150, 150),
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: -10,
        yRangeMax: 10,
        scale: 20,
      ),
      showAxes: true,
    );

    // Add axes
    _diagramLayer = _diagramLayer
      .addElement(const XAxisElement(yValue: 0))
      .addElement(const YAxisElement(xValue: 0));

    // Add a rectangle and other elements
    _diagramLayer = _diagramLayer
      .addElement(
        RectangleElement(
          x: -2,
          y: -1.5,
          width: 4,
          height: 3,
          color: Colors.blue.withOpacity(0.3),
        ),
      )
      .addElement(
        TextElement(
          x: 0,
          y: 0,
          text: 'Center',
          color: Colors.black,
        ),
      )
      .addElement(
        LineElement(
          x1: -5,
          y1: 5,
          x2: 5,
          y2: -5,
          color: Colors.red,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: CustomPaint(
            painter: CustomPaintRenderer(_diagramLayer),
          ),
        ),
      ),
    );
  }
}
