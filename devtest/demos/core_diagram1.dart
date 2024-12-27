import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

/// A simple test diagram to validate CoreDiagramBase functionality.
/// Displays a circle and text that can be controlled via a slider.
class CoreDiagram1 extends CoreDiagramBase {
  static const String valueKey = 'value';
  static const double _sliderStartValue = 0.5;

  final Map<String, dynamic>? _initialValues;
  final void Function(Map<String, dynamic>)? _onValuesChanged;

  CoreDiagram1({
    required super.config,
    Map<String, dynamic>? initialValues,
    void Function(Map<String, dynamic>)? onValuesChanged,
  }) : _initialValues = initialValues,
       _onValuesChanged = onValuesChanged;

  @override
  void initState() {
    // Initialize controller before calling super.initState()
    initializeController(
      defaultValues: {
        valueKey: _sliderStartValue,
        ...?_initialValues,
      },
      onValuesChanged: _onValuesChanged,
    );
    
    // Call super to sync flags and initialize diagram
    super.initState();
  }

  @override
  List<DrawableElement> createDiagramElements() {
    // Get current slider value (0.0 to 1.0)
    final value = controller.getValue<double>(valueKey) ?? _sliderStartValue;
    
    // Create a circle whose radius changes with the slider
    final radius = value * 5.0; // Scale up the radius
    
    return [
      // Add a circle
      CircleElement(
        x: 5,
        y: 5,
        radius: radius,
        color: const Color.fromRGBO(238, 238, 238, 1),     // Light grey border
        fillColor: const Color.fromRGBO(0, 0, 255, 0.2),   // Blue fill with 20% opacity
      ),
      
      // Add text showing the current value
      TextElement(
        x: 0,
        y: -6,
        text: 'Value: ${(value * 100).toStringAsFixed(1)}%',
        color: Colors.black,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
  }

  @override
  DiagramRendererBase updateConfig(DiagramConfig newConfig) {
    return CoreDiagram1(
      config: newConfig,
      initialValues: _initialValues,
      onValuesChanged: _onValuesChanged,
    );
  }
}

/// Widget that displays CoreDiagram1 with controls
class CoreDiagram1Demo extends StatefulWidget {
  final bool useStandalone;
  
  const CoreDiagram1Demo({
    super.key,
    this.useStandalone = true,  // Default to standalone mode for demo
  });

  @override
  State<CoreDiagram1Demo> createState() => _CoreDiagram1DemoState();
}

class _CoreDiagram1DemoState extends State<CoreDiagram1Demo> {
  late final CoreDiagram1 diagram;
  double _sliderValue = CoreDiagram1._sliderStartValue;

  @override
  void initState() {
    super.initState();
    
    // Create diagram instance with custom coordinate system
    diagram = CoreDiagram1(
      config: DiagramConfig(
        // Canvas size
        width: widget.useStandalone ? 600 : 400,
        height: widget.useStandalone ? 400 : 300,
        
        // Core element visibility
        showAxes: true,
        showGrid: true,
        showFrame: true,
        
        // Coordinate system configurations
        
        // Default centered coordinate system (-10 to 10 on both axes)
        //xRangeMin: -10,
        //xRangeMax: 10,
        //yRangeMin: -10,
        //yRangeMax: 10,
        //origin: const Offset(0, 0),
        //scale: 1.0,

        // Other useful configurations:
        
        // Positive quadrant only (0 to 10 on both axes)
        xRangeMin: 0,
        xRangeMax: 10,
        yRangeMin: 0,
        yRangeMax: 10,
        origin: const Offset(0, 0),
        scale: 1.0,

        /* Wide range horizontal (-20 to 20 x, -10 to 10 y)
        xRangeMin: -20,
        xRangeMax: 20,
        yRangeMin: -10,
        yRangeMax: 10,
        origin: const Offset(0, 0),
        scale: 1.0,

        // Tall range vertical (-10 to 10 x, -20 to 20 y)
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: -20,
        yRangeMax: 20,
        origin: const Offset(0, 0),
        scale: 1.0,

        // Custom origin (shifted to point 5,5)
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: -10,
        yRangeMax: 10,
        origin: const Offset(5, 5),
        scale: 1.0,

        // Zoomed in (scale > 1 makes everything appear larger)
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: -10,
        yRangeMax: 10,
        origin: const Offset(0, 0),
        scale: 2.0,

        // Zoomed out (scale < 1 makes everything appear smaller)
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: -10,
        yRangeMax: 10,
        origin: const Offset(0, 0),
        scale: 0.5,
        */

        // Frame styling
        frameStrokeColor: const Color.fromARGB(255, 48, 48, 48),
        frameStrokeWidth: 3.0,
        frameStrokeOpacity: 0.8,
        frameFill: true,
        frameFillColor: const Color.fromARGB(255, 187, 231, 252),
        frameFillOpacity: 0.1,

        // Grid styling
        // Major grid lines (more prominent)
        //gridMajorColor: const Color.fromRGBO(0, 0, 0, 1),
        //gridMajorOpacity: 0.2,
        //gridMajorStyle: GridLineStyle.solid,
        //gridMajorWidth: 1.0,

        // Minor grid lines (more subtle)
        //gridMinorColor: const Color.fromRGBO(0, 0, 0, 1),
        //gridMinorOpacity: 0.1,
        //gridMinorStyle: GridLineStyle.dotted,
        //gridMinorWidth: 0.5,

        // Axes styling
        axisColor: const Color.fromARGB(255, 0, 0, 0),  // Blue
        axisOpacity: 0.8,  // 80% visible (prominent)
      ),
    );
    
    // Initialize diagram
    diagram.initState();
  }

  Widget _buildControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Slider for value control
        Row(
          children: [
            const Text('Value:'),
            Expanded(
              child: Slider(
                value: _sliderValue,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                    diagram.controller.setValue(CoreDiagram1.valueKey, value);
                    diagram.updateElements();  // Trigger diagram update
                  });
                },
              ),
            ),
            Text('${(_sliderValue * 100).toStringAsFixed(1)}%'),
          ],
        ),
        
        // Toggle buttons for core elements
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Grid toggle
            ElevatedButton(
              onPressed: () => setState(() => diagram.toggleGrid()),
              child: Text(diagram.showGrid ? 'Hide Grid' : 'Show Grid'),
            ),
            const SizedBox(width: 8),
            
            // Axes toggle
            ElevatedButton(
              onPressed: () => setState(() => diagram.toggleAxes()),
              child: Text(diagram.showAxes ? 'Hide Axes' : 'Show Axes'),
            ),
            const SizedBox(width: 8),
            
            // Frame toggle
            ElevatedButton(
              onPressed: () => setState(() => diagram.toggleFrame()),
              child: Text(diagram.showFrame ? 'Hide Frame' : 'Show Frame'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.useStandalone) ...[
          const Text(
            'Core Diagram Test',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
        ],
        widget.useStandalone 
          ? Expanded(child: diagram.buildDiagramWidget(context))
          : SizedBox(
              width: diagram.canvasWidth,
              height: diagram.canvasHeight,
              child: diagram.buildDiagramWidget(context),
            ),
        const SizedBox(height: 20),
        _buildControls(),
      ],
    );

    if (widget.useStandalone) {
      return Scaffold(
        body: Center(
          child: content,
        ),
      );
    } else {
      return content;
    }
  }
}

/// Entry point for standalone demo
void main() {
  runApp(
    const MaterialApp(
      home: CoreDiagram1Demo(useStandalone: true),
    ),
  );
}
