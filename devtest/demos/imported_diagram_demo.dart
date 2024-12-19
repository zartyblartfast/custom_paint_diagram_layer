import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

class ImportedDiagramDemo extends StatefulWidget {
  const ImportedDiagramDemo({super.key});
  @override
  State<ImportedDiagramDemo> createState() => _ImportedDiagramDemoState();
}

class _ImportedDiagramDemoState extends State<ImportedDiagramDemo> {
  late IDiagramLayer diagramLayer;

  @override
  void initState() {
    super.initState();
    diagramLayer = _createDiagramLayer();
  }

  IDiagramLayer _createDiagramLayer() {
    return BasicDiagramLayer(
      coordinateSystem: CoordinateSystem(
        origin: const Offset(400, 300),
        xRangeMin: -400,
        xRangeMax: 400,
        yRangeMin: -300,
        yRangeMax: 300,
        scale: 1.0,
      ),
      elements: [
        LineElement(
          x1: -200.0,
          y1: -150.0,
          x2: 200.0,
          y2: 150.0,
          color: const Color(0xff0000ff),
          strokeWidth: 3.0,
        ),
        LineElement(
          x1: -200.0,
          y1: 150.0,
          x2: 200.0,
          y2: -150.0,
          color: const Color(0xffff0000),
          strokeWidth: 3.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imported Diagram Demo'),
      ),
      body: Center(
        child: SizedBox(
          width: 800,
          height: 600,
          child: CustomPaint(
            painter: CustomPaintRenderer(diagramLayer),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: ImportedDiagramDemo()));
}
