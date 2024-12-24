# Flutter Diagram UML (Plain Text)

## Core Components

[DiagramRendererBase]<abstract>
    + config: DiagramConfig
    + controller: DiagramController
    + createCoordinateSystem(): CoordinateSystem
    + createElements(): List<DrawableElement>
    + updateElements(): void
    + buildDiagramWidget(context): Widget
    + updateConfig(newConfig): DiagramRendererBase

[DiagramController]
    - _values: Map<String, dynamic>
    + getValue<T>(key): T?
    + setValue(key, value): void
    + setValues(Map<String, dynamic>): void
    + onValuesChanged: Function?

[DiagramControllerMixin]
    + controller: DiagramController
    + initializeController(defaultValues, onValuesChanged): void
    + updateFromController(): void

[DiagramMigrationHelper]<mixin>
    + updateFromSlider(value): void

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

[DiagramConfig]
    + width: double
    + height: double
    + backgroundColor: Color
    + showAxes: bool
    + copyWith(): DiagramConfig

## Integration Components

[ButterflyArtDemo]<widget>
    + useStandalone: bool
    + showControls: bool
    + createState(): State

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
    |    |-- BezierCurveElement
    |    `-- [Other Shape Elements...]
    |
    +-- [CompositeElements]
    |    |-- GroupElement
    |    `-- ImageElement
    |
    +-- [TextElements]
    |    `-- TextElement

## Integration Patterns

[StandalonePattern]
    MaterialApp
        |-- ButterflyArtDemo(useStandalone: true)
            |-- DiagramRenderer
                |-- CustomPaintRenderer
                    |-- IDiagramLayer

[EmbeddedPattern]
    MaterialApp
        |-- Scaffold
            |-- AppBar
            |-- ButterflyArtDemo(useStandalone: false)
                |-- DiagramRenderer
                    |-- CustomPaintRenderer
                        |-- IDiagramLayer
                |-- Controls

## Relationships

DiagramRendererBase <|-- SpecificDiagramImplementation
DiagramRendererBase o-- DiagramController
DiagramRendererBase o-- IDiagramLayer
DiagramRendererBase o-- DiagramConfig

DiagramRendererBase <|-- DiagramControllerMixin
DiagramRendererBase <|-- DiagramMigrationHelper

IDiagramLayer <|-- BasicDiagramLayer
IDiagramLayer *-- CoordinateSystem
IDiagramLayer o-- DrawableElement

CustomPaintRenderer --> IDiagramLayer

## State Flow

[User Interaction]
    |
    v
[DiagramController]
    |
    v
[DiagramRendererBase]
    |
    v
[IDiagramLayer]
    |
    v
[DrawableElements]
    |
    v
[Canvas Rendering]
