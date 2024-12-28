import 'package:json_annotation/json_annotation.dart';

part 'diagram_schema.g.dart';

/// Schema for generating diagrams from configuration
@JsonSerializable()
class DiagramSchema {
  final String name;
  final String type;
  final CanvasConfig canvas;
  final List<ElementConfig> elements;
  final List<ControlConfig> controls;

  const DiagramSchema({
    required this.name,
    required this.type,
    required this.canvas,
    required this.elements,
    this.controls = const [],
  });

  factory DiagramSchema.fromJson(Map<String, dynamic> json) =>
      _$DiagramSchemaFromJson(json);
  
  Map<String, dynamic> toJson() => _$DiagramSchemaToJson(this);
}

@JsonSerializable()
class CanvasConfig {
  final double width;
  final double height;
  final double xMin;
  final double xMax;
  final double yMin;
  final double yMax;

  const CanvasConfig({
    required this.width,
    required this.height,
    required this.xMin,
    required this.xMax,
    required this.yMin,
    required this.yMax,
  });

  factory CanvasConfig.fromJson(Map<String, dynamic> json) =>
      _$CanvasConfigFromJson(json);
  
  Map<String, dynamic> toJson() => _$CanvasConfigToJson(this);
}

@JsonSerializable()
class ElementConfig {
  final String type;
  final Map<String, dynamic> properties;

  const ElementConfig({
    required this.type,
    required this.properties,
  });

  factory ElementConfig.fromJson(Map<String, dynamic> json) =>
      _$ElementConfigFromJson(json);
  
  Map<String, dynamic> toJson() => _$ElementConfigToJson(this);
}

@JsonSerializable()
class ControlConfig {
  final String type;
  final String name;
  final Map<String, dynamic> properties;

  const ControlConfig({
    required this.type,
    required this.name,
    required this.properties,
  });

  factory ControlConfig.fromJson(Map<String, dynamic> json) =>
      _$ControlConfigFromJson(json);
  
  Map<String, dynamic> toJson() => _$ControlConfigToJson(this);
}
