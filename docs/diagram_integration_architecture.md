# Diagram Integration Architecture

This document explains the architecture for integrating diagrams both internally (within Flutter) and externally (in web pages).

## Quick Start

1. Create a diagram using `DiagramRendererBase`:
```dart
class MyDiagram extends DiagramRendererBase 
    with DiagramMigrationHelper, DiagramControllerMixin {
  static const String myControlKey = 'value';
  
  MyDiagram({
    super.config,
    Map<String, dynamic>? initialValues,
    Function(Map<String, dynamic>)? onValuesChanged,
  }) : super() {
    initializeController(
      defaultValues: {
        myControlKey: 0.0,
        ...?initialValues,
      },
      onValuesChanged: onValuesChanged,
    );
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
    final value = controller.getValue<double>(myControlKey) ?? 0.0;
    return [
      CircleElement(
        x: 0,
        y: 0,
        radius: 1.0 + value,
        color: Colors.black,
      ),
    ];
  }

  void updateFromSlider(double value) {
    controller.setValue(myControlKey, value);
    updateElements();
  }
}
```

2. Create a widget for standalone or embedded use:
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
    diagram = MyDiagram(
      onValuesChanged: (values) => setState(() {}),
    );
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
            value: diagram.controller.getValue<double>('value') ?? 0.0,
            onChanged: (value) => diagram.updateFromSlider(value),
          ),
      ],
    );
  }
}
```

3. Create entry points for different integration modes:

```dart
// Standalone version (standalone_my_diagram_main.dart)
void main() {
  runApp(MaterialApp(
    title: 'Standalone My Diagram',
    home: MyDiagramDemo(useStandalone: true),
  ));
}

// Embedded version (embedded_my_diagram_main.dart)
void main() {
  runApp(MaterialApp(
    title: 'Embedded My Diagram',
    home: Scaffold(
      appBar: AppBar(title: Text('My Diagram')),
      body: MyDiagramDemo(useStandalone: false),
    ),
  ));
}
```

## Architecture Components

### 1. DiagramRendererBase

The foundation class that provides:
- Coordinate system setup
- Element creation and management
- Widget building and rendering
- Integration with controllers

Key methods to override:
```dart
@override
CoordinateSystem createCoordinateSystem()  // Define coordinate space

@override
List<DrawableElement> createElements()     // Create diagram elements
```

### 2. DiagramControllerMixin

Adds state management capabilities:
- Value storage and retrieval
- Change notifications
- External control interface

Key features:
```dart
// Initialize controller
initializeController(
  defaultValues: Map<String, dynamic>,
  onValuesChanged: Function(Map<String, dynamic>)?,
)

// Get/Set values
T? getValue<T>(String key)
void setValue(String key, dynamic value)

// Update diagram
void updateElements()
```

### 3. DiagramMigrationHelper

Provides support for:
- Slider integration
- Legacy feature compatibility
- Migration utilities

Key methods:
```dart
void updateFromSlider(double value)  // Handle slider updates
```

## Integration Patterns

### 1. Standalone Mode
- Full-window diagram display
- Optional controls
- Independent operation
```dart
MyDiagramDemo(useStandalone: true)
```

### 2. Embedded Mode
- Integrated within larger UI
- Customizable controls
- Interaction with parent widgets
```dart
MyDiagramDemo(
  useStandalone: false,
  showControls: true,
)
```

### 3. Web Integration
- Export as web component
- JavaScript API access
- External control interface
```javascript
// JavaScript
window.diagramController.setValue('value', 0.5);
```

## State Management Flow

1. **External Input**
   ```dart
   diagram.controller.setValue('key', value);
   ```

2. **Controller Update**
   ```dart
   void setValue(String key, dynamic value) {
     _values[key] = value;
     onValuesChanged?.call(_values);
   }
   ```

3. **Element Update**
   ```dart
   void updateElements() {
     elements = createElements();
     markNeedsPaint();
   }
   ```

4. **UI Update**
   ```dart
   onValuesChanged: (values) => setState(() {}),
   ```

## Best Practices

1. **State Management**
   - Use controller for all state changes
   - Define static keys for control points
   - Handle state updates through proper channels

2. **Integration**
   - Support both standalone and embedded modes
   - Make controls optional and configurable
   - Use proper widget hierarchy

3. **Performance**
   - Minimize element recreation
   - Use efficient update patterns
   - Cache calculated values

4. **Error Handling**
   - Validate control values
   - Provide default values
   - Handle edge cases

## Reference Examples

See these implementations:
- `migrated_butterfly_art.dart` - Full featured example
- `standalone_migrated_main.dart` - Standalone integration
- `embedded_migrated_main.dart` - Embedded integration
