# Updated Development Roadmap

## Phase 1: Core Components
**Goal:** Build and validate foundational classes for coordinate transformations and drawable elements.

### 1. CoordinateSystem
**Purpose:** Handles all coordinate transformations, scaling, and origin placement.

**Steps:**
1. Define properties:
   - `origin: Offset`
   - `xRangeMin: double`, `xRangeMax: double`
   - `yRangeMin: double`, `yRangeMax: double`
   - `scale: double`

2. Implement methods:
   - `mapValueToDiagram(x: double, y: double): Offset`
   - `mapDiagramToValue(x: double, y: double): Offset`

3. Write unit tests to validate:
   - Correct mapping of app values to diagram coordinates
   - Handling of edge cases (e.g., negative scales, shifted origins)

**Expected Output:** A functional CoordinateSystem class with accurate transformation methods.  
**Dependencies:** None

### 2. DrawableElement (Abstract Class)
**Purpose:** Represents a drawable element in the diagram.

**Steps:**
1. Define abstract properties:
   - `x: double`, `y: double`, `color: Color`

2. Define an abstract method:
   - `render(canvas: Canvas, coordinateSystem: CoordinateSystem): void`

3. Write a test stub to ensure all subclasses implement the render method

**Expected Output:** A base class that standardizes drawable elements.  
**Dependencies:** `CoordinateSystem`

### 3. Display Coordinate System and Scale
**Purpose:** Add a visual representation of the coordinate system to validate layout and scaling early.

**Steps:**
1. Extend the Diagram class:
   - Add `showAxes` property to toggle axes visibility
   - Implement `_renderAxes` method for axes and scale markings
   - Update CustomPaintRenderer to include axes rendering

2. Create a simple test diagram:
   - Configure a Diagram with a CoordinateSystem
   - Display axes and scale markings

3. Write tests to validate:
   - Correct alignment of axes with coordinate system
   - Accuracy of scale markings

**Expected Output:** A diagram with visible axes and scale markings for early verification.  
**Dependencies:** `CoordinateSystem`

### 4. LineElement
**Purpose:** Represents a line in the diagram.

**Steps:**
1. Define properties:
   - `x1: double`, `y1: double` (start point)
   - `x2: double`, `y2: double` (end point)

2. Implement the render method using:
   - The `Canvas.drawLine` method
   - Coordinate transformations via CoordinateSystem

3. Write tests to validate:
   - Correct rendering at various positions and scales

**Expected Output:** A LineElement class that accurately renders lines.  
**Dependencies:** `DrawableElement`, `CoordinateSystem`

### 5. RectangleElement
**Purpose:** Represents a rectangle in the diagram.

**Steps:**
1. Define properties:
   - `x: double`, `y: double` (top-left corner)
   - `width: double`, `height: double` (dimensions)

2. Implement the render method using:
   - The `Canvas.drawRect` method
   - Coordinate transformations via CoordinateSystem

3. Write tests to validate:
   - Correct position and dimensions under various configurations

**Expected Output:** A RectangleElement class that renders rectangles properly.  
**Dependencies:** `DrawableElement`, `CoordinateSystem`

### 6. TextElement
**Purpose:** Represents a text label in the diagram.

**Steps:**
1. Define properties:
   - `x: double`, `y: double` (position)
   - `text: String` (content)

2. Implement the render method using:
   - The `Canvas.drawText` method
   - Coordinate transformations via CoordinateSystem

3. Write tests to validate:
   - Proper alignment and rendering of text

**Expected Output:** A TextElement class for rendering text labels.  
**Dependencies:** `DrawableElement`, `CoordinateSystem`

## Phase 2: Diagram and Rendering
**Goal:** Combine elements into a managed collection and render them.

### 7. Diagram
**Purpose:** Manages a collection of elements and interacts with the coordinate system.

**Steps:**
1. Define properties:
   - `elements: List<DrawableElement>`
   - `coordinateSystem: CoordinateSystem`
   - `showAxes: bool`

2. Implement methods:
   - `addElement(element: DrawableElement): void`
   - `removeElement(element: DrawableElement): void`
   - `toggleAxes(): void`

3. Write tests to validate:
   - Adding/removing elements dynamically
   - Correctly toggling axes visibility

**Expected Output:** A Diagram class that manages elements and supports debugging tools.  
**Dependencies:** `DrawableElement`, `CoordinateSystem`

### 8. CustomPaintRenderer
**Purpose:** Renders the diagram using Flutter's CustomPaint.

**Steps:**
1. Implement the render method:
   - Iterate through DrawableElement instances
   - Call render for each element with Canvas and CoordinateSystem

2. Include debugging tools:
   - Draw axes and gridlines when showAxes is true

3. Write tests to validate:
   - Integration with the Diagram class
   - Correct rendering of elements and debugging tools

**Expected Output:** A CustomPaintRenderer class that renders the diagram.  
**Dependencies:** `Diagram`, `DrawableElement`

## Phase 3: Debugging Features
**Goal:** Add visual debugging tools to verify coordinate systems and element placement.

### Known Issues to Address in Phase 3

### Coordinate System and Axes Alignment
1. **X-Axis Horizontal Centering**
   - Current Issue: X-axis appears off-center to the right of the diagram
   - Root Cause: Direct canvas drawing bypassing proper coordinate system transformations
   - To Fix: Implement proper drawable elements for axes using the diagram layer abstractions

2. **Axis Rendering Implementation**
   - Current Issue: Axes are drawn directly using canvas commands instead of using drawable elements
   - Impact: Bypasses the diagram layer's coordinate system abstractions
   - To Fix: Create dedicated drawable elements for axes, ticks, and labels

3. **Debug Validation**
   - Need visual tools to verify:
     - Origin point placement (canvas.width/2, canvas.height)
     - X-axis horizontal alignment
     - Y-axis vertical alignment from origin
     - Scale accuracy at different canvas dimensions

These issues will be addressed systematically in Phase 3's "Axes and Gridlines" implementation.

### 9. Axes and Gridlines
**Purpose:** Provide visual confirmation of coordinate system and element alignment.

**Steps:**
1. Extend the Diagram class:
   - Add toggles for axes and gridlines

2. Implement rendering logic:
   - Draw X and Y axes based on CoordinateSystem
   - Add optional gridlines at defined intervals

3. Write tests to validate:
   - Axes and gridlines appear correctly

**Expected Output:** Debugging tools integrated into the diagram.  
**Dependencies:** `Diagram`, `CustomPaintRenderer`

## Phase 4: Testing and Edge Cases
**Goal:** Ensure robustness and correctness.

### 10. Unit Tests
**Purpose:** Validate each class in isolation.

**Steps:**
1. Write tests for:
   - CoordinateSystem: Edge case mapping
   - DrawableElement subclasses: Rendering behavior
   - Diagram: Element management and features

**Expected Output:** Unit-tested core components with reliable behavior.

### 11. Integration Tests
**Purpose:** Test class interactions.

**Steps:**
1. Create sample diagram with multiple elements
2. Render using CustomPaintRenderer
3. Validate rendering and debugging tools

**Expected Output:** A fully functional and tested diagram system.

### 12. Edge Cases
**Purpose:** Ensure robustness with unusual configurations.

**Steps:**
1. Test with:
   - Negative axis ranges
   - Extreme scales
   - Invalid properties

2. Validate error handling and documentation

**Expected Output:** A robust framework handling edge cases gracefully.