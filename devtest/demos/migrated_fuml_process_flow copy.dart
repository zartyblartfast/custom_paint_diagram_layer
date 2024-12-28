import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

/// Migrated version of the FUML Process Flow diagram using the new renderer architecture
class FUMLProcessFlow extends DiagramRendererBase 
    with DiagramMigrationHelper, DiagramControllerMixin {
  final String title;
  
  FUMLProcessFlow({
    super.config,
    this.title = 'Calculate Average Process Flow',
  });

  @override
  void initState() {
    try {
      // Initialize controller first
      initializeController(defaultValues: {});
      
      // Let base class initialize
      super.initState();
      
      // Validate initialization
      if (diagramLayer == null) {
        throw StateError('DiagramLayer was not initialized by DiagramRendererBase');
      }
      if (diagramLayer!.elements.isEmpty) {
        throw StateError('No elements were created during initialization');
      }
    } catch (e, stackTrace) {
      throw StateError('Failed to initialize FUMLProcessFlow: $e\n$stackTrace');
    }
  }

  @override
  CoordinateSystem createCoordinateSystem() {
    return CoordinateSystem(
      origin: Offset.zero,
      xRangeMin: -10,
      xRangeMax: 10,
      yRangeMin: -10,
      yRangeMax: 10,
      scale: 1.0,
    );
  }

  @override
  double get elementHeight => 1.0;

  @override
  List<DrawableElement> createElements() {
    try {
      print('FUMLProcessFlow.createElements: Starting element creation');
      final elements = <DrawableElement>[];
      final rectColor = Colors.lightBlue.shade100;
      final decisionColor = Colors.amber[100] ?? Colors.amber;
      final strokeColor = Colors.black87;

      // Initial Node (filled circle)
      final initialGroup = GroupElement(
        x: 0,
        y: 8,    // Socket position
        children: [
          CircleElement(
            x: 0,
            y: 0.5,  // Move circle up 0.5 units from socket
            radius: 0.2,
            color: strokeColor,
            fillColor: strokeColor,
          ),
        ],
      );
      elements.add(initialGroup);

      // Initialize Variables box
      final initGroup = GroupElement(
        x: 0,
        y: 6,    // Socket position
        children: [
          RectangleElement(
            x: -2,
            y: 0.5,  // Move rectangle up 0.5 units from socket
            width: 4,
            height: 1,
            color: strokeColor,
            fillColor: rectColor,
            borderRadius: 0.2,
          ),
          TextElement(
            x: 0,    // Center of rectangle
            y: 1.0,  // Center of rectangle
            text: 'Initialize Variables',
            color: Colors.black,
          ),
        ],
      );
      elements.add(initGroup);

      // While Loop Decision box
      final whileGroup = GroupElement(
        x: 0,
        y: 4,    // Socket position
        children: [
          RectangleElement(
            x: -1.5,
            y: 0.5,  // Move rectangle up 0.5 units from socket
            width: 3,
            height: 1,
            color: strokeColor,
            fillColor: decisionColor,
            borderRadius: 0.1,
          ),
          TextElement(
            x: 0,    // Center of rectangle
            y: 1.0,  // Center of rectangle
            text: 'i <= count?',
            color: Colors.black,
          ),
        ],
      );
      elements.add(whileGroup);

      // Sum Accumulation box
      final sumGroup = GroupElement(
        x: 0,
        y: 2,    // Socket position
        children: [
          RectangleElement(
            x: -2,
            y: 0.5,  // Move rectangle up 0.5 units from socket
            width: 4,
            height: 1,
            color: strokeColor,
            fillColor: rectColor,
            borderRadius: 0.2,
          ),
          TextElement(
            x: 0,    // Center of rectangle
            y: 1.0,  // Center of rectangle
            text: 'sum += numbers[i]',
            color: Colors.black,
          ),
        ],
      );
      elements.add(sumGroup);

      // Increment Counter box
      final incrementGroup = GroupElement(
        x: 0,
        y: 0,    // Socket position
        children: [
          RectangleElement(
            x: -2,
            y: 0.5,  // Move rectangle up 0.5 units from socket
            width: 4,
            height: 1,
            color: strokeColor,
            fillColor: rectColor,
            borderRadius: 0.2,
          ),
          TextElement(
            x: 0,    // Center of rectangle
            y: 1.0,  // Center of rectangle
            text: 'i += 1',
            color: Colors.black,
          ),
        ],
      );
      elements.add(incrementGroup);

      // Count Check Decision box
      final countCheckGroup = GroupElement(
        x: 0,
        y: -2,    // Socket position
        children: [
          RectangleElement(
            x: -1.5,
            y: 0.5,  // Move rectangle up 0.5 units from socket
            width: 3,
            height: 1,
            color: strokeColor,
            fillColor: decisionColor,
            borderRadius: 0.1,
          ),
          TextElement(
            x: 0,    // Center of rectangle
            y: 1.0,  // Center of rectangle
            text: 'count > 0?',
            color: Colors.black,
          ),
        ],
      );
      elements.add(countCheckGroup);

      // Calculate Average box
      final averageGroup = GroupElement(
        x: 0,
        y: -4,    // Socket position
        children: [
          RectangleElement(
            x: -2,
            y: 0.5,  // Move rectangle up 0.5 units from socket
            width: 4,
            height: 1,
            color: strokeColor,
            fillColor: rectColor,
            borderRadius: 0.2,
          ),
          TextElement(
            x: 0,    // Center of rectangle
            y: 1.0,  // Center of rectangle
            text: 'sum / count',
            color: Colors.black,
          ),
        ],
      );
      elements.add(averageGroup);

      // Return 0.0 box
      final returnGroup = GroupElement(
        x: 4,
        y: -4,    // Socket position
        children: [
          RectangleElement(
            x: -2,
            y: 0.5,  // Move rectangle up 0.5 units from socket
            width: 4,
            height: 1,
            color: strokeColor,
            fillColor: rectColor,
            borderRadius: 0.2,
          ),
          TextElement(
            x: 0,    // Center of rectangle
            y: 1.0,  // Center of rectangle
            text: 'return 0.0',
            color: Colors.black,
          ),
        ],
      );
      elements.add(returnGroup);

      // Final Node (double circle)
      final finalGroup = GroupElement(
        x: 0,
        y: -6,    // Socket position
        children: [
          CircleElement(
            x: 0,
            y: 0.5,  // Move circles up 0.5 units from socket
            radius: 0.3,
            color: strokeColor,
            strokeWidth: 2,
          ),
          CircleElement(
            x: 0,
            y: 0.5,  // Move circles up 0.5 units from socket
            radius: 0.2,
            color: strokeColor,
            strokeWidth: 1,
          ),
        ],
      );
      elements.add(finalGroup);

      // Add connectors using proper socket calculations
      // Initial to Initialize
      final (startInit, endInit) = ConnectorElement.calculateConnectionPoints(
        startGroup: initialGroup,
        startSocket: Socket.B,
        endGroup: initGroup,
        endSocket: Socket.T,
        coordSystem: diagramLayer?.coordinateSystem ?? createCoordinateSystem(),
      );
      elements.add(ConnectorElement(
        start: startInit,
        end: endInit,
        endEndpoint: ConnectorEndpoint.arrow,
        strokeWidth: 2.0,
        color: strokeColor,
      ));

      // Initialize to While
      final (startWhile, endWhile) = ConnectorElement.calculateConnectionPoints(
        startGroup: initGroup,
        startSocket: Socket.B,
        endGroup: whileGroup,
        endSocket: Socket.T,
        coordSystem: diagramLayer?.coordinateSystem ?? createCoordinateSystem(),
      );
      elements.add(ConnectorElement(
        start: startWhile,
        end: endWhile,
        endEndpoint: ConnectorEndpoint.arrow,
        strokeWidth: 2.0,
        color: strokeColor,
      ));

      // While to Sum
      final (startSum, endSum) = ConnectorElement.calculateConnectionPoints(
        startGroup: whileGroup,
        startSocket: Socket.B,
        endGroup: sumGroup,
        endSocket: Socket.T,
        coordSystem: diagramLayer?.coordinateSystem ?? createCoordinateSystem(),
      );
      elements.add(ConnectorElement(
        start: startSum,
        end: endSum,
        endEndpoint: ConnectorEndpoint.arrow,
        strokeWidth: 2.0,
        color: strokeColor,
      ));

      // Sum to Increment
      final (startInc, endInc) = ConnectorElement.calculateConnectionPoints(
        startGroup: sumGroup,
        startSocket: Socket.B,
        endGroup: incrementGroup,
        endSocket: Socket.T,
        coordSystem: diagramLayer?.coordinateSystem ?? createCoordinateSystem(),
      );
      elements.add(ConnectorElement(
        start: startInc,
        end: endInc,
        endEndpoint: ConnectorEndpoint.arrow,
        strokeWidth: 2.0,
        color: strokeColor,
      ));

      // Increment to Count Check
      final (startCheck, endCheck) = ConnectorElement.calculateConnectionPoints(
        startGroup: incrementGroup,
        startSocket: Socket.B,
        endGroup: countCheckGroup,
        endSocket: Socket.T,
        coordSystem: diagramLayer?.coordinateSystem ?? createCoordinateSystem(),
      );
      elements.add(ConnectorElement(
        start: startCheck,
        end: endCheck,
        endEndpoint: ConnectorEndpoint.arrow,
        strokeWidth: 2.0,
        color: strokeColor,
      ));

      // Count Check to Average
      final (startAvg, endAvg) = ConnectorElement.calculateConnectionPoints(
        startGroup: countCheckGroup,
        startSocket: Socket.B,
        endGroup: averageGroup,
        endSocket: Socket.T,
        coordSystem: diagramLayer?.coordinateSystem ?? createCoordinateSystem(),
      );
      elements.add(ConnectorElement(
        start: startAvg,
        end: endAvg,
        endEndpoint: ConnectorEndpoint.arrow,
        strokeWidth: 2.0,
        color: strokeColor,
      ));

      // Count Check to Return 0 (side connection)
      final (startRet, endRet) = ConnectorElement.calculateConnectionPoints(
        startGroup: countCheckGroup,
        startSocket: Socket.R,
        endGroup: returnGroup,
        endSocket: Socket.L,
        coordSystem: diagramLayer?.coordinateSystem ?? createCoordinateSystem(),
      );
      elements.add(ConnectorElement(
        start: startRet,
        end: endRet,
        endEndpoint: ConnectorEndpoint.arrow,
        strokeWidth: 2.0,
        color: strokeColor,
      ));

      // Average to Final
      final (startFinal1, endFinal1) = ConnectorElement.calculateConnectionPoints(
        startGroup: averageGroup,
        startSocket: Socket.B,
        endGroup: finalGroup,
        endSocket: Socket.T,
        coordSystem: diagramLayer?.coordinateSystem ?? createCoordinateSystem(),
      );
      elements.add(ConnectorElement(
        start: startFinal1,
        end: endFinal1,
        endEndpoint: ConnectorEndpoint.arrow,
        strokeWidth: 2.0,
        color: strokeColor,
      ));

      // Return 0 to Final
      final (startFinal2, endFinal2) = ConnectorElement.calculateConnectionPoints(
        startGroup: returnGroup,
        startSocket: Socket.B,
        endGroup: finalGroup,
        endSocket: Socket.T,
        coordSystem: diagramLayer?.coordinateSystem ?? createCoordinateSystem(),
      );
      elements.add(ConnectorElement(
        start: startFinal2,
        end: endFinal2,
        endEndpoint: ConnectorEndpoint.arrow,
        strokeWidth: 2.0,
        color: strokeColor,
      ));

      // Loop back connectors
      // While to vertical line
      final (startLoop1, endLoop1) = ConnectorElement.calculateConnectionPoints(
        startGroup: whileGroup,
        startSocket: Socket.R,
        endGroup: GroupElement(x: 2.5, y: 4, children: const []),
        endSocket: Socket.L,
        coordSystem: diagramLayer?.coordinateSystem ?? createCoordinateSystem(),
      );
      elements.add(ConnectorElement(
        start: startLoop1,
        end: endLoop1,
        strokeWidth: 2.0,
        color: strokeColor,
      ));

      // Vertical line
      final (startLoop2, endLoop2) = ConnectorElement.calculateConnectionPoints(
        startGroup: GroupElement(x: 2.5, y: 4, children: const []),
        startSocket: Socket.B,
        endGroup: GroupElement(x: 2.5, y: 0, children: const []),
        endSocket: Socket.T,
        coordSystem: diagramLayer?.coordinateSystem ?? createCoordinateSystem(),
      );
      elements.add(ConnectorElement(
        start: startLoop2,
        end: endLoop2,
        strokeWidth: 2.0,
        color: strokeColor,
      ));

      // Back to increment
      final (startLoop3, endLoop3) = ConnectorElement.calculateConnectionPoints(
        startGroup: GroupElement(x: 2.5, y: 0, children: const []),
        startSocket: Socket.L,
        endGroup: incrementGroup,
        endSocket: Socket.R,
        coordSystem: diagramLayer?.coordinateSystem ?? createCoordinateSystem(),
      );
      elements.add(ConnectorElement(
        start: startLoop3,
        end: endLoop3,
        endEndpoint: ConnectorEndpoint.arrow,
        strokeWidth: 2.0,
        color: strokeColor,
      ));

      // Add "Yes"/"No" labels
      elements.add(TextElement(
        x: -0.5,
        y: 3.2,
        text: 'Yes',
        color: Colors.black,
      ));
      elements.add(TextElement(
        x: 2.0,
        y: -1.5,
        text: 'No',
        color: Colors.black,
      ));
      elements.add(TextElement(
        x: -0.5,
        y: -3.0,
        text: 'Yes',
        color: Colors.black,
      ));
      print('FUMLProcessFlow.createElements: Created ${elements.length} elements');
      return elements;
    } catch (e, stackTrace) {
      print('Error in FUMLProcessFlow.createElements: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  void updateFromController() {
    try {
      // Validate state before update
      if (diagramLayer == null) {
        throw StateError('Cannot update from controller: DiagramLayer is null');
      }
      updateElements();
    } catch (e, stackTrace) {
      throw StateError('Failed to update from controller: $e\n$stackTrace'); 
    }
  }

  @override
  DiagramRendererBase updateConfig(DiagramConfig newConfig) {
    return FUMLProcessFlow(
      config: newConfig,
      title: title,
    );
  }
}

/// Widget that demonstrates both standalone and embedded usage
class FUMLProcessFlowDemo extends StatefulWidget {
  final bool useStandalone;
  final bool showControls;
  
  const FUMLProcessFlowDemo({
    super.key,
    this.useStandalone = true,
    this.showControls = true,
  });

  @override
  State<FUMLProcessFlowDemo> createState() => _FUMLProcessFlowDemoState();
}

class _FUMLProcessFlowDemoState extends State<FUMLProcessFlowDemo> {
  late final FUMLProcessFlow diagram;
  String? error;

  @override
  void initState() {
    try {
      super.initState();
      diagram = FUMLProcessFlow(
        config: const DiagramConfig(
          width: 600,
          height: 600,
          showGrid: true,
          showAxes: true,
        ),
      );
      diagram.initState();
    } catch (e, stackTrace) {
      error = 'Initialization Error: $e\n$stackTrace';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // If we have an error, show it
    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(error!, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    // Normal rendering path
    return Builder(
      builder: (context) {
        try {
          if (widget.useStandalone) {
            return Scaffold(
              appBar: AppBar(
                title: Text(diagram.title),
              ),
              body: Center(
                child: ErrorBoundary(
                  child: diagram.wrapForWeb(context),
                  onError: (error, stack) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Error Rendering Diagram',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        const SizedBox(height: 16),
                        Text(error.toString()),
                        const SizedBox(height: 8),
                        Text(stack.toString()),
                      ],
                    );
                  },
                ),
              ),
            );
          } else {
            return ErrorBoundary(
              child: diagram.wrapForWeb(context),
              onError: (error, stack) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Error Rendering Diagram',
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    Text(error.toString()),
                    const SizedBox(height: 8),
                    Text(stack.toString()),
                  ],
                );
              },
            );
          }
        } catch (e, stack) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Error Building Widget',
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
              const SizedBox(height: 16),
              Text(e.toString()),
              const SizedBox(height: 8),
              Text(stack.toString()),
            ],
          );
        }
      },
    );
  }
}

/// Custom error boundary widget
class ErrorBoundary extends StatelessWidget {
  final Widget child;
  final Widget Function(Object error, StackTrace stackTrace) onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      if (context.mounted) {
        onError(details.exception, details.stack ?? StackTrace.current);
      }
    };
    return child;
  }
}

/// Entry point for standalone demo
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FUMLProcessFlowDemo(useStandalone: true),  // Add useStandalone
    ),
  );
}
