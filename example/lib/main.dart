import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/layers/layers.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/custom_paint_renderer.dart';
import 'spring_balance/spring_balance_main.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Test loading the image directly
  try {
    final data = await rootBundle.load('assets/observer.png');
    print('Successfully loaded observer.png: ${data.lengthInBytes} bytes');
  } catch (e) {
    print('Failed to load observer.png: $e');
  }
  
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

    // Add other elements
    _layer = _layer
      .addElement(
        GridElement(
          majorSpacing: 1.0,
          minorSpacing: 0.2,
          majorColor: Colors.grey.shade400,
          minorColor: Colors.grey.shade200,
          majorStyle: GridLineStyle.solid,
          minorStyle: GridLineStyle.dotted,
          opacity: 0.3,
        ),
      )
      .addElement(
        RulerElement(
          x: _layer.coordinateSystem.xRangeMin,
          y: 0,
          length: _layer.coordinateSystem.xRangeMax - _layer.coordinateSystem.xRangeMin,
          orientation: RulerOrientation.horizontal,
          majorTickSpacing: 1.0,
          minorTickSpacing: 0.2,
          majorTickLength: 0.3,
          minorTickLength: 0.15,
          color: Colors.black87,
          labelSize: 10.0,
          numberFormat: (value) => value.toStringAsFixed(0),
        ),
      )
      .addElement(
        RulerElement(
          x: 0,
          y: _layer.coordinateSystem.yRangeMin,
          length: _layer.coordinateSystem.yRangeMax - _layer.coordinateSystem.yRangeMin,
          orientation: RulerOrientation.vertical,
          majorTickSpacing: 1.0,
          minorTickSpacing: 0.2,
          majorTickLength: 0.3,
          minorTickLength: 0.15,
          color: Colors.black87,
          labelSize: 10.0,
          numberFormat: (value) => value.toStringAsFixed(0),
        ),
      )
      .addElement(
        LineElement(
          x1: -5, 
          y1: 5, 
          x2: 5, 
          y2: 15, 
          color: Colors.red,
          strokeWidth: 2.0,
          dashPattern: [5, 5],
        ),
      )
      .addElement(
        LineElement(x1: -5, y1: 15, x2: 5, y2: 5, color: Colors.blue),
      )
      .addElement(
        RectangleElement(
          x: 0,
          y: 10,
          width: 4,
          height: 3,
          color: Colors.green,
          strokeWidth: 2.0,
          fillColor: Colors.green,
          fillOpacity: 0.2,
        ),
      )
      .addElement(
        CircleElement(
          x: -2,
          y: 8,
          radius: 1.5,
          color: Colors.purple,
          strokeWidth: 2.0,
          fillColor: Colors.purple,
          fillOpacity: 0.3,
        ),
      )
      // Add our test image element
      .addElement(
        ImageElement(
          x: 0,
          y: 2,
          source: ImageSource.network,
          path: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',  // Simple static image
          width: 4,
          height: 4,
          opacity: 1.0,
        ),
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
