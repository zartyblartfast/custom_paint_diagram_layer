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

Import the package in your Dart code:

```dart
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
```

## Quick Start with Templates

For the fastest way to get started:

1. Copy one of our template projects from the `/templates` directory:
   - `basic_diagram`: A simple example showing core functionality
   - `spring_balance`: A more complex example with interactive elements

2. Update your `pubspec.yaml` with the package dependency
3. Run `flutter pub get`
4. Start customizing the template code for your needs

For detailed examples, check the template projects in the `/templates` directory.

## Available Versions

The package follows semantic versioning:
- v0.0.1: Initial release
  - Basic diagram layer functionality
  - Support for lines, rectangles, and text elements
  - Coordinate system with adjustable axes

## Updating the Package

To update to a newer version:

1. Change the `ref:` in your pubspec.yaml to the desired version
2. Run `flutter pub get`

## Best Practices

1. **For Production Apps:**
   - Always use tagged versions (e.g., `ref: v0.0.1`)
   - Avoid using branch names like `main`
   - Lock to specific versions for stability

2. **For Development:**
   - You can use branch names for latest features
   - Consider using commit hashes for reproducible builds
   - Test thoroughly when updating versions

## Troubleshooting

If you encounter issues:

1. Import Issues
   - If using the basic import doesn't work:
     ```dart
     import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
     ```
   - You may need these explicit imports:
     ```dart
     import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
     import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/line_element.dart';
     import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/rectangle_element.dart';
     import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/text_element.dart';
     import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/axis_element.dart';
     import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/layers/layers.dart';
     import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/coordinate_system.dart';
     import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/custom_paint_renderer.dart';
     ```

2. Dependency Cache Issues
   If changes aren't being picked up:
   ```bash
   flutter clean
   flutter pub cache clean
   flutter pub get
   ```

3. Check that your Flutter SDK version meets the requirements
4. Verify network access to GitHub

## Support

For issues, feature requests, or contributions:
- Visit our [GitHub repository](https://github.com/zartyblartfast/custom_paint_diagram_layer)
- Submit issues through the GitHub issue tracker
- Pull requests are welcome
