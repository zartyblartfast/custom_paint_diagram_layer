# Custom Paint Diagram Layer

A powerful Flutter package for creating interactive engineering diagrams with a flexible coordinate system and rich set of drawable elements.

## Features

- **Flexible Coordinate System**
  - Engineering coordinate space (Y-axis grows upward)
  - Dynamic scaling and transformation
  - Support for custom alignments
  - Automatic bounds calculation

- **Rich Element Library**
  - Basic shapes (lines, rectangles, triangles)
  - Complex shapes (stars, parallelograms)
  - Curves (Bezier, arcs, spirals)
  - Text elements with alignment options
  - Measurement tools (rulers, grids)
  - Group elements for composition

- **Styling Options**
  - Stroke customization
  - Fill colors with opacity
  - Dash patterns for lines
  - Custom colors and sizes

- **Performance**
  - Efficient rendering pipeline
  - Smart bounds calculation
  - Optimized coordinate transformations

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  custom_paint_diagram_layer:
    git:
      url: https://github.com/zartyblartfast/custom_paint_diagram_layer.git
      ref: v0.0.1  # Use latest tagged version
```

### Basic Usage

```dart
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

// Create a basic diagram
final layer = BasicDiagramLayer(
  coordinateSystem: CoordinateSystem(
    origin: Point(0, 0),
    scale: 100,
    alignment: CanvasAlignment.center,
  ),
  showAxes: true,
)
.addElement(LineElement(
  x1: -1, y1: 0,
  x2: 1, y2: 0,
  color: Colors.blue,
))
.addElement(TextElement(
  x: 0, y: 1,
  text: "Example",
  color: Colors.black,
));

// Use in a CustomPaint widget
CustomPaint(
  painter: DiagramPainter(layer),
  size: Size(400, 300),
)
```

## Documentation

Comprehensive documentation is available in the `docs` directory:

- [Architecture Overview](docs/architecture/uml.md)
- [Layer Architecture](docs/Layer_Architecture.md)
- [Element Architecture](docs/Element_Architecture.md)
- [GitHub Dependency Guide](docs/github_dependency.md)

## Examples

Check out the `devtest/demos` directory for example implementations:

- Basic diagram setup
- Engineering coordinate systems
- Complex shapes and curves
- Interactive elements
- Measurement tools

## Development

### Prerequisites
- Flutter SDK >=3.0.0
- Dart SDK >=3.0.0 <4.0.0

### Running Tests
```bash
flutter test
```

### Building Documentation
```bash
dart doc .
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the excellent CustomPainter framework
- Contributors and users of this package
