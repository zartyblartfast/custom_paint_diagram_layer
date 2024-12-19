# Flutter Diagram UML (Plain Text)

## Core Components

[IDiagramLayer]<interface>
    + coordinateSystem: CoordinateSystem
    + elements: List<DrawableElement>
    + addElement(element: DrawableElement): IDiagramLayer
    + removeElement(element: DrawableElement): IDiagramLayer
    + updateDiagram(elementUpdates, removeElements, newCoordinateSystem): IDiagramLayer
    + render(canvas: Canvas, size: Size): void

[BasicDiagramLayer]
    implements IDiagramLayer
    - _coordinateSystem: CoordinateSystem
    - _elements: List<DrawableElement>
    + constructor(coordinateSystem)
    + addElement(element): BasicDiagramLayer
    + removeElement(element): BasicDiagramLayer
    + render(canvas, size): void
    - _addAxesToDiagram(): IDiagramLayer
    - _removeAxes(): IDiagramLayer

[DrawableElement]<interface>
    + render(canvas: Canvas, coordinateSystem: CoordinateSystem): void

[CoordinateSystem]
    + origin: Offset
    + xRangeMin: double
    + xRangeMax: double
    + yRangeMin: double
    + yRangeMax: double
    + scale: double
    + mapValueToDiagram(x, y): Offset
    + copyWith(origin?, scale?): CoordinateSystem

[CanvasAlignment]
    - canvasSize: Size
    - coordinateSystem: CoordinateSystem
    + alignCenter(): void
    + alignBottomCenter(): void
    + updateScale(): void

[CustomPaintRenderer]
    - layer: IDiagramLayer
    + paint(canvas, size): void

## Element Hierarchy

[DrawableElement]<interface>
    |
    +-- [ShapeElements]
    |    |-- CircleElement
    |    |-- RectangleElement
    |    |-- EllipseElement
    |    |-- LineElement
    |    |-- PolygonElement
    |    |-- ParallelogramElement
    |    |-- IsoscelesTriangleElement
    |    |-- RightTriangleElement
    |    |-- StarElement
    |    |-- ArcElement
    |    |-- BezierCurveElement
    |    `-- DottedLineElement
    |
    +-- [CompositeElements]
    |    |-- GroupElement
    |    `-- ImageElement
    |
    +-- [TextElements]
    |    `-- TextElement

## Utility Classes

[ElementBounds]
    + element: DrawableElement
    + coordinateSystem: CoordinateSystem
    + getBounds(): Rect
    + isOutsideDiagramBounds(): bool

[CoordinateMapper]
    + coordSystem: CoordinateSystem
    + mapSliderToPosition(sliderValue, isXAxis): double
    + mapSliderToSafePosition(sliderValue, isXAxis, currentGroup): double

## Relationships

IDiagramLayer <|-- BasicDiagramLayer
IDiagramLayer *-- CoordinateSystem
IDiagramLayer o-- DrawableElement
CustomPaintRenderer --> IDiagramLayer
CanvasAlignment --> CoordinateSystem
ElementBounds --> DrawableElement
ElementBounds --> CoordinateSystem
CoordinateMapper --> CoordinateSystem

## State Flow

[Widget State]
    |
    v
[IDiagramLayer] ---> [New IDiagramLayer]
    |                      |
    |                      |
    v                      v
[Elements] -----> [New Elements]

## Implementation Notes

1. All diagram layer methods return new instances (immutable)
2. Coordinate system handles all transformations
3. Elements are self-contained for rendering
4. Canvas alignment manages scaling and positioning
5. Group elements support nested transformations
6. Elements support fill and stroke styles
7. Utility classes help with bounds checking and coordinate mapping
