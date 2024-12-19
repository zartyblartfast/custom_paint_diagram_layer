# Creating New Demos Guide

## Important Documentation
Before creating a new demo, review these resources:
- [Element Architecture](Element_Architecture.md) - Details of all available elements and their properties
- [Implementation Approach](Implementation_Approach.md) - Overall framework design

## Project Structure
The project is organized into two main parts:
1. The diagram layer library (in `/lib/`)
2. The demo application (in `/devtest/`)

```
custom_paint_diagram_layer/
├── lib/                              # Diagram layer library
│   ├── custom_paint_diagram_layer/   # Implementation
│   │   ├── elements/                 # Drawing elements
│   │   └── ...                      # Other core code
│   └── custom_paint_diagram_layer.dart  # Library entry
│
├── devtest/                          # Demo application
│   ├── demos/                        # All interactive demos
│   │   ├── butterfly_art.dart
│   │   ├── color_harmony_art.dart
│   │   └── ...
│   ├── utils/                        # Demo utilities
│   │   └── diagram_test_base.dart
│   └── main.dart                     # Demo app entry
```

## Key Principles
1. **Use DL Elements Only**
   - All drawing MUST be done through DL element classes
   - Never use Flutter's Canvas directly
   - See [Element Architecture](Element_Architecture.md) for available elements

2. **Basic Structure**
   - Use `IDiagramLayer` for the diagram
   - Render with `CustomPaintRenderer`
   - Only use Flutter widgets for UI controls (sliders, buttons, etc.)

3. **File Organization**
   - All demos go in `/devtest/demos/`
   - Never put demos in `/lib/` (library code only)
   - Keep demo files at root of demos/ (no nested folders)

## Quick Start

1. **Create Demo File**
   ```bash
   # Create your demo in the correct location
   /devtest/demos/my_new_demo.dart
   ```

2. **Basic Template**
   ```dart
   import 'package:flutter/material.dart';
   import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
   import 'dart:math' as math;  // if needed

   class MyNewDemo extends StatefulWidget {
     const MyNewDemo({super.key});
     @override
     State<MyNewDemo> createState() => _MyNewDemoState();
   }
   ```

3. **Add to Menu**
   - In `/devtest/main.dart`:
   ```dart
   import 'demos/my_new_demo.dart';
   // ...
   ListTile(
     title: const Text('My New Demo'),
     onTap: () => Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => const MyNewDemo()),
     ),
   ),
   ```

4. **Run**
   ```bash
   # Always run from devtest directory
   cd devtest
   flutter run -d chrome -t main.dart
   ```

## Common Mistakes to Avoid

1. **Wrong Location**
   - ❌ Don't create demos in `/lib/` (library code only)
   - ✅ Always use `/devtest/demos/`

2. **File Organization**
   - ❌ Don't create nested folders in demos
   - ✅ Keep all demo files at root of demos/

3. **Running**
   - ❌ Don't run from project root
   - ✅ Always run from devtest directory

4. **Type Conversions**
   - ❌ Don't pass `num` to parameters expecting `double`
   - ✅ Use `.toDouble()` on numeric calculations
   ```dart
   final value = (x * y).toDouble();  // Convert to double
   ```

5. **Element Properties**
   - ❌ Don't guess element properties or parameters
   - ✅ Always check [Element Architecture](Element_Architecture.md) for correct usage
   ```dart
   // Example: Creating a polygon requires points
   final points = List<Point2D>.generate(4, (index) {
     final angle = index * math.pi / 2;
     return Point2D(
       x + math.cos(angle) * size,
       y + math.sin(angle) * size,
     );
   });
   
   PolygonElement(
     points: points,  // Check Element_Architecture.md for required properties
     x: x,
     y: y,
     color: Colors.blue,
   )
   ```

## Available Elements
The framework provides several drawing elements. See [Element Architecture](Element_Architecture.md) for full details:
- CircleElement
- PolygonElement
- BezierCurveElement
- LineElement
- TextElement
And more...

## Reference Demos
- `engineering_coords_test.dart` - Basic coordinate system
- `spring_balance_demo.dart` - Interactive physics
- `butterfly_art.dart` - Artistic composition
- `color_harmony_art.dart` - Abstract art with color theory
