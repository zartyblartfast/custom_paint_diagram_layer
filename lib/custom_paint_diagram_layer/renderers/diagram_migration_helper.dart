import 'package:flutter/material.dart';
import 'diagram_renderer_base.dart';

/// Mixin to help migrate existing diagrams to the new architecture.
/// 
/// Provides helper methods to maintain compatibility with existing
/// diagram implementations while transitioning to the new renderer-based
/// approach.
mixin DiagramMigrationHelper on DiagramRendererBase {
  /// Helper for diagrams that use slider-based updates
  void updateFromSlider(double value) {
    // Default implementation just triggers element update
    // Override in specific diagrams to handle slider values
    updateElements();
  }

  /// Wraps the diagram in a standard test widget layout
  /// 
  /// This helps maintain visual consistency with existing demos
  /// during the migration period.
  Widget wrapInTestWidget(BuildContext context, String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          width: config.width,
          height: config.height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: buildDiagramWidget(context),
        ),
      ),
    );
  }

  /// Wraps the diagram in a container suitable for web embedding
  /// 
  /// This provides a clean container for web integration while
  /// maintaining consistent styling.
  Widget wrapForWeb(BuildContext context) {
    return Container(
      width: config.width,
      height: config.height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        color: Colors.white,
      ),
      child: buildDiagramWidget(context),
    );
  }

  /// Updates multiple properties at once
  /// 
  /// Useful for diagrams that need to handle multiple
  /// interactive controls simultaneously.
  void updateProperties(Map<String, dynamic> properties) {
    // Default implementation just updates elements
    // Override in specific diagrams to handle property updates
    updateElements();
  }

  /// Helper for diagrams that use position-based updates
  void updatePosition(double x, double y) {
    // Default implementation just triggers update
    // Override in specific diagrams to handle position updates
    updateElements();
  }
}
