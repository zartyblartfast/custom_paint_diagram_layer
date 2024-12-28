import 'package:flutter/material.dart';
import '../state/state_managed_diagram_base.dart';

/// A utility class to handle the common BuildContext patterns for diagrams
class DiagramWidgetBuilder {
  final StateManagedDiagramBase diagram;
  final bool standalone;
  final String? title;
  final Widget? controls;
  final double? width;
  final double? height;

  const DiagramWidgetBuilder({
    required this.diagram,
    this.standalone = true,
    this.title,
    this.controls,
    this.width,
    this.height,
  });

  Widget build(BuildContext context) {
    final diagramWidget = width != null && height != null
        ? SizedBox(
            width: width,
            height: height,
            child: diagram.buildDiagramWidget(context),
          )
        : diagram.buildDiagramWidget(context);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (standalone && title != null) ...[
          Text(
            title!,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
        ],
        standalone ? Expanded(child: diagramWidget) : diagramWidget,
        if (controls != null) ...[
          const SizedBox(height: 20),
          controls!,
        ],
      ],
    );

    if (standalone) {
      return Scaffold(
        body: Center(
          child: content,
        ),
      );
    }

    return content;
  }
}
