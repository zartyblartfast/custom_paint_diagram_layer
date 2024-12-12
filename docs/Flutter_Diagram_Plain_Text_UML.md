# Plain Text UML Design

## Class Definitions

### CoordinateSystem
**Responsibility:** Handles coordinate transformations with proper centering, scaling, and origin placement. Ensures consistent coordinate space mapping between app values and diagram space.
#### Properties:
- `origin: Offset` – Defines the origin point for coordinate transformations
- `xRangeMin: double`, `xRangeMax: double` – Range of values on the x-axis
- `yRangeMin: double`, `yRangeMax: double` – Range of values on the y-axis
- `scale: double` – Unified scaling factor for both axes
#### Methods:
- `mapValueToDiagram(x: double, y: double): Offset` – Maps app values to diagram coordinates with proper centering
- `mapDiagramToValue(x: double, y: double): Offset` – Maps diagram coordinates back to app values
- `copyWith({...}): CoordinateSystem` – Creates a new instance with updated properties

### CanvasAlignment
**Responsibility:** Manages the relationship between canvas dimensions and coordinate system, ensuring proper centering and scaling.
#### Properties:
- `canvasSize: Size` – Dimensions of the canvas
- `coordinateSystem: CoordinateSystem` – The coordinate system to align
#### Methods:
- `alignCenter(): void` – Centers the coordinate system and updates scale atomically
- `alignBottomCenter(): void` – Aligns to bottom center and updates scale atomically

### DrawableElement (Abstract Class)
**Responsibility:** Base class for all drawable elements, ensuring consistent rendering behavior.
#### Properties:
- `x: double` – The x-coordinate of the element
- `y: double` – The y-coordinate of the element
- `color: Color` – The color of the element
#### Methods:
- `render(canvas: Canvas, coordinateSystem: CoordinateSystem): void` – Renders the element using transformed coordinates

### XAxisElement (extends DrawableElement)
**Responsibility:** Renders the X-axis with proper positioning and tick marks.
#### Properties:
- `yValue: double` – The Y-coordinate of the axis
- `tickInterval: double` – The interval between tick marks
#### Methods:
- Inherits render from DrawableElement
- `drawTick(canvas: Canvas, position: Offset, paint: Paint): void` – Draws individual tick marks
- `drawLabel(canvas: Canvas, position: Offset, text: String, style: TextStyle): void` – Draws tick labels

### YAxisElement (extends DrawableElement)
**Responsibility:** Renders the Y-axis with proper positioning and tick marks.
#### Properties:
- `xValue: double` – The X-coordinate of the axis
- `tickInterval: double` – The interval between tick marks
#### Methods:
- Inherits render from DrawableElement
- `drawTick(canvas: Canvas, position: Offset, paint: Paint): void` – Draws individual tick marks
- `drawLabel(canvas: Canvas, position: Offset, text: String, style: TextStyle): void` – Draws tick labels

### Diagram
**Responsibility:** Manages drawable elements and coordinates rendering operations.
#### Properties:
- `elements: List<DrawableElement>` – Collection of elements in the diagram
- `coordinateSystem: CoordinateSystem` – The coordinate system for transformations
- `showAxes: bool` – Controls axis visibility
#### Methods:
- `render(canvas: Canvas, size: Size): void` – Orchestrates rendering using aligned coordinate system
- `addElement(element: DrawableElement): Diagram` – Adds an element immutably
- `removeElement(element: DrawableElement): Diagram` – Removes an element immutably
- `toggleAxes(): Diagram` – Toggles axis visibility immutably
- `addAxesToDiagram(): Diagram` – Adds axis elements if showAxes is true

### CustomPaintRenderer
**Responsibility:** Bridges Flutter's CustomPaint with the diagram layer.
#### Properties:
- `diagram: Diagram` – The diagram to render
#### Methods:
- `paint(canvas: Canvas, size: Size): void` – Delegates rendering to diagram
- `shouldRepaint(oldDelegate: CustomPainter): bool` – Determines repaint necessity

## Relationships

### Inheritance
- `DrawableElement` is the abstract base class for all drawable elements

### Composition
- `Diagram` contains immutable collection of `DrawableElement` instances
- `Diagram` uses `CoordinateSystem` for transformations
- `CanvasAlignment` manages `CoordinateSystem` state

### Dependencies
1. `CoordinateSystem`: Base class with no dependencies
2. `DrawableElement`: Depends on `CoordinateSystem`
3. `CanvasAlignment`: Depends on `CoordinateSystem`
4. `Diagram`: Depends on `DrawableElement`, `CoordinateSystem`, and `CanvasAlignment`
5. `CustomPaintRenderer`: Depends on `Diagram`
