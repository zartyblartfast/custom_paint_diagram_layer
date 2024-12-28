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

## Quick Start: State-Managed Diagrams

### Method 1: Using Templates
The fastest way to create a diagram is using our pre-built templates:

```dart
// Create a basic chart diagram
final chartDiagram = BasicChartDiagram(
  config: DiagramConfig(
    width: 400,
    height: 300,
  ),
  dataPoints: [
    Point(0, 0, "Start"),
    Point(5, 5, "Middle"),
    Point(10, 10, "End"),
  ],
  style: ChartStyle(
    pointColor: Colors.blue,
    showDataLabels: true,
  ),
);

// Use in your widget
Widget build(BuildContext context) {
  return chartDiagram.buildDiagramWidget(context);
}
```

### Method 2: Using the Builder
For more customization, use the DiagramBuilder:

```dart
final diagram = DiagramBuilder()
  .withSize(400, 300)
  .withRange(
    xMin: 0,
    xMax: 10,
    yMin: 0,
    yMax: 10,
  )
  .withVisibility(
    showGrid: true,
    showAxes: true,
  )
  .addElements([
    CircleElement(
      x: 5,
      y: 5,
      radius: 2,
      color: Colors.blue,
    ),
  ])
  .build();
```

### Method 3: Using Configuration (Code Generation)
Define your diagram in YAML or JSON:

```yaml
name: MyChart
type: chart
canvas:
  width: 400
  height: 300
  xMin: 0
  xMax: 10
  yMin: 0
  yMax: 10
elements:
  - type: circle
    properties:
      x: 5
      y: 5
      radius: 2
      color: blue
controls:
  - type: slider
    name: radius
    properties:
      min: 1
      max: 5
      initial: 2
```

Then generate and use the diagram:

```dart
final schema = await DiagramSchema.fromFile('my_chart.yaml');
final diagram = DiagramGenerator.fromSchema(schema);
```

## Common Patterns

### 1. Adding Controls
```dart
// Add a slider control
diagram.state.registerControl('size', 1.0);
ElevatedButton(
  onPressed: () => diagram.state.updateControl('size', 2.0),
  child: Text('Increase Size'),
)
```

### 2. Updating Elements
```dart
// Update specific elements
diagram.updateElements([
  CircleElement(x: 5, y: 5, radius: newRadius),
]);
```

### 3. Handling State Changes
```dart
// Listen for state changes
diagram.state.addStateCallback('size', (value) {
  print('Size changed to: $value');
});
```

## Best Practices

1. **Use Templates First**: Start with a template and customize as needed
2. **State Management**: Use the built-in state manager for all dynamic properties
3. **Element Organization**: Group related elements using GroupElement
4. **Error Prevention**: Use the builder pattern to ensure valid configuration
5. **Testing**: Each diagram comes with testing utilities

For more examples and detailed documentation:
- [State Management Guide](docs/state_management.md)
- [Template Gallery](docs/templates.md)
- [Builder Pattern Guide](docs/builder_pattern.md)
- [Code Generation](docs/code_generation.md)

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
