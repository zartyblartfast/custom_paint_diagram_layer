# Steps to Create and Use a Web Component from Flutter

This guide provides a detailed walkthrough of creating and using a web component from your Flutter diagram layer.

## 1. Prepare Your Diagram Layer as a Flutter Web Component

Flutter apps can be exported as web components by using a combination of the web build process and some customization.

### Add a wrapper function in main.dart:
Use `dart:html` to allow the Flutter app to initialize in a specific DOM container.

Example:
```dart
import 'dart:html';

void main() {
  // Bootstrap Flutter app
  runApp(MyDiagramLayerApp());

  // Expose a custom method to render the diagram in any target element
  querySelector('#diagram-container')?.append(
    DivElement()
      ..id = 'flutter-diagram'
      ..style.width = '100%'
      ..style.height = '100%',
  );
}
```

This makes your app compatible with embedding into another webpage.

## 2. Build the Web App

Build your Flutter project as a web app:
```bash
flutter build web
```

By default, this creates the following directory structure:
```
build/
  web/
    index.html
    main.dart.js
    flutter.js
    assets/
```

## 3. Modify the Output for Web Component Integration

Your `index.html` is intended as a standalone webpage. To integrate it as a web component, you need to:
- Use only the required files (`main.dart.js`, `flutter.js`, and `assets/`)
- Exclude `index.html` (or adapt it if needed)
- Wrap the diagram logic in a CustomElement

### Modify main.dart:
```dart
import 'dart:html';

void main() {
  // Register custom web component
  Element.customElement(
    'diagram-layer',
    DiagramLayerElement.new,
  );
}

class DiagramLayerElement extends HtmlElement {
  DiagramLayerElement() {
    this.attachShadow({'mode': 'open'}).innerHtml = '''
      <div id="diagram-container"></div>
    ''';
    renderDiagram();
  }

  void renderDiagram() {
    // Initialize the Flutter app in the shadow DOM
    runApp(MyDiagramLayerApp());
  }
}
```

## 4. Copy Files to Target Webpage's Project

Once built and modified:

Copy these files to the target webpage's project structure:
- `main.dart.js`
- `flutter.js`
- `assets/` (entire directory)

You can organize them in a folder like `/diagram-layer/` within the target webpage.

## 5. Integrate the Web Component

Include the Flutter runtime and register the custom web component in the target webpage:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Embed Diagram Layer</title>
    <script type="module" src="diagram-layer/flutter.js"></script>
    <script src="diagram-layer/main.dart.js"></script>
</head>
<body>
    <h1>Diagram Integration</h1>
    <diagram-layer></diagram-layer>
</body>
</html>
```

## How It Works

The web component is now available as `<diagram-layer>`:
- You can place it in any webpage
- The Flutter runtime initializes and renders the diagram inside this custom element

## Pros of This Approach

1. **Reusable**: Once created, the web component can be embedded in multiple webpages without modification
2. **Encapsulation**: The custom element encapsulates the Flutter diagram layer logic, ensuring it does not interfere with the surrounding webpage
3. **Interactive**: Diagrams remain fully interactive
4. **Modular**: The web component is lightweight and does not require hosting a full webpage
