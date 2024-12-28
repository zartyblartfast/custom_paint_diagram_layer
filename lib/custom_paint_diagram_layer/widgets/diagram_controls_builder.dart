import 'package:flutter/material.dart';
import '../state/state_managed_diagram_base.dart';

/// Style configuration for diagram controls
class DiagramControlsStyle {
  final TextStyle? stateChangeTextStyle;
  final TextStyle? labelTextStyle;
  final TextStyle? valueTextStyle;
  final ButtonStyle? toggleButtonStyle;
  final SliderThemeData? sliderTheme;
  final EdgeInsets? padding;
  final double spacing;
  final MainAxisAlignment controlsAlignment;
  final CrossAxisAlignment crossAlignment;
  final Widget? divider;

  const DiagramControlsStyle({
    this.stateChangeTextStyle = const TextStyle(fontStyle: FontStyle.italic),
    this.labelTextStyle,
    this.valueTextStyle,
    this.toggleButtonStyle,
    this.sliderTheme,
    this.padding,
    this.spacing = 8.0,
    this.controlsAlignment = MainAxisAlignment.center,
    this.crossAlignment = CrossAxisAlignment.center,
    this.divider,
  });
}

/// Layout configuration for controls
class DiagramControlsLayout {
  final Axis direction;
  final bool wrapControls;
  final WrapAlignment? wrapAlignment;
  final double? wrapSpacing;
  final Widget Function(List<Widget>)? customLayout;

  const DiagramControlsLayout({
    this.direction = Axis.vertical,
    this.wrapControls = false,
    this.wrapAlignment,
    this.wrapSpacing,
    this.customLayout,
  });

  Widget build(List<Widget> children) {
    if (customLayout != null) {
      return customLayout!(children);
    }

    if (wrapControls) {
      return Wrap(
        direction: direction,
        alignment: wrapAlignment ?? WrapAlignment.start,
        spacing: wrapSpacing ?? 8.0,
        runSpacing: wrapSpacing ?? 8.0,
        children: children,
      );
    }

    return direction == Axis.vertical
        ? Column(children: children)
        : Row(children: children);
  }
}

/// A utility class to build standard diagram controls with customizable layout and styling
class DiagramControlsBuilder {
  final StateManagedDiagramBase diagram;
  final String? stateChangeText;
  final Map<String, ValueChanged<double>>? sliderControls;
  final List<VisibilityToggle>? visibilityToggles;
  final List<Widget>? extraControls;
  final DiagramControlsStyle style;
  final DiagramControlsLayout layout;
  final Widget Function(BuildContext, Widget)? controlWrapper;

  const DiagramControlsBuilder({
    required this.diagram,
    this.stateChangeText,
    this.sliderControls,
    this.visibilityToggles,
    this.extraControls,
    this.style = const DiagramControlsStyle(),
    this.layout = const DiagramControlsLayout(),
    this.controlWrapper,
  });

  Widget build(BuildContext context) {
    final children = <Widget>[];

    // Add state change text if provided
    if (stateChangeText != null) {
      children.add(
        Padding(
          padding: style.padding ?? EdgeInsets.zero,
          child: Text(
            stateChangeText!,
            style: style.stateChangeTextStyle,
          ),
        ),
      );
      if (style.divider != null) children.add(style.divider!);
    }

    // Add slider controls
    if (sliderControls != null) {
      for (final entry in sliderControls!.entries) {
        children.add(_buildSliderControl(context, entry.key, entry.value));
        if (style.divider != null && entry != sliderControls!.entries.last) {
          children.add(style.divider!);
        }
      }
    }

    // Add visibility toggles
    if (visibilityToggles != null && visibilityToggles!.isNotEmpty) {
      children.add(_buildVisibilityToggles(context));
    }

    // Add extra controls
    if (extraControls != null) {
      children.addAll(extraControls!);
    }

    // Apply wrapper if provided
    if (controlWrapper != null) {
      return controlWrapper!(context, layout.build(children));
    }

    return layout.build(children);
  }

  Widget _buildSliderControl(BuildContext context, String label, ValueChanged<double> onChanged) {
    final slider = SliderTheme(
      data: style.sliderTheme ?? SliderTheme.of(context),
      child: Slider(
        value: diagram.state.getValue(label) ?? 0.5,
        onChanged: onChanged,
      ),
    );

    final row = Row(
      children: [
        Text(
          '$label:',
          style: style.labelTextStyle,
        ),
        Expanded(child: slider),
        Text(
          '${((diagram.state.getValue(label) ?? 0.5) * 100).toStringAsFixed(1)}%',
          style: style.valueTextStyle,
        ),
      ],
    );

    return Padding(
      padding: style.padding ?? EdgeInsets.zero,
      child: row,
    );
  }

  Widget _buildVisibilityToggles(BuildContext context) {
    final toggles = visibilityToggles!.map((toggle) {
      return Padding(
        padding: style.padding ?? EdgeInsets.zero,
        child: ElevatedButton(
          style: style.toggleButtonStyle,
          onPressed: toggle.onToggle,
          child: Text(
            toggle.isVisible ? 'Hide ${toggle.label}' : 'Show ${toggle.label}',
            style: style.labelTextStyle,
          ),
        ),
      );
    }).toList();

    return layout.wrapControls
        ? Wrap(
            spacing: style.spacing,
            alignment: WrapAlignment.center,
            children: toggles,
          )
        : Row(
            mainAxisAlignment: style.controlsAlignment,
            children: toggles.expand((toggle) sync* {
              yield toggle;
              if (toggle != toggles.last) {
                yield SizedBox(width: style.spacing);
              }
            }).toList(),
          );
  }
}

/// Represents a visibility toggle button configuration
class VisibilityToggle {
  final String label;
  final bool isVisible;
  final VoidCallback onToggle;

  const VisibilityToggle({
    required this.label,
    required this.isVisible,
    required this.onToggle,
  });

  /// Creates a standard visibility toggle for grid
  factory VisibilityToggle.grid(StateManagedDiagramBase diagram) {
    return VisibilityToggle(
      label: 'Grid',
      isVisible: diagram.showGrid,
      onToggle: diagram.toggleGrid,
    );
  }

  /// Creates a standard visibility toggle for axes
  factory VisibilityToggle.axes(StateManagedDiagramBase diagram) {
    return VisibilityToggle(
      label: 'Axes',
      isVisible: diagram.showAxes,
      onToggle: diagram.toggleAxes,
    );
  }

  /// Creates a standard visibility toggle for frame
  factory VisibilityToggle.frame(StateManagedDiagramBase diagram) {
    return VisibilityToggle(
      label: 'Frame',
      isVisible: diagram.showFrame,
      onToggle: diagram.toggleFrame,
    );
  }

  /// Creates all standard visibility toggles
  static List<VisibilityToggle> standardToggles(StateManagedDiagramBase diagram) {
    return [
      VisibilityToggle.grid(diagram),
      VisibilityToggle.axes(diagram),
      VisibilityToggle.frame(diagram),
    ];
  }
}
