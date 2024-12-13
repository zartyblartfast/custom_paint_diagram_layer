# Getting Started with GitHub Dependency

This guide walks you through setting up and using the custom_paint_diagram_layer package as a GitHub dependency in your Flutter projects.

## Initial Setup

1. **Add the Dependency**
   In your project's `pubspec.yaml`, add:
   ```yaml
   dependencies:
     custom_paint_diagram_layer:
       git:
         url: https://github.com/zartyblartfast/custom_paint_diagram_layer.git
         ref: "v0.0.1"  # Use latest tagged version
   ```

2. **Get Dependencies**
   ```bash
   flutter pub get
   ```

## Using the Template

The package includes a ready-to-use template to help you start quickly:

1. **Copy Template Code**
   - Find the template at `/templates/basic_diagram/main.dart` in the package repository
   - Copy its contents to your project's `lib/main.dart`

2. **Required Imports**
   Make sure you have all necessary imports:
   ```dart
   import 'package:flutter/material.dart';
   import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
   import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/line_element.dart';
   import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/rectangle_element.dart';
   import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/text_element.dart';
   import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/axis_element.dart';
   import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/layers/layers.dart';
   import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/coordinate_system.dart';
   import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/custom_paint_renderer.dart';
   ```

## Troubleshooting Common Issues

### 1. Dependency Not Found
If the package isn't being found:
- Verify your `pubspec.yaml` formatting
- Check GitHub access
- Try cleaning the pub cache:
  ```bash
  flutter clean
  flutter pub cache clean
  flutter pub get
  ```

### 2. Import Issues
If you see import errors:
- Make sure all required imports are present (see above)
- Check that `flutter pub get` completed successfully
- Verify you're using the correct package path in imports

### 3. Version/Reference Issues
If you need to update or change versions:
- Use a specific commit hash for stability
- Use tagged versions for releases
- Use main branch for latest (potentially unstable) changes

## Updating the Dependency

To update to a newer version:
1. Change the `ref:` in your pubspec.yaml to the desired version/commit
2. Clean and update:
   ```bash
   flutter clean
   flutter pub cache clean
   flutter pub get
   ```

## Next Steps

After successful setup:
1. Run the template code to verify everything works
2. Customize the coordinate system for your needs
3. Add your own diagram elements
4. Implement your specific diagram requirements

## Need Help?

- Check the [Implementation Guide](Implementation_Guide.md) for best practices
- See [Implementation Issues](Implementation_Issues.md) for common problems and solutions
- Visit the GitHub repository for latest updates and issues
