# Creating New Demos Guide

## Important Documentation
Before creating a new demo, review these resources:
- [Integration Guide](integration_guide.md) - Integration approaches and patterns
- [Element Architecture](Element_Architecture.md) - Available elements and properties
- [Implementation Approach](Implementation_Approach.md) - Framework design
- [UML Architecture](architecture/uml.md) - System architecture

## Project Structure
```
custom_paint_diagram_layer/
├── lib/                              # Diagram layer library
│   └── custom_paint_diagram_layer/   
│       ├── elements/                 # Drawing elements
│       ├── renderers/                # Renderer components
│       └── custom_paint_diagram_layer.dart
│
├── devtest/                          # Demo application
│   ├── demos/                        # Diagram implementations
│   │   ├── template_diagram.dart     # Base template for new diagrams
│   │   └── migrated_butterfly_art.dart
│   ├── standalone/                   # Standalone examples
│   │   ├── standalone_main.dart      # Non-Flutter web entry
│   │   └── js_bridge.dart           # JavaScript integration
│   └── embedded/                     # Embedded examples
│       └── embedded_main.dart        # Flutter web entry
```

## Creating a New Diagram

### 1. Create the Base Diagram Renderer

Use `template_diagram.dart` as your starting point. It includes all necessary setup and best practices:

```dart
class MyDiagram extends DiagramRendererBase with DiagramControllerMixin {
  // Title
  final String _title = 'My Diagram';

  // Canvas size
  double _canvasWidth = 500;
  double _canvasHeight = 500;

  // Display control flags
  bool _showAxes = true;
  bool _showGrid = true;
  bool _showFrame = true;

  // Frame style
  double _frameStrokeWidth = 1.0;
  Color _frameStrokeColor = Colors.blueAccent;
  Color? _frameFillColor = Colors.grey.shade100;
  double _frameOpacity = 1.0;

  // State variables
  final Map<String, dynamic>? _initialValues;
  final void Function(Map<String, dynamic>)? _onValuesChanged;

  MyDiagram({
    super.config,
    this._initialValues,
    this._onValuesChanged,
  });

  @override
  void initState() {
    initializeController(
      defaultValues: _initialValues ?? {},
      onValuesChanged: _onValuesChanged,
    );
    super.initState();
  }

  @override
  CoordinateSystem createCoordinateSystem() {
    return CoordinateSystem(
      origin: Offset.zero,
      xRangeMin: -10,
      xRangeMax: 10,
      yRangeMin: -10,
      yRangeMax: 10,
      scale: 1.0,
    );
  }

  @override
  List<DrawableElement> createElements() {
    final elements = <DrawableElement>[];

    // Add frame if enabled
    if (_showFrame) {
      elements.add(FrameElement(
        color: _frameStrokeColor,
        strokeWidth: _frameStrokeWidth,
        fillColor: _frameFillColor,
        opacity: _frameOpacity,
      ));
    }

    // Add grid if enabled
    if (_showGrid) {
      elements.add(GridElement(
        x: 0,
        y: 0,
        majorSpacing: 1.0,
        minorSpacing: 0.2,
        majorColor: Colors.grey.withOpacity(0.5),
        minorColor: Colors.grey.withOpacity(0.2),
      ));
    }

    // Add axes if enabled
    if (_showAxes) {
      elements.add(const XAxisElement(
        yValue: 0,  // X-axis positioned at y=0
        tickInterval: 1.0,
        color: Colors.black,
      ));

      elements.add(const YAxisElement(
        xValue: 0,  // Y-axis positioned at x=0
        tickInterval: 1.0,
        color: Colors.black,
      ));
    }

    // Add your custom elements here
    elements.add(TextElement(
      x: controller.getValue<double>('x') ?? 0,
      y: controller.getValue<double>('y') ?? 0,
      text: controller.getValue<String>('text') ?? 'My Diagram',
      color: Colors.black,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    ));

    return elements;
  }
}
```

### 2. Choose Integration Method

#### Option A: Embedded in Flutter Web App

Create a reusable widget:

