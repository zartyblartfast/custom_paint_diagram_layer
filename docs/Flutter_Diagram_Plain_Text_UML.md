# Plain Text UML Design

## Class Definitions

### CoordinateSystem
**Responsibility:** Handles coordinate transformations, scaling, and origin placement.
#### Properties:
- `origin: Offset` – Defines the origin of the coordinate system
- `xRangeMin: double`, `xRangeMax: double` – Range of values on the x-axis
- `yRangeMin: double`, `yRangeMax: double` – Range of values on the y-axis
- `scale: double` – Scaling factor for the coordinate system
#### Methods:
- `mapValueToDiagram(x: double, y: double): Offset` – Maps app values to diagram coordinates
- `mapDiagramToValue(x: double, y: double): Offset` – Maps diagram coordinates back to app values

### DrawableElement (Abstract Class)
**Responsibility:** Represents a drawable element in the diagram.
#### Properties:
- `x: double` – The x-coordinate of the element
- `y: double` – The y-coordinate of the element
- `color: Color` – The color of the element
#### Methods:
- `render(canvas: Canvas, coordinateSystem: CoordinateSystem): void` – Draws the element using the Canvas API and the coordinate system

### LineElement (extends DrawableElement)
**Responsibility:** Represents a line in the diagram.
#### Properties:
- `x1: double`, `y1: double` – Start point of the line
- `x2: double`, `y2: double` – End point of the line
#### Methods:
- Inherits all methods from DrawableElement

### RectangleElement (extends DrawableElement)
**Responsibility:** Represents a rectangle in the diagram.
#### Properties:
- `x: double`, `y: double` – Top-left corner of the rectangle
- `width: double`, `height: double` – Dimensions of the rectangle
#### Methods:
- Inherits all methods from DrawableElement

### TextElement (extends DrawableElement)
**Responsibility:** Represents a text label in the diagram.
#### Properties:
- `x: double`, `y: double` – Position of the text
- `text: String` – The content of the text
#### Methods:
- Inherits all methods from DrawableElement

### Diagram
**Responsibility:** Manages a collection of drawable elements and interacts with the coordinate system.
#### Properties:
- `elements: List<DrawableElement>` – Collection of elements in the diagram
- `coordinateSystem: CoordinateSystem` – The coordinate system used for this diagram
- `showAxes: bool` – Whether to display debugging axes
#### Methods:
- `addElement(element: DrawableElement): void` – Adds an element to the diagram
- `removeElement(element: DrawableElement): void` – Removes an element from the diagram
- `toggleAxes(): void` – Toggles the visibility of debugging axes

### CustomPaintRenderer
**Responsibility:** Renders the diagram using Flutter's CustomPaint.
#### Methods:
- `render(canvas: Canvas, diagram: Diagram): void` – Iterates through elements in the diagram and calls their render methods

## Relationships

### Inheritance
- `DrawableElement` is the abstract base class for:
  - `LineElement`
  - `RectangleElement`
  - `TextElement`

### Composition
- `Diagram` contains a collection of `DrawableElement` instances
- `Diagram` uses `CoordinateSystem` to manage transformations

### Dependencies
- `CustomPaintRenderer` depends on `Diagram` for rendering
- All `DrawableElement` subclasses depend on `CoordinateSystem` for mapping coordinates

## Dependency Hierarchy
1. `CoordinateSystem`: Base class with no dependencies
2. `DrawableElement`: Depends on `CoordinateSystem`
3. `Diagram`: Depends on `DrawableElement` and `CoordinateSystem`
4. `CustomPaintRenderer`: Depends on `Diagram`
