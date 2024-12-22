# Integration Guide: Flutter Diagram Layer

When integrating diagrams created with your Flutter Dart diagram layer into another webpage, you have several approaches depending on the structure of your diagrams and how you'd like them to function within an external webpage. Below are the key highlights and options to help you understand the possibilities and choose the most suitable path:

## 1. Embedding the Diagram as an IFrame

### How It Works:
- Host your diagram (or a Flutter app rendering the diagram) on a server (e.g., GitHub Pages)
- Use an `<iframe>` to embed the diagram in an external webpage

### Steps:
1. Deploy your diagram layer diagram as a standalone web page using the PowerShell script (e.g., diagram.html hosted at https://zartyblartfast.github.io/diagram.html)
2. In the target webpage, embed the diagram using:
```html
<iframe
    src="https://zartyblartfast.github.io/diagram.html"
    width="800"
    height="600"
    frameborder="0">
</iframe>
```

### Advantages:
- Simple integration without needing modifications to your Flutter project
- The diagram remains interactive (if your Flutter app supports interactivity)
- Easy updates to diagrams since they're hosted externally

### Disadvantages:
- Limited styling or layout control over the iframe's contents
- Dependency on external hosting

## 2. Exporting Diagrams as Images (Static Integration)

### How It Works:
- Render your diagrams as static images (e.g., PNG, SVG)
- Embed these images into the webpage

### Steps:
1. Modify your Flutter diagram layer to include an export function using Flutter's dart:ui library:
```dart
Future<void> exportDiagramToImage() async {
    final boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();
    // Save or download `buffer` as a .png file.
}
```
2. Generate and save/export the diagram as an image
3. Embed the exported image in the target webpage:
```html
<img src="path/to/diagram.png" alt="Diagram">
```

### Advantages:
- Lightweight and independent of Flutter runtime
- Full control over webpage layout and styling

### Disadvantages:
- Diagrams are static (no interactivity)
- Requires manual export for updates

## 3. Embedding Diagrams as Web Components

### How It Works:
- Use Flutter's web build to generate a custom web component (a reusable, self-contained element)
- Integrate the web component into any webpage

### Steps:
1. Build your diagram layer with Flutter for the web
2. Wrap the diagram rendering logic in a custom web component
3. Use the custom web component in your HTML:
```html
<script type="module" src="https://path/to/diagram_component.js"></script>
<diagram-layer id="custom-diagram"></diagram-layer>
```

### Advantages:
- Diagrams are interactive and fully functional
- Easy reuse across multiple webpages

### Disadvantages:
- Requires more effort to package your diagram as a web component
- May increase the webpage size due to embedded Flutter runtime

## 4. Embedding Diagrams via JavaScript API

### How It Works:
- Expose a JavaScript API in your Flutter app for rendering diagrams dynamically
- Integrate this API into the target webpage

### Steps:
1. Modify your Flutter app to include a JavaScript interface using dart:js or dart:js_util:
```dart
import 'dart:js';

void renderDiagram(String elementId) {
    final container = document.getElementById(elementId);
    // Code to render diagram inside `container`.
}

void main() {
    context['renderDiagram'] = renderDiagram;
}
```
2. Build your Flutter app for the web and host the output (e.g., on GitHub Pages)
3. Use the JavaScript API to embed the diagram:
```html
<div id="diagram-container"></div>
<script src="https://path/to/flutter_app.js"></script>
<script>
    renderDiagram('diagram-container');
</script>
```

### Advantages:
- Full control over integration and layout
- Diagrams remain interactive
- Can dynamically render diagrams based on API calls

### Disadvantages:
- Requires knowledge of both JavaScript and Dart interop
- Dependency on Flutter runtime

## 5. Sharing Diagrams via GitHub Dependencies

### How It Works:
- Share your diagram layer as a Flutter package hosted on GitHub
- Use the package in any other Flutter web project

### Steps:
1. Refactor your diagram layer into a standalone Flutter package
2. Publish the package to GitHub
3. Add the package as a dependency in pubspec.yaml:
```yaml
dependencies:
  diagram_layer:
    git:
      url: https://github.com/username/diagram_layer
```
4. Use the package in other projects to render diagrams
5. Render diagrams in the new project's web build and integrate them into webpages using methods like iframe or web components

### Advantages:
- Shareable and reusable
- Allows integration with any Flutter-based project

### Disadvantages:
- Requires the consuming webpage to be a Flutter app or host one

## Comparison of Options

| Option | Interactivity | Ease of Use | Customization | Use Case |
|--------|--------------|-------------|---------------|-----------|
| IFrame | High | Easy | Limited | Embedding full diagrams hosted elsewhere |
| Static Images | None | Easy | High | Sharing static, non-interactive diagrams |
| Web Components | High | Moderate | High | Creating reusable diagram elements |
| JavaScript API | High | Moderate | High | Dynamically embedding diagrams in webpages |
| GitHub Dependency | High | Advanced | High | Sharing the diagram layer for use in other Flutter projects |
