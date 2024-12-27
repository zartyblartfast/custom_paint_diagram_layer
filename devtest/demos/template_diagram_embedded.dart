import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

/// A template diagram that properly follows the layer architecture and supports both embedded and standalone modes
class TemplateDiagram extends DiagramRendererBase 
    with DiagramMigrationHelper, DiagramControllerMixin {
  static const String valueKey = 'value';
  
  // Configuration variables
  static const String _headerTitle = 'Template Diagram - Embedded';  // Header title for standalone mode
  static const double _sliderStartValue = 0.5;  // 50% of max
  
  final Map<String, dynamic>? _initialValues;
  final void Function(Map<String, dynamic>)? _onValuesChanged;

  // Canvas size
  double _canvasWidth = 500;
  double _canvasHeight = 500;

  // Display control flags
  bool _showAxes = true;
  bool _showGrid = true;
  bool _showFrame = true;

  // Standard coordinate system (origin at center, equal ranges)
  double _xRangeMin = -10;
  double _xRangeMax = 10;
  double _yRangeMin = -10;
  double _yRangeMax = 10;
  double _scale = 1.0;
  Offset _labelCoords = Offset(-5, 5);  // Top-left quadrant

  TemplateDiagram({
    DiagramConfig? config,
    Map<String, dynamic>? initialValues,
    Function(Map<String, dynamic>)? onValuesChanged,
  }) : _initialValues = initialValues,
       _onValuesChanged = onValuesChanged,
       super(
         config: config ?? DiagramConfig(
           showAxes: true,
           showGrid: true,
           showFrame: true,  // Enable frame by default
         ),
       );

  @override
  void initState() {
    // Sync display flags with config
    _showAxes = config.showAxes;
    _showGrid = config.showGrid;
    _showFrame = config.showFrame;
    
    initializeController(
      defaultValues: {
        valueKey: _sliderStartValue,
        ...?_initialValues,
      },
      onValuesChanged: _onValuesChanged,
    );
    super.initState();
  }

  @override
  void _initDiagram() {
    final coords = createCoordinateSystem();
    
    // Create initial layer with coordinate system
    diagramLayer = BasicDiagramLayer(
      coordinateSystem: coords,
      showAxes: config.showAxes,
    );

    // Add grid if enabled
    if (config.showGrid) {
      diagramLayer = diagramLayer.addElement(
        GridElement(
          x: 0,
          y: 0,
          majorSpacing: 1.0,
          minorSpacing: 0.2,
          majorColor: Colors.grey.withOpacity(0.5),
          minorColor: Colors.grey.withOpacity(0.2),
        ),
      );
    }

    // Add frame if enabled
    if (_showFrame) {
      diagramLayer = diagramLayer.addElement(
        FrameElement(
          color: Colors.black,  // Changed to black for better visibility
          strokeWidth: 2.0,     // Increased width for better visibility
          opacity: 1.0,
        ),
      );
    }

    // Add initial elements
    updateElements();
  }


  // Methods to control visibility
  void toggleAxes() {
    _showAxes = !_showAxes;
    diagramLayer = diagramLayer.toggleAxes();
    updateElements();
  }

  void toggleGrid() {
    _showGrid = !_showGrid;
    if (_showGrid) {
      diagramLayer = diagramLayer.addElement(
        GridElement(
          x: 0,
          y: 0,
          majorSpacing: 1.0,
          minorSpacing: 0.2,
          majorColor: Colors.grey.withOpacity(0.5),
          minorColor: Colors.grey.withOpacity(0.2),
        ),
      );
    } else {
      // Remove only the grid element
      diagramLayer = diagramLayer.copyWith(
        elements: diagramLayer.elements.where((e) => e is! GridElement).toList(),
      );
    }
    updateElements();
  }

  void toggleFrame() {
    _showFrame = !_showFrame;
    if (!_showFrame) {
      // Remove only the frame element
      diagramLayer = diagramLayer.copyWith(
        elements: diagramLayer.elements.where((e) => e is! FrameElement).toList(),
      );
    } else {
      // Add frame element
      diagramLayer = diagramLayer.addElement(
        FrameElement(
          color: Colors.black,
          strokeWidth: 2.0,
          opacity: 1.0,
        ),
      );
    }
    updateElements();
  }

  @override
  CoordinateSystem createCoordinateSystem() {
    return CoordinateSystem(
      origin: Offset.zero,
      xRangeMin: _xRangeMin,
      xRangeMax: _xRangeMax,
      yRangeMin: _yRangeMin,
      yRangeMax: _yRangeMax,
      scale: _scale,
    );
  }

  @override
  List<DrawableElement> createElements() {
    final elements = <DrawableElement>[];

    // Add frame if enabled (needs to be added first to be behind other elements)
    if (_showFrame) {
      elements.add(FrameElement(
        color: Colors.black,
        strokeWidth: 2.0,
        opacity: 1.0,
      ));
    }

    // Add a semicircle that grows with the slider value
    final radius = (controller.getValue<double>(valueKey) ?? 0.0) * 5.0; // Scale up the radius
    elements.add(CircleElement(
      x: 0,
      y: 0,
      radius: radius,
      color: Colors.blue,
      fillColor: Colors.blue.shade100,
      fillOpacity: 0.5,
    ));

    return elements;
  }

  @override
  DiagramRendererBase updateConfig(DiagramConfig newConfig) {
    return TemplateDiagram(
      config: newConfig,
      initialValues: _initialValues,
      onValuesChanged: _onValuesChanged,
    );
  }

  @override
  void updateFromController() {
    updateElements();
  }

  void updateFromSlider(double value) {
    controller.setValue(valueKey, value);
    updateElements();
  }
}

