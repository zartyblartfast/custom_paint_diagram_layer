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
│   │   └── migrated_butterfly_art.dart
│   ├── standalone_migrated_main.dart # Standalone entry
│   ├── embedded_migrated_main.dart   # Embedded entry
│   └── migrated_main.dart           # Demo selector
```

## Creating a New Diagram

### 1. Create the Diagram Renderer

You can use `template_diagram.dart` as a starting point for new diagrams. Here are the key components:

#### Basic Structure
Create a new class extending `DiagramRendererBase`:

```dart
class MyDiagram extends DiagramRendererBase 
    with DiagramMigrationHelper, DiagramControllerMixin {
  // State variables
  final Map<String, dynamic>? _initialValues;
  final void Function(Map<String, dynamic>)? _onValuesChanged;
  bool _showAxes = true;  // Control axes visibility
  
  // Constructor
  MyDiagram({
    super.config,
    Map<String, dynamic>? initialValues,
    void Function(Map<String, dynamic>)? onValuesChanged,
  }) : _initialValues = initialValues,
       _onValuesChanged = onValuesChanged;
}
```

#### Required Overrides

1. **initState()** - Initialize the controller:
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

2. **createCoordinateSystem()** - Define the diagram's coordinate space:
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

3. **createElements()** - Create the visual elements:
```dart
@override
List<DrawableElement> createElements() {
  // Create grid first
  final grid = GridElement(
    x: 0,
    y: 0,
    majorSpacing: 1.0,
    minorSpacing: 0.2,
    majorColor: Colors.grey.withOpacity(0.5),
    minorColor: Colors.grey.withOpacity(0.2),
  );

  // Initialize diagram layer with grid
  diagramLayer = BasicDiagramLayer(
    coordinateSystem: createCoordinateSystem(),
    showAxes: false,  // Default axes state
  ).addElement(grid);

  // Add axes if needed
  if (_showAxes) {
    diagramLayer = diagramLayer.toggleAxes();
  }

  // Return your diagram elements
  return [
    // Add your diagram-specific elements here
  ];
}
```

4. **updateConfig()** - Handle configuration updates:
```dart
@override
DiagramRendererBase updateConfig(DiagramConfig newConfig) {
  return MyDiagram(
    config: newConfig,
    initialValues: _initialValues,
    onValuesChanged: _onValuesChanged,
  );
}
```

#### Important Notes

1. **Controller Management**:
   - Don't create a separate controller field - use `DiagramControllerMixin`
   - Initialize the controller in `initState()` before calling `super`
   - Store initial values and callbacks as private fields

2. **Axes Management**:
   - Use `_showAxes` boolean to track axes state
   - Set `showAxes: false` in `BasicDiagramLayer` constructor
   - Call `toggleAxes()` explicitly when needed
   - Configure default state in both the class and `DiagramConfig`

3. **Grid Setup**:
   - Create the grid first in `createElements()`
   - Add it to the layer before other elements
   - Use semi-transparent colors for better visibility

4. **Coordinate System**:
   - Choose appropriate range values for your diagram
   - Consider using engineering-style coordinates (y-axis up) if appropriate
   - Origin is typically at (0,0) but can be adjusted

### 2. Create the Demo Widget

Create a widget to display your diagram:

```dart
class MyDiagramDemo extends StatefulWidget {
  final bool useStandalone;
  final bool showControls;
  
  const MyDiagramDemo({
    super.key,
    this.useStandalone = true,
    this.showControls = true,
  });

  @override
  State<MyDiagramDemo> createState() => _MyDiagramDemoState();
}

class _MyDiagramDemoState extends State<MyDiagramDemo> {
  late MyDiagram diagram;

  @override
  void initState() {
    super.initState();
    diagram = MyDiagram();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: diagram.buildDiagramWidget(context),
        ),
        if (widget.showControls)
          Slider(
            value: diagram.getControlValue(),
            onChanged: (value) => setState(() {
              diagram.updateFromSlider(value);
            }),
          ),
      ],
    );
  }
}
```

### 3. Create Entry Points

#### Standalone Version (standalone_my_diagram_main.dart):
```dart
void main() {
  runApp(MaterialApp(
    title: 'Standalone My Diagram',
    debugShowCheckedModeBanner: false,
    home: MyDiagramDemo(
      useStandalone: true,
    ),
  ));
}
```

#### Embedded Version (embedded_my_diagram_main.dart):
```dart
void main() {
  runApp(MaterialApp(
    title: 'Embedded My Diagram',
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(
        title: Text('My Diagram (Embedded)'),
      ),
      body: Center(
        child: MyDiagramDemo(
          useStandalone: false,
          showControls: true,
        ),
      ),
    ),
  ));
}
```

## Key Principles

### 1. Diagram Architecture
- Extend `DiagramRendererBase` for core functionality
- Use `DiagramControllerMixin` for state management
- Use `DiagramMigrationHelper` for slider support
- Override required methods:
  - `createCoordinateSystem()`
  - `createElements()`

### 2. State Management
- Use controller for all state changes
- Define control point keys as static constants
- Initialize controller with default values
- Update elements through controller

### 3. Element Usage
- All drawing through DL element classes
- Never use Flutter's Canvas directly
- Required parameters for all elements:
  - `x` and `y` for position
  - `color` for stroke color

### 4. Integration Options
- Standalone: Clean, focused view
- Embedded: Integrated with UI controls
- Demo selector: Both versions accessible

## Available Elements
```dart
// Circle
CircleElement(
  x: 0.0,           // Center X
  y: 0.0,           // Center Y
  radius: 100.0,    // Required
  color: Colors.black,
  fillColor: Colors.blue,  // Optional
);

// Line
LineElement(
  x1: 0.0,          // Start X
  y1: 0.0,          // Start Y
  x2: 100.0,        // End X
  y2: 100.0,        // End Y
  color: Colors.black,
  strokeWidth: 2.0,
);

// Polygon
PolygonElement(
  points: [         // Required list of points
    Point(0, 0),
    Point(100, 0),
    Point(50, 100),
  ],
  x: 0.0,          // Reference point X
  y: 0.0,          // Reference point Y
  color: Colors.black,
  fillColor: Colors.blue,  // Optional
);

// Bezier Curve
BezierCurveElement(
  x: 0,
  y: 0,
  endPoint: Point(-4, 2),
  controlPoint1: Point(-2, 3),
  type: BezierType.quadratic,
  color: Colors.black,
  strokeWidth: 2,
);
```

## Best Practices

1. **State Management**
   - Keep state in the controller
   - Use static keys for control points
   - Update through controller methods

2. **Integration**
   - Consider both standalone and embedded use
   - Make controls optional
   - Use proper widget hierarchy

3. **Performance**
   - Minimize element recreation
   - Use efficient update patterns
   - Cache calculated values

4. **Error Handling**
   - Validate control values
   - Provide default values
   - Handle edge cases

## Example Templates

1. **Data Visualization**
   - Start with: `migrated_butterfly_art.dart`
   - Features: Coordinate system, interactive controls

2. **Geometric Patterns**
   - Start with: `migrated_butterfly_art.dart`
   - Features: Centered design, symmetry

3. **Interactive Diagrams**
   - Start with: `migrated_butterfly_art.dart`
   - Features: State management, controls

## Running Your Demo

```bash
# Standalone version
flutter run -t devtest/standalone_my_diagram_main.dart -d chrome

# Embedded version
flutter run -t devtest/embedded_my_diagram_main.dart -d chrome
