import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import '../utils/static_diagram_base.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/bezier_curve_element.dart' show Point;
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/connector_element.dart';

class ProcessFlowDiagram extends StaticDiagramBase {
  const ProcessFlowDiagram({super.key}) : super(
    title: 'Process Flow Diagram',
    coordRange: 10.0,
  );

  @override
  StaticDiagramBaseState<ProcessFlowDiagram> createState() => _ProcessFlowDiagramState();
}

class _ProcessFlowDiagramState extends StaticDiagramBaseState<ProcessFlowDiagram> {
  @override
  double get elementHeight => 1.0;

  @override
  CoordinateSystem createCoordinateSystem() {
    return CoordinateSystem(
      origin: Offset.zero,
      xRangeMin: -6,
      xRangeMax: 6,
      yRangeMin: -6,
      yRangeMax: 8,
      scale: 1.0,
    );
  }

  @override
  List<DrawableElement> createElements() {
    final elements = <DrawableElement>[];
    final rectColor = Colors.lightBlue.shade100;
    final strokeColor = Colors.black87;

    // Create RStart rectangle with label
    final rStartGroup = GroupElement(
      x: -2,  // Same X as R0
      y: 6,   // Above R0
      children: [
        RectangleElement(
          x: -1,
          y: 0.5,  // Move rectangle up 0.5 units from socket
          width: 2,
          height: 1,
          color: strokeColor,
          fillColor: rectColor,
          borderRadius: 0.2,
        ),
        TextElement(
          x: 0,    // Center of rectangle
          y: 1.0,  // Center of rectangle
          text: 'RStart',
          color: Colors.black,
        ),
      ],
    );
    elements.add(rStartGroup);

    // Create R0 rectangle with label
    final r0Group = GroupElement(
      x: -2,  // Same X as R1
      y: 2,   // Above R1
      children: [
        RectangleElement(
          x: -1,
          y: 0.5,  // Move rectangle up 0.5 units from socket
          width: 2,
          height: 1,
          color: strokeColor,
          fillColor: rectColor,
          borderRadius: 0.2,
        ),
        TextElement(
          x: 0,    // Center of rectangle
          y: 1.0,  // Center of rectangle
          text: 'R0',
          color: Colors.black,
        ),
      ],
    );
    elements.add(r0Group);

    // Add vertical connector from RStart to R0
    final (startVerticalTop, endVerticalTop) = ConnectorElement.calculateConnectionPoints(
      startGroup: rStartGroup,
      startSocket: Socket.B,
      endGroup: r0Group,
      endSocket: Socket.T,
      coordSystem: diagramLayer.coordinateSystem,
    );
    final verticalConnectorTop = ConnectorElement(
      start: startVerticalTop,
      end: endVerticalTop,
      endEndpoint: ConnectorEndpoint.arrow,
      strokeWidth: 2.0,
      color: strokeColor,
    );
    elements.add(verticalConnectorTop);

    // Create R1 rectangle with label
    final r1Group = GroupElement(
      x: -2,  // Center X (rectangle extends from -3 to -1)
      y: -2,  // Put group where we want the socket
      children: [
        RectangleElement(
          x: -1,
          y: 0.5,  // Move rectangle up 0.5 units from socket
          width: 2,
          height: 1,
          color: strokeColor,
          fillColor: rectColor,
          borderRadius: 0.2,
        ),
        TextElement(
          x: 0,    // Center of rectangle (x = -1 + width/2)
          y: 1.0,  // Center of rectangle (y = 0.5 + height/2)
          text: 'R1',
          color: Colors.black,
        ),
      ],
    );
    elements.add(r1Group);

    // Add vertical connector from R0 to R1
    final (startVertical, endVertical) = ConnectorElement.calculateConnectionPoints(
      startGroup: r0Group,
      startSocket: Socket.B,
      endGroup: r1Group,
      endSocket: Socket.T,
      coordSystem: diagramLayer.coordinateSystem,
    );
    final verticalConnector = ConnectorElement(
      start: startVertical,
      end: endVertical,
      endEndpoint: ConnectorEndpoint.arrow,
      strokeWidth: 2.0,
      color: strokeColor,
    );
    elements.add(verticalConnector);

    // Create R2 rectangle with label
    final r2Group = GroupElement(
      x: 2,   // Center X (rectangle extends from 1 to 3)
      y: -2,  // Put group where we want the socket
      children: [
        RectangleElement(
          x: -1,
          y: 0.5,  // Move rectangle up 0.5 units from socket
          width: 2,
          height: 1,
          color: strokeColor,
          fillColor: rectColor,
          borderRadius: 0.2,
        ),
        TextElement(
          x: 0,    // Center of rectangle (x = -1 + width/2)
          y: 1.0,  // Center of rectangle (y = 0.5 + height/2)
          text: 'R2',
          color: Colors.black,
        ),
      ],
    );
    elements.add(r2Group);

    // Add connector from R1's right side to R2's left side
    final (start, end) = ConnectorElement.calculateConnectionPoints(
      startGroup: r1Group,
      startSocket: Socket.R,
      endGroup: r2Group,
      endSocket: Socket.L,
      coordSystem: diagramLayer.coordinateSystem,
    );
    final connector = ConnectorElement(
      start: start,
      end: end,
      endEndpoint: ConnectorEndpoint.arrow,
      strokeWidth: 2.0,
      color: strokeColor,
    );
    elements.add(connector);

    return elements;
  }
}
