/// Shared types and constants for IDG format
class IDGFormat {
  static const String currentVersion = "1.0";
  static const String fileExtension = ".idg";
  
  static const Map<String, String> elementTypes = {
    'line': 'LineElement',
    'polygon': 'PolygonElement',
    'circle': 'CircleElement',
    'bezier': 'BezierCurveElement',
  };
}
