# Integration Guide: Flutter Diagram Layer

This guide covers different approaches for integrating diagrams created with the Custom Paint Diagram Layer framework into applications. The framework's renderer-based architecture with controller state management provides flexible integration options.

## Setup

Add the package to your `pubspec.yaml`:
```yaml
dependencies:
  custom_paint_diagram_layer:
    git:
      url: https://github.com/username/custom_paint_diagram_layer
      ref: main
```

## Base Implementation

Before choosing an integration method, implement your diagram:

```dart
class MyDiagram extends DiagramRendererBase with DiagramControllerMixin {
  MyDiagram({
    super.config,
    Map<String, dynamic>? initialValues,
    void Function(Map<String, dynamic>)? onValuesChanged,
  }) : super() {
    initializeController(
      defaultValues: initialValues ?? {},
      onValuesChanged: onValuesChanged,
    );
  }

  @override
  List<DrawableElement> createElements() {
    return [
      CircleElement(
        x: controller.getValue<double>('x') ?? 0,
        y: controller.getValue<double>('y') ?? 0,
        radius: controller.getValue<double>('radius') ?? 1.0,
      ),
    ];
  }
}
```

## Integration Methods

### 1. Embedded Component in Flutter Web Apps

The recommended approach when adding diagrams to an existing Flutter web application. The diagram becomes a Flutter widget that can be controlled like any other Flutter component.

```dart
class EmbeddedDiagram extends StatefulWidget {
  final Map<String, dynamic> initialState;
  final void Function(Map<String, dynamic>)? onStateChanged;
  
  const EmbeddedDiagram({
    super.key,
    this.initialState = const {},
    this.onStateChanged,
  });

  @override
  State<EmbeddedDiagram> createState() => _EmbeddedDiagramState();
}

class _EmbeddedDiagramState extends State<EmbeddedDiagram> {
  late MyDiagram diagram;

  @override
  void initState() {
    super.initState();
    diagram = MyDiagram(
      initialValues: widget.initialState,
      onValuesChanged: widget.onStateChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return diagram.buildDiagramWidget(context);
  }
}
```

Use this approach when:
- Adding diagrams to an existing Flutter web application
- Need to control diagrams with Flutter widgets (buttons, sliders, etc.)
- Need to integrate with Flutter state management
- Want to maintain Flutter's widget composition pattern

#### State Management with Embedded Components
The diagram's state can be managed in several ways:
1. Local state using the controller
2. Parent widget state via `onStateChanged`
3. Global state management (Provider, Bloc, etc.)

Example with Provider:
```dart
class DiagramState extends ChangeNotifier {
  Map<String, dynamic> _values = {};
  
  void updateValues(Map<String, dynamic> newValues) {
    _values = newValues;
    notifyListeners();
  }
}

// Usage
EmbeddedDiagram(
  initialState: context.watch<DiagramState>().values,
  onStateChanged: context.read<DiagramState>().updateValues,
)
```

### 2. Standalone Web Component

Use this approach when embedding diagrams into non-Flutter web pages. This creates a self-contained web component that can interact with regular HTML/JavaScript.

```dart
@JS()
library diagram_js;

import 'package:js/js.dart';

@JS('renderDiagram')
external set _renderDiagram(void Function(String containerId, String config) f);

void main() {
  _renderDiagram = allowInterop((String containerId, String config) {
    final diagram = MyDiagram(
      initialValues: jsonDecode(config),
      onValuesChanged: (values) {
        // Send updates back to JavaScript
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

Use this approach when:
- Embedding diagrams in non-Flutter web pages
- Need to interact with HTML elements or JavaScript libraries
- Want to use the diagram as a standalone web component

#### JavaScript Integration Details
The standalone component requires:
1. JavaScript interop setup
2. Bidirectional communication handlers
3. Web-specific initialization

## Integration Decision Guide

Choose your integration method based on:

1. **Target Environment**
   - Existing Flutter Web App → Use Embedded Component
   - Non-Flutter Web Page → Use Standalone Web Component

2. **Control Requirements**
   - Flutter Widgets/State → Use Embedded Component
   - HTML/JavaScript Controls → Use Standalone Web Component
   - Mix of Both → Use Standalone Web Component

3. **Performance Considerations**
   - Best Performance → Use Embedded Component (native Flutter)
   - Web Integration Required → Use Standalone Web Component

## Examples

### Example 1: Flutter Web App Integration
```dart
// In your Flutter web app
class MyFlutterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          EmbeddedDiagram(
            initialState: {'value': 0.5},
            onStateChanged: (values) {
              // Handle state changes within Flutter
            },
          ),
          FlutterButton(...), // Control diagram with Flutter widgets
        ],
      ),
    );
  }
}
```

### Example 2: Non-Flutter Web Page Integration
```html
<!-- In your HTML page -->
<div id="diagram-container"></div>
<input type="range" onchange="updateDiagram(this.value)">

<script>
// Initialize diagram
window.renderDiagram('diagram-container', JSON.stringify({
  x: 0,
  y: 0,
  radius: 1.0
}));

// Handle diagram updates
window.onDiagramUpdate = function(values) {
  console.log('Diagram updated:', JSON.parse(values));
};

function updateDiagram(value) {
  // Use JavaScript API to control diagram
  window.renderDiagram('diagram-container', JSON.stringify({
    value: value
  }));
}
</script>
```

## Related Documentation

- [Diagram Integration Architecture](diagram_integration_architecture.md)
- [Element Architecture](Element_Architecture.md)
- [Creating New Demos](Creating_New_Demos.md)
- [DL Compliance](Diagram_DL_Compliance.md)
