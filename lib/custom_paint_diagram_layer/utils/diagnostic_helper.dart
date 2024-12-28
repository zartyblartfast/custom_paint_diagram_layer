import 'package:flutter/foundation.dart';

/// Level of diagnostic message
enum DiagnosticLevel {
  info,
  warning,
  error;

  @override
  String toString() => name.toUpperCase();
}

/// A diagnostic message from a utility component
class DiagnosticMessage {
  /// The source component that generated this message
  final String source;
  
  /// The specific context within the source (e.g., method name)
  final String context;
  
  /// The diagnostic message
  final String message;
  
  /// The severity level
  final DiagnosticLevel level;
  
  /// Optional data associated with the message
  final Map<String, dynamic>? data;

  /// Creates a new diagnostic message
  const DiagnosticMessage({
    required this.source,
    required this.context,
    required this.message,
    required this.level,
    this.data,
  });

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('[$level] $source.$context: $message');
    if (data != null && data!.isNotEmpty) {
      buffer.write('\n  Data: ${data.toString()}');
    }
    return buffer.toString();
  }
}

/// Callback for receiving diagnostic messages
typedef DiagnosticCallback = void Function(DiagnosticMessage message);

/// Global flag to enable/disable diagnostic output
bool diagnosticsEnabled = false;

/// Mixin that provides diagnostic capabilities to utility classes
mixin DiagnosticHelper {
  /// The source identifier for diagnostic messages
  String get diagnosticSource;

  /// Optional callback for receiving diagnostic messages
  DiagnosticCallback? get onDiagnostic;

  /// Whether diagnostics are enabled for this instance
  bool get isDiagnosticsEnabled => diagnosticsEnabled;

  /// Report a diagnostic message
  void reportDiagnostic({
    required String context,
    required String message,
    required DiagnosticLevel level,
    Map<String, dynamic>? data,
  }) {
    if (!isDiagnosticsEnabled) return;

    final diagnosticMessage = DiagnosticMessage(
      source: diagnosticSource,
      context: context,
      message: message,
      level: level,
      data: data,
    );

    onDiagnostic?.call(diagnosticMessage);

    // In debug mode, also print to console if no callback is provided
    if (kDebugMode && onDiagnostic == null) {
      print(diagnosticMessage);
    }
  }

  /// Report an info message
  void reportInfo(String context, String message, [Map<String, dynamic>? data]) {
    reportDiagnostic(
      context: context,
      message: message,
      level: DiagnosticLevel.info,
      data: data,
    );
  }

  /// Report a warning message
  void reportWarning(String context, String message, [Map<String, dynamic>? data]) {
    reportDiagnostic(
      context: context,
      message: message,
      level: DiagnosticLevel.warning,
      data: data,
    );
  }

  /// Report an error message
  void reportError(String context, String message, [Map<String, dynamic>? data]) {
    reportDiagnostic(
      context: context,
      message: message,
      level: DiagnosticLevel.error,
      data: data,
    );
  }
}
