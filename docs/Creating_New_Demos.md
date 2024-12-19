# Creating New Demos Guide

## Important Documentation
Before creating a new demo, review these resources:
- [Element Architecture](Element_Architecture.md) - **Required reading!** Contains:
  - All available elements and their properties
  - Required and optional parameters for each element
  - Correct parameter names (e.g., 'color' for stroke color)
- [Implementation Approach](Implementation_Approach.md) - Overall framework design

## Element Quick Reference
Every element requires these base parameters:
- `x` or `x1` (required): X position
- `y` or `y1` (required): Y position
- `color` (required): Stroke color (not 'strokeColor')
- `strokeWidth` (optional): Width of stroke, defaults to 1.0

Element-specific parameters:
```dart
// Circle
CircleElement(
  x: 0.0,           // Center X
  y: 0.0,           // Center Y
  radius: 100.0,    // Required
  color: Colors.black,
  fillColor: Colors.blue,  // Optional
);

// Line
LineElement(
  x1: 0.0,          // Start X
  y1: 0.0,          // Start Y
  x2: 100.0,        // End X
  y2: 100.0,        // End Y
  color: Colors.black,
  strokeWidth: 2.0,
);

// Polygon
PolygonElement(
  points: [         // Required list of points
    Point2D(0, 0),
    Point2D(100, 0),
    Point2D(50, 100),
  ],
  x: 0.0,          // Reference point X
  y: 0.0,          // Reference point Y
  color: Colors.black,
  fillColor: Colors.blue,  // Optional
  closed: true,    // Optional, defaults to true
);

// Bezier Curve
BezierCurveElement(
  x1: 0.0,         // Start X
  y1: 0.0,         // Start Y
  controlX1: 50.0, // First control point X
  controlY1: -50.0,// First control point Y
  controlX2: 150.0,// Second control point X
  controlY2: -50.0,// Second control point Y
  x2: 200.0,       // End X
  y2: 0.0,         // End Y
  color: Colors.black,
);
```

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
   - **Always check [Element Architecture](Element_Architecture.md) for correct parameter names**

2. **Basic Structure**
   - Use `IDiagramLayer` for the diagram
   - Pass elements in the constructor:
     ```dart
     return BasicDiagramLayer(
       coordinateSystem: CoordinateSystem(...),
       elements: myElements,  // Pass list here, don't set later
     );
     ```
   - Render with `CustomPaintRenderer`
   - Only use Flutter widgets for UI controls (sliders, buttons, etc.)

3. **Required Parameters**
   - All elements require x and y position parameters
   - This includes elements that use other positioning methods (like points)
   - Example with PolygonElement:
     ```dart
     PolygonElement(
       points: [Point2D(0,0), Point2D(1,1), Point2D(0,1)],
       x: 0,  // Required position
       y: 0,  // Required position
       color: Colors.black,  // Stroke color (not 'strokeColor')
       fillColor: Colors.blue,  // Interior color
       // ... other parameters from Element Architecture doc
     )
     ```

4. **File Organization**
   - All demos go in `/devtest/demos/`
   - Never put demos in `/lib/` (library code only)
   - Keep demo files at root of demos/ (no nested folders)

## Choosing Your Starting Point

Choose a template based on what you're building:

1. **Data Visualization** (graphs, charts, waveforms)
   ```dart
   // Start with: signal_waveform_art.dart or harmony_wave_art.dart
   Features:
   - Cartesian coordinate system (-400 to 400, -300 to 300)
   - Grid system with axes
   - LineElement for graphs
   - PolygonElement for continuous curves
   - Time/value-based animations
   Best for: Scientific plots, waveforms, data charts
   ```

2. **Geometric Patterns** (mandalas, kaleidoscopes)
   ```dart
   // Start with: color_harmony_art.dart or kaleidoscope_art.dart
   Features:
   - Centered coordinate system
   - Rotation and symmetry helpers
   - CircleElement for points and decorations
   - PolygonElement for shapes
   - Color transitions and patterns
   Best for: Mandalas, kaleidoscopes, geometric art
   ```

3. **Natural Forms** (organic shapes, curves)
   ```dart
   // Start with: butterfly_art.dart
   Features:
   - BezierCurveElement for smooth curves
   - Natural animation patterns
   - Gradient and opacity effects
   - Compound shapes
   - Nature-inspired mathematics
   Best for: Animals, plants, organic patterns
   ```

4. **Technical Diagrams** (schematics, flowcharts)
   ```dart
   // Start with: signal_waveform_art.dart
   Features:
   - Precise positioning
   - LineElement for connections
   - Text alignment helpers
   - Grid snapping
   - Clean, technical style
   Best for: Circuit diagrams, flowcharts, technical illustrations
   ```

