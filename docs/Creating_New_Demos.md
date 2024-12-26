# Creating New Demos Guide

## Important Documentation
Before creating a new demo, review these resources:
- [Element Architecture](Element_Architecture.md) - Contains available elements and their properties
- [Implementation Approach](Implementation_Approach.md) - Overall framework design
- [UML Architecture](architecture/uml.md) - System architecture and components

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
│   ├── standalone_migrated_main.dart # Standalone entry
│   ├── embedded_migrated_main.dart   # Embedded entry
│   └── migrated_main.dart           # Demo selector
```

## Creating a New Diagram

### 1. Create the Diagram Renderer

Use `template_diagram.dart` as your starting point. It includes all necessary setup and best practices:

#### Basic Structure
```dart
class MyDiagram extends DiagramRendererBase 
    with DiagramMigrationHelper, DiagramControllerMixin {
  // Title
  final String _title = 'My Diagram';  // Used in UI header

  // Canvas size
  double _canvasWidth = 500;
  double _canvasHeight = 500;

  // Display control flags
  bool _showAxes = true;
  bool _showGrid = true;
  bool _showFrame = true;

  // Frame style (if using frame)
  double _frameStrokeWidth = 1.0;
  Color _frameStrokeColor = Colors.blueAccent;
  Color? _frameFillColor = Colors.grey.shade100;
  double _frameOpacity = 1.0;

  // State variables
  final Map<String, dynamic>? _initialValues;
  final void Function(Map<String, dynamic>)? _onValuesChanged;

  MyDiagram({
    super.config,
    Map<String, dynamic>? initialValues,
    void Function(Map<String, dynamic>)? onValuesChanged,
  }) : _initialValues = initialValues,
       _onValuesChanged = onValuesChanged;
}
```

### 2. Required Method Implementations

#### Initialize State
```dart
@override
void initState() {
  initializeController(
    defaultValues: {
      ...?_initialValues,
    },
    onValuesChanged: _onValuesChanged,
  );
  super.initState();
}
```

#### Create Coordinate System
```dart
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
```

#### Create Elements
```dart
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

  // Add your custom elements here
  elements.add(TextElement(
    x: 0,
    y: 0,
    text: 'My Diagram',
    color: Colors.black,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
  ));

  return elements;
}
```

### 3. Create the Demo Widget

```dart
class MyDiagramDemo extends StatefulWidget {
  const MyDiagramDemo({super.key});

  @override
  State<MyDiagramDemo> createState() => _MyDiagramDemoState();
}

class _MyDiagramDemoState extends State<MyDiagramDemo> {
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
    );
    diagram.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(diagram._title),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: diagram.buildDiagramWidget(context),
        ),
      ),
    );
  }
}
```

## Best Practices

1. **Initialization**
   - Always call `initState()` after creating your diagram
   - Set appropriate initial values in the constructor
   - Use the config parameter for initial display settings

2. **State Management**
   - Use private variables with getters/setters for controlled access
   - Call `updateElements()` when diagram state changes
   - Use `setState()` in the demo widget when needed

3. **Element Management**
   - Add elements in a logical order (frame, grid, axes, custom elements)
   - Use appropriate element types for different drawing needs
   - Consider performance with complex or numerous elements

4. **Frame and Grid**
   - Use the provided frame and grid elements for consistency
   - Configure frame appearance through style properties
   - Consider coordinate system bounds for proper positioning

5. **UI Integration**
   - Use the provided title variable for the AppBar
   - Match colors across UI elements for consistency
   - Center the diagram in the display area

6. **Error Prevention**
   - Initialize all required variables
   - Handle null cases appropriately
   - Test with different configurations and states

## Common Issues and Solutions

1. **Diagram Not Displaying**
   - Verify `initState()` is called
   - Check canvas size in config
   - Ensure elements are being added to the list

2. **Elements Not Appearing**
   - Check coordinate system ranges
   - Verify element positions are within bounds
   - Confirm visibility flags are set correctly

3. **Frame Issues**
   - Ensure frame style properties are set
   - Check frame visibility flag
   - Verify coordinate system bounds

4. **Performance Problems**
   - Minimize element count
   - Use appropriate element types
   - Consider using simpler styles for better performance
