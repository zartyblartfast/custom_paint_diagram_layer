# JavaScript API Integration Guide

This guide explains how to integrate diagrams using JavaScript API with the Custom Paint Diagram Layer framework's renderer-based architecture.

## How It Works

The Flutter diagram layer exposes a JavaScript API that allows other webpages to dynamically render and interact with the diagrams. This approach integrates the diagram logic into the parent webpage without requiring the entire Flutter app to act as a standalone page.

Using Dart's `dart:js` or `dart:js_util` libraries, you can create JavaScript functions that are callable directly from the embedding webpage. The webpage can use these functions to:

- Dynamically create and render diagrams within specific HTML containers
- Pass configuration parameters (e.g., colors, shapes, or layout settings) to customize the diagrams at runtime
- Update diagram properties in real-time
- Handle interactions between the webpage and diagram

## Implementation Steps

### 1. Create the Diagram Class

```dart
class WebDiagram extends DiagramRendererBase with DiagramControllerMixin {
  WebDiagram({Map<String, dynamic>? config}) : super() {
    initializeController(
      defaultValues: config ?? {},
      onValuesChanged: _notifyJavaScript,
    );
  }

  void _notifyJavaScript(Map<String, dynamic> values) {
    js.context.callMethod('onDiagramChanged', [jsonEncode(values)]);
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

### 2. Create JavaScript Interface

```dart
@JS()
library diagram_js;

import 'package:js/js.dart';

@JS('renderDiagram')
external set _renderDiagram(void Function(String containerId, String config) f);

void main() {
  _renderDiagram = allowInterop((String containerId, String config) {
    final diagram = WebDiagram(
      config: jsonDecode(config),
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

### 3. Build the Flutter Web App

Use the Flutter build process to compile the app into JavaScript-compatible files:

```bash
flutter build web
```

This generates the following structure in `build/web`:
```
build/
  web/
    index.html        # Main HTML entry point (optional)
    flutter.js        # The Flutter runtime loader
    main.dart.js      # Compiled Dart code
    assets/           # Resources required by the Flutter app
```

Key files for integration:
- `flutter.js`: The Flutter runtime loader
- `main.dart.js`: The compiled Flutter app containing your diagram logic

### 4. Host the Compiled Flutter App

Host the compiled files on a web server or include them in the target webpage's project folder:

```
diagram-layer/
  flutter.js
  main.dart.js
  assets/
```

### 5. Integrate the Flutter Diagram into a Webpage

Include the Flutter runtime and initialize the diagram in your target webpage:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Flutter Diagram Integration</title>
    <!-- Include the Flutter runtime -->
    <script type="module" src="diagram-layer/flutter.js"></script>
    <script src="diagram-layer/main.dart.js"></script>
</head>
<body>
    <h1>Diagram Example</h1>
    <!-- Container where the diagram will be rendered -->
    <div id="diagram-container"></div>

    <script>
        // Call the exposed JavaScript API to render the diagram
        const config = JSON.stringify({ color: "blue", size: "large" });
        renderDiagram('diagram-container', config);
    </script>
</body>
</html>
```

- Container ID: The `<div id="diagram-container"></div>` acts as the placeholder for the diagram
- `renderDiagram` Call: Invokes the exposed Dart function, passing the ID of the container and configuration details as a JSON string

## Advanced Use Cases

### 1. Dynamically Update the Diagram

Expose additional JavaScript functions for modifying the diagram at runtime:

```dart
void updateDiagram(String config) {
  // Parse the configuration and apply updates to the diagram
  final parsedConfig = jsonDecode(config);
  updateAppWithConfig(parsedConfig); // Custom function to update the diagram
}

void main() {
  context['renderDiagram'] = renderDiagram;
  context['updateDiagram'] = updateDiagram; // Expose an update function
  runApp(MyDiagramLayerApp());
}
```

Usage in webpage:
```html
<script>
    // Dynamically update the diagram with new configurations
    const newConfig = JSON.stringify({ color: "red", size: "medium" });
    updateDiagram(newConfig);
</script>
```

### 2. Handle Events and Callbacks

Make the diagram interactive by allowing it to trigger JavaScript callbacks:

```dart
import 'dart:js';

void notifyDiagramClicked(String message) {
  // Call a JavaScript function when the diagram is clicked
  context.callMethod('onDiagramClick', [message]);
}

void main() {
  // Simulate notifying JavaScript on diagram interaction
  runApp(MyDiagramLayerApp(onClick: () => notifyDiagramClicked("Diagram clicked!")));
}
```

Usage in webpage:
```html
<script>
    // Define a callback function to handle diagram events
    function onDiagramClick(message) {
        alert("Event from Diagram: " + message);
    }
</script>
```

### 3. Pass Complex Data Between Flutter and JavaScript

Use JSON for structured data exchange:

```javascript
// Pass a configuration to render a diagram
const config = JSON.stringify({
    nodes: [{ id: 1, label: "Node 1" }, { id: 2, label: "Node 2" }],
    edges: [{ source: 1, target: 2 }]
});
renderDiagram('diagram-container', config);
```

## State Management

The diagram uses `DiagramControllerMixin` for state management:

1. **Initial State**
   - Passed via JavaScript as config object
   - Initialized in controller

2. **State Updates**
   - JavaScript can update state via controller
   - Controller notifies JavaScript of changes

3. **Two-way Binding**
   - Controller state reflects in diagram
   - Diagram changes update JavaScript

## Best Practices

1. **State Management**
   - Use controller for all state changes
   - Keep state serializable for JS
   - Handle state validation

2. **Performance**
   - Minimize state updates
   - Batch related changes
   - Use appropriate data types

3. **Error Handling**
   - Validate JavaScript input
   - Handle missing values
   - Provide error feedback

## Advantages and Disadvantages

### Pros
- Full control over integration and layout
- Diagrams remain interactive and fully functional
- Dynamic rendering and real-time updates are possible
- Lightweight compared to embedding the entire Flutter app in an iframe

### Cons
- Requires knowledge of both JavaScript and Dart interop
- Dependency on the Flutter runtime and JavaScript API
- Webpages embedding the diagram must include the compiled Flutter files

## Best Use Cases

1. **Dynamic Diagrams**: When the diagram needs to be updated in real time or configured dynamically based on user input
2. **Complex Interactions**: When interaction between the webpage and the diagram (e.g., callbacks or data sharing) is required
3. **Modular Integration**: When embedding a diagram into an existing webpage without hosting a standalone Flutter app