```dart
class MyDiagramWidget extends StatefulWidget {
  final Map<String, dynamic>? initialState;
  final void Function(Map<String, dynamic>)? onStateChanged;

  const MyDiagramWidget({
    super.key,
    this.initialState,
    this.onStateChanged,
  });

  @override
  State<MyDiagramWidget> createState() => _MyDiagramWidgetState();
}

class _MyDiagramWidgetState extends State<MyDiagramWidget> {
  late MyDiagram diagram;

  @override
  void initState() {
    super.initState();
    diagram = MyDiagram(
      config: DiagramConfig(
        width: 500,
        height: 500,
        showAxes: true,
        showGrid: true,
        showFrame: true,
      ),
      initialValues: widget.initialState,
      onValuesChanged: widget.onStateChanged,
    );
    diagram.initState();
  }

  @override
  Widget build(BuildContext context) {
    return diagram.buildDiagramWidget(context);
  }
}
```

Usage in Flutter app:
```dart
MyDiagramWidget(
  initialState: {'x': 0, 'y': 0, 'text': 'Hello'},
  onStateChanged: (values) {
    print('Diagram state updated: $values');
  },
)
```

#### Option B: Standalone Web Component

Create JavaScript bridge:

```dart
@JS()
library diagram_js;

import 'package:js/js.dart';

@JS('renderDiagram')
external set _renderDiagram(void Function(String containerId, String config) f);

void main() {
  _renderDiagram = allowInterop((String containerId, String config) {
    final diagram = MyDiagram(
      config: DiagramConfig(
        width: 500,
        height: 500,
        showAxes: true,
        showGrid: true,
        showFrame: true,
      ),
      initialValues: jsonDecode(config),
      onValuesChanged: (values) {
        js.context.callMethod('onDiagramUpdate', [jsonEncode(values)]);
      },
    );
    runApp(MaterialApp(
      home: HtmlElementView(
        viewType: containerId,
        child: diagram.buildDiagramWidget(context),
      ),
    ));
  });
}
```

Usage in web page:
```html
<div id="diagram-container"></div>
<script>
window.renderDiagram('diagram-container', JSON.stringify({
  x: 0,
  y: 0,
  text: 'Hello'
}));

window.onDiagramUpdate = function(values) {
  console.log('Diagram updated:', JSON.parse(values));
};
</script>
```

## Important Notes

### Element Creation
When implementing a new diagram, it's crucial to handle grid and axes creation in `createElements()` rather than `_initDiagram()`. This ensures that visibility flags (`_showGrid`, `_showAxes`) work correctly, as `createElements()` is called each time the diagram needs to be redrawn.

```dart
@override
List<DrawableElement> createElements() {
  final elements = <DrawableElement>[];

  // Handle grid and axes here, not in _initDiagram()
  if (_showGrid) {
    elements.add(GridElement(...));
  }
  if (_showAxes) {
    elements.add(XAxisElement(...));
    elements.add(YAxisElement(...));
  }
  
  // Add other elements
  ...
  
  return elements;
}
```

This approach ensures that visibility flags work as expected, since the elements are recreated each time the diagram is drawn.

## Best Practices

1. **Base Implementation**
   - Always extend `DiagramRendererBase` with `DiagramControllerMixin`
   - Initialize controller in `initState()`
   - Use config for display settings
   - Handle state updates through controller

2. **Integration Specific**
   - Embedded: Use Flutter widgets and state management
   - Standalone: Implement proper JavaScript bridge
   - Consider target environment when choosing approach

3. **State Management**
   - Use controller for internal state
   - Expose state changes via callbacks
   - Keep state serializable for JavaScript integration

4. **Element Management**
   - Add elements in logical order (frame, grid, axes, custom)
   - Use appropriate element types
   - Consider performance with complex elements

5. **Error Prevention**
   - Initialize all required variables
   - Handle null cases
   - Test in target environment

## Common Issues and Solutions

1. **Diagram Not Displaying**
   - Verify `initState()` is called
   - Check canvas size in config
   - Ensure elements are being added
   - Verify container setup (especially for standalone)

2. **State Updates Not Working**
   - Check controller initialization
   - Verify callback connections
   - Test serialization (for standalone)

3. **Integration Issues**
   - Embedded: Check Flutter widget tree
   - Standalone: Verify JavaScript bridge setup
   - Test in target environment

4. **Performance Problems**
   - Minimize element count
   - Use appropriate element types
   - Consider state update frequency
