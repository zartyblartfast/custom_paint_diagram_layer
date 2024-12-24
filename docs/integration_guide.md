# Integration Guide: Flutter Diagram Layer

This guide covers different approaches for integrating diagrams created with the Custom Paint Diagram Layer framework into other applications. The framework's renderer-based architecture with controller state management provides flexible integration options.

## Integration Methods

### 1. Standalone Flutter Web Application

Create a diagram by extending `DiagramRendererBase` and use `DiagramControllerMixin` for state management:

```dart
class MyDiagram extends DiagramRendererBase with DiagramControllerMixin {
  MyDiagram({
    super.config,
    Map<String, dynamic>? initialValues,
  }) : super() {
    initializeController(defaultValues: initialValues ?? {});
  }

  @override
  List<DrawableElement> createElements() {
    return [
      CircleElement(
        x: 0,
        y: 0,
        radius: controller.getValue<double>('radius') ?? 1.0,
      ),
    ];
  }
}
```

### 2. Embedded Component Integration

Create a reusable widget component that can be integrated into existing Flutter applications:

```dart
class EmbeddedDiagram extends StatefulWidget {
  final Map<String, dynamic> initialState;
  
  const EmbeddedDiagram({
    super.key,
    this.initialState = const {},
  });

  @override
  State<EmbeddedDiagram> createState() => _EmbeddedDiagramState();
}

class _EmbeddedDiagramState extends State<EmbeddedDiagram> {
  late MyDiagram diagram;

  @override
  void initState() {
    super.initState();
    diagram = MyDiagram(initialValues: widget.initialState);
  }

  @override
  Widget build(BuildContext context) {
    return diagram.buildDiagramWidget(context);
  }
}
```

### 3. JavaScript Integration

Enable web integration with JavaScript interop:

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

### 4. Package Distribution

Share as a Flutter package:

```yaml
dependencies:
  custom_paint_diagram_layer:
    git:
      url: https://github.com/username/custom_paint_diagram_layer
      ref: main
```

## Integration Decision Guide

Choose your integration method based on:

1. **Target Environment**
   - Flutter Web App → Standalone/Embedded
   - Non-Flutter Web → JavaScript Integration
   - Multiple Projects → Package Distribution

2. **State Management**
   - Simple State → Controller Defaults
   - Complex State → Custom Controller
   - External State → JavaScript Integration

3. **Performance**
   - Best Performance → Standalone Flutter
   - Minimal Overhead → Embedded
   - Web Integration → JavaScript

## Related Documentation

- [Diagram Integration Architecture](diagram_integration_architecture.md)
- [Element Architecture](Element_Architecture.md)
- [Creating New Demos](Creating_New_Demos.md)
- [DL Compliance](Diagram_DL_Compliance.md)