Each template provides:
- Working coordinate system
- Correct parameter usage
- Animation framework
- Interactive controls
- Error-free structure

### Template Selection Tips

1. **Match Your Primary Elements**
   - Lots of straight lines? → signal_waveform_art
   - Curved shapes? → butterfly_art
   - Repeating patterns? → kaleidoscope_art

2. **Consider Animation Needs**
   - Smooth transitions? → color_harmony_art
   - Time-based? → harmony_wave_art
   - Natural motion? → butterfly_art

3. **Look at Scale Requirements**
   - Full canvas? → signal_waveform_art
   - Centered design? → kaleidoscope_art
   - Variable zoom? → harmony_wave_art

4. **Check Interaction Model**
   - Slider control? → Any template
   - Mouse interaction? → butterfly_art
   - Multi-control? → color_harmony_art

Remember: It's easier to remove features you don't need than to add ones you do. Start with a template that has more than you need and simplify.

## Quick Start

1. **Copy a Working Demo (Recommended)**
   - Start with a working demo that's similar to what you want to create:
     ```bash
     # Copy an existing demo as your starting point
     cp /devtest/demos/butterfly_art.dart /devtest/demos/my_new_demo.dart
     ```
   - Modify the class names and functionality
   - This ensures you have working coordinate system and structure

2. **Or Create From Template with Examples**
   ```dart
   import 'package:flutter/material.dart';
   import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
   import 'dart:math' as math;  // if needed

   class MyNewDemo extends StatefulWidget {
     const MyNewDemo({super.key});
     @override
     State<MyNewDemo> createState() => _MyNewDemoState();
   }

   class _MyNewDemoState extends State<MyNewDemo> {
     late IDiagramLayer diagramLayer;
     double _sliderValue = 0.0;
     double _scale = 1.0;

     @override
     void initState() {
       super.initState();
       diagramLayer = _createDiagramLayer();
     }

     IDiagramLayer _createDiagramLayer() {
       return BasicDiagramLayer(
         coordinateSystem: CoordinateSystem(
           origin: const Offset(400, 300),  // Center of 800x600 canvas
           xRangeMin: -400,  // Full width range
           xRangeMax: 400,
           yRangeMin: -300,  // Full height range
           yRangeMax: 300,
           scale: _scale,
         ),
         elements: _createElements(_sliderValue),
       );
     }

     List<DrawableElement> _createElements(double sliderValue) {
       final elements = <DrawableElement>[];
       
       // Example 1: Grid with proper line parameters
       for (int x = -400; x <= 400; x += 100) {
         elements.add(LineElement(
           x1: x.toDouble(),
           y1: -300,
           x2: x.toDouble(),
           y2: 300,
           color: Colors.grey.withOpacity(0.3),
           strokeWidth: 1,
         ));
       }

       // Example 2: Circle with all required parameters
       elements.add(CircleElement(
         x: 0,
         y: 0,
         radius: 100,
         color: Colors.black,
         fillColor: Colors.blue.withOpacity(0.5),
       ));

       // Example 3: Polygon with points and position
       final points = <Point2D>[
         Point2D(-50, -50),
         Point2D(50, -50),
         Point2D(0, 50),
       ];
       elements.add(PolygonElement(
         points: points,
         x: 0,
         y: 0,
         color: Colors.black,
         fillColor: Colors.red.withOpacity(0.5),
       ));

       return elements;
     }

     // ... rest of template code ...
   }
   ```

3. **Add to Menu**
   In `/devtest/main.dart`:
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
   cd devtest
   flutter run -d chrome
   ```

## Common Mistakes to Check
Before running your demo, verify:

1. **Element Parameters**
   - All elements have x/y position parameters
   - LineElement uses x1,y1,x2,y2 (not x,y,endX,endY)
   - Color parameter is 'color' (not 'strokeColor')
   - Points are Point2D objects (not raw coordinates)
   - All numeric values are doubles (not ints)

2. **Coordinate System**
   - Origin is set for 800x600 canvas (typically Offset(400, 300))
   - Range values match canvas size (-400 to 400, -300 to 300)
   - Scale parameter is included

3. **Element Creation**
   - Elements list is passed in BasicDiagramLayer constructor
   - Not trying to modify elements after layer creation
   - All required parameters are provided for each element type

4. **Common Type Issues**
   - Using .toDouble() for numeric calculations
   - Creating Point2D objects for polygon points
   - Using proper Color objects (not strings)

5. **Structure**
   - File is in correct location (/devtest/demos/)
   - All necessary imports are included
   - StatefulWidget pattern is followed

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
