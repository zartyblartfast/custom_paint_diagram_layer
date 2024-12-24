# Using This Package as a GitHub Dependency

This document explains how to use the custom_paint_diagram_layer package directly from GitHub in your Flutter projects.

## Adding the Dependency

Add this package to your `pubspec.yaml` dependencies section using one of the following formats:

### Latest Stable Version (Recommended)
```yaml
dependencies:
  custom_paint_diagram_layer:
    git:
      url: https://github.com/zartyblartfast/custom_paint_diagram_layer.git
      ref: v0.0.1  # Use the latest tagged version
```

### Latest Development Version
```yaml
dependencies:
  custom_paint_diagram_layer:
    git:
      url: https://github.com/zartyblartfast/custom_paint_diagram_layer.git
      ref: main    # Use the main branch (may be unstable)
```

### Specific Commit Version
```yaml
dependencies:
  custom_paint_diagram_layer:
    git:
      url: https://github.com/zartyblartfast/custom_paint_diagram_layer.git
      ref: 35e6209  # Use a specific commit hash
```

## Version Control Reference

You can specify different versions of the package using:
- **Tags** (e.g., `ref: v0.0.1`): Best for stable releases
- **Branch names** (e.g., `ref: main`): Best for development
- **Commit hashes** (e.g., `ref: 35e6209`): Best for specific versions

## Installing the Package

After adding the dependency to your pubspec.yaml:

1. Run Flutter pub get:
   ```bash
   flutter pub get
   ```

2. If you encounter any issues, try:
   ```bash
   flutter clean
   flutter pub get
   ```

## Using the Package

### Basic Import
For most use cases, start with the main package import:
```dart
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
```

### Specific Component Imports
For more granular control, you might need these imports:

```dart
// Core Components
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/renderers/diagram_renderer_base.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/coordinate_system.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/diagram_controller.dart';

// Elements
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/elements.dart';
// Or specific elements:
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/circle_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/line_element.dart';
// etc...

// Mixins
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/mixins/diagram_controller_mixin.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/mixins/diagram_migration_helper.dart';
```

## Quick Start Example

Here's a minimal example to get you started:

```dart
import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

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

class MyDiagramDemo extends StatefulWidget {
  const MyDiagramDemo({super.key});

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
        Slider(
          value: diagram.controller.getValue<double>('value') ?? 0.0,
          onChanged: (value) => diagram.updateFromSlider(value),
        ),
      ],
    );
  }
}
```

## Reference Examples

For more complex examples, check these implementations in the package:
- `migrated_butterfly_art.dart` - Full featured example with complex shapes
- `standalone_migrated_main.dart` - Standalone diagram usage
- `embedded_migrated_main.dart` - Embedded diagram with controls

## Troubleshooting

### 1. Import Issues
If the basic import doesn't work, try using specific imports as shown above.

### 2. Version Conflicts
- Make sure your Flutter SDK version is >= 3.0.0
- Check for conflicting dependencies in your pubspec.yaml

### 3. Runtime Errors
- Verify you're extending `DiagramRendererBase`
- Check that all required methods are implemented
- Ensure coordinate system is properly configured

## Next Steps

After successful setup:
1. Review the [Element Architecture](Element_Architecture.md) guide
2. Check the [Creating New Demos](Creating_New_Demos.md) guide
3. Ensure [DL Compliance](Diagram_DL_Compliance.md)

For more detailed documentation, see the `/docs` directory in the package.
