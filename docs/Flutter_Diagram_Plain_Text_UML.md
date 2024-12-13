# Flutter Diagram UML (Plain Text)

## Core Components

[IDiagramLayer]<interface>
    + coordinateSystem: CoordinateSystem
    + elements: List<DrawableElement>
    + showAxes: bool
    + addElement(element: DrawableElement): IDiagramLayer
    + removeElement(element: DrawableElement): IDiagramLayer
    + toggleAxes(): IDiagramLayer
    + render(canvas: Canvas, size: Size): void

[BasicDiagramLayer]
    implements IDiagramLayer
    - _coordinateSystem: CoordinateSystem
    - _elements: List<DrawableElement>
    - _showAxes: bool
    + constructor(coordinateSystem, showAxes)
    + addElement(element): BasicDiagramLayer
    + removeElement(element): BasicDiagramLayer
    + toggleAxes(): BasicDiagramLayer
    + render(canvas, size): void

[DrawableElement]<interface>
    + render(canvas: Canvas, coordinateSystem: CoordinateSystem): void

[CoordinateSystem]
    + origin: Offset
    + xRange: (min, max)
    + yRange: (min, max)
    + scale: double
    + mapValueToDiagram(x, y): Offset
    + mapDiagramToValue(x, y): Offset

[CustomPaintRenderer]
    - layer: IDiagramLayer
    + paint(canvas, size): void

## Relationships

IDiagramLayer <|-- BasicDiagramLayer
IDiagramLayer *-- CoordinateSystem
IDiagramLayer o-- DrawableElement
CustomPaintRenderer --> IDiagramLayer

[Diagram Elements]
LineElement --|> DrawableElement
AxisElement --|> DrawableElement
SpringElement --|> DrawableElement

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

1. All diagram layer methods return new instances
2. No direct element modification allowed
3. Coordinate system handles all transformations
4. Widget state manages layer references
5. Elements are self-contained for rendering