/// Widget that can display the template diagram in either standalone or embedded mode
class TemplateDiagramDemo extends StatefulWidget {
  final bool useStandalone;
  final bool showControls;
  
  const TemplateDiagramDemo({
    super.key,
    this.useStandalone = false,  // Default to embedded mode
    this.showControls = true,
  });

  @override
  State<TemplateDiagramDemo> createState() => _TemplateDiagramDemoState();
}

class _TemplateDiagramDemoState extends State<TemplateDiagramDemo> {
  late final TemplateDiagram diagram;
  double _sliderValue = TemplateDiagram._sliderStartValue;  // Initialize slider with start value

  @override
  void initState() {
    super.initState();
    diagram = TemplateDiagram(
      config: DiagramConfig(
        width: 600,
        height: 600,
        showAxes: true,    // Explicitly enable axes in initial config
        showGrid: true,    // Explicitly enable grid in initial config
        showFrame: true,   // Explicitly enable frame in initial config
      ),
    );
    diagram.initState();
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Circle Size'),
              Expanded(
                child: Slider(
                  value: _sliderValue,
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                      diagram.updateFromSlider(value);
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => diagram.toggleAxes()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: diagram._showAxes ? Colors.green : Colors.grey,
                ),
                child: Text('Axes ${diagram._showAxes ? "On" : "Off"}'),
              ),
              ElevatedButton(
                onPressed: () => setState(() => diagram.toggleGrid()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: diagram._showGrid ? Colors.green : Colors.grey,
                ),
                child: Text('Grid ${diagram._showGrid ? "On" : "Off"}'),
              ),
              ElevatedButton(
                onPressed: () => setState(() => diagram.toggleFrame()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: diagram._showFrame ? Colors.green : Colors.grey,
                ),
                child: Text('Frame ${diagram._showFrame ? "On" : "Off"}'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useStandalone) {
      return Scaffold(
        appBar: AppBar(
          title: Text(TemplateDiagram._headerTitle),  // Use header title
        ),
        body: Column(
          children: [
            Expanded(
              child: diagram.buildDiagramWidget(context),
            ),
            if (widget.showControls) _buildControls(),
          ],
        ),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          diagram.wrapForWeb(context),
          if (widget.showControls) _buildControls(),
        ],
      );
    }
  }
}

/// Entry point for standalone demo
void main() {
  runApp(
    const MaterialApp(
      home: TemplateDiagramDemo(useStandalone: true),  // Use standalone mode for demo
    ),
  );
}
