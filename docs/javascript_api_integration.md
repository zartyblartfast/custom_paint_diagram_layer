# JavaScript API Integration Guide

This guide provides a detailed explanation of embedding diagrams via JavaScript API, including rationale, implementation steps, and advanced use cases.

## How It Works

The Flutter diagram layer exposes a JavaScript API that allows other webpages to dynamically render and interact with the diagrams. This approach integrates the diagram logic into the parent webpage without requiring the entire Flutter app to act as a standalone page.

Using Dart's `dart:js` or `dart:js_util` libraries, you can create JavaScript functions that are callable directly from the embedding webpage. The webpage can use these functions to:

- Dynamically create and render diagrams within specific HTML containers
- Pass configuration parameters (e.g., colors, shapes, or layout settings) to customize the diagrams at runtime
- Update diagram properties in real-time
- Handle interactions between the webpage and diagram

## Implementation Steps

### 1. Expose JavaScript Functions from Flutter

Add a Dart function that uses the `dart:js` library to define JavaScript-accessible functions:

```dart
import 'dart:html';
import 'dart:js';

void renderDiagram(String elementId, String config) {
  // Locate the target container by its ID
  final container = document.getElementById(elementId);
  if (container != null) {
    // Replace container's inner HTML with the Flutter app rendering the diagram
    container.innerHtml = ''; // Clear the container
    runApp(MyDiagramLayerApp(config: config));
  } else {
    print('Error: No element found with ID: $elementId');
  }
}

void main() {
  // Expose the `renderDiagram` function to JavaScript
  context['renderDiagram'] = renderDiagram;
  // Optional: Run a default Flutter app instance
  runApp(MyDiagramLayerApp());
}
```

- `renderDiagram(String elementId, String config)`:
  - `elementId`: The ID of the container where the diagram should be rendered
  - `config`: A JSON string containing configuration details for the diagram

- `context['renderDiagram']`:
  - Binds the renderDiagram Dart function to the global JavaScript context
  - Makes it callable from JavaScript

### 2. Build the Flutter Web App

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

### 3. Host the Compiled Flutter App

Host the compiled files on a web server or include them in the target webpage's project folder:

```
diagram-layer/
  flutter.js
  main.dart.js
  assets/
```

### 4. Integrate the Flutter Diagram into a Webpage

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
