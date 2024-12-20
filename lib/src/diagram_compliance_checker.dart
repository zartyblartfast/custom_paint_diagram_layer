import 'dart:io';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:path/path.dart' as path;

/// Result of a compliance check
class ComplianceResult {
  final String filePath;
  final List<String> violations;
  final List<String> warnings;
  final bool isCompliant;

  ComplianceResult({
    required this.filePath,
    required this.violations,
    required this.warnings,
  }) : isCompliant = violations.isEmpty;

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Compliance Check Result for: $filePath');
    buffer.writeln('Status: ${isCompliant ? "✅ Compliant" : "❌ Non-compliant"}');
    
    if (violations.isNotEmpty) {
      buffer.writeln('\nViolations:');
      for (final violation in violations) {
        buffer.writeln('❌ $violation');
      }
    }
    
    if (warnings.isNotEmpty) {
      buffer.writeln('\nWarnings:');
      for (final warning in warnings) {
        buffer.writeln('⚠️ $warning');
      }
    }
    
    return buffer.toString();
  }
}

/// Visitor that checks for DL compliance rules
class ComplianceVisitor extends RecursiveAstVisitor<void> {
  final List<String> violations = [];
  final List<String> warnings = [];

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    // Check coordinate system setup
    if (node.name.lexeme == 'createCoordinateSystem') {
      _checkCoordinateSystem(node);
    }
    
    // Check render method
    if (node.name.lexeme == 'render') {
      _checkRenderMethod(node);
    }

    super.visitMethodDeclaration(node);
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    // Check class inheritance
    _checkClassInheritance(node);
    
    // Check for DL compliance in methods
    for (final member in node.members) {
      if (member is MethodDeclaration) {
        if (member.name.lexeme == '_createDiagramLayer' || 
            member.name.lexeme == 'createCoordinateSystem') {
          _checkCoordinateSystem(member);
        }
        if (member.name.lexeme == 'render') {
          _checkRenderMethod(member);
        }
      }
    }
    
    super.visitClassDeclaration(node);
  }

  void _checkCoordinateSystem(MethodDeclaration node) {
    final source = node.toString();
    
    // Check for proper origin handling
    if (!source.contains('Offset.zero') && !source.contains('origin:')) {
      violations.add('Coordinate system must explicitly set origin');
    }
    
    // Check for proper scale initialization
    if (!source.contains('scale:')) {
      violations.add('Coordinate system must explicitly set scale');
    }
    
    // Check for proper range definition
    if (!source.contains('RangeMin') || !source.contains('RangeMax')) {
      violations.add('Coordinate system must define coordinate ranges');
    }
  }

  void _checkRenderMethod(MethodDeclaration node) {
    final source = node.toString();
    
    if (!source.contains('CanvasAlignment')) {
      violations.add('Render method must use CanvasAlignment');
    }
    
    if (!source.contains('alignCenter()')) {
      violations.add('Must call alignCenter() in render method');
    }
    
    if (!source.contains('mapValueToDiagram')) {
      warnings.add('Elements should use mapValueToDiagram for coordinate transformation');
    }
  }

  void _checkClassInheritance(ClassDeclaration node) {
    final extendsClause = node.extendsClause;
    if (extendsClause != null) {
      final superclass = extendsClause.superclass.toString();
      
      // Check if it extends DL base classes
      final extendsDLBase = ['DrawableElement', 'DiagramTestBase', 'DiagramTestBaseState', 'DiagramTestBase>', 'DiagramTestBaseState<'].any(
        (base) => superclass.contains(base)
      );

      if (!extendsDLBase) {
        // If it's a StatefulWidget, it should extend DiagramTestBase
        if (superclass.contains('StatefulWidget')) {
          warnings.add('Class ${node.name} should extend DiagramTestBase for DL compliance');
        }
        // If it's a State class, it should extend DiagramTestBaseState
        else if (superclass.contains('State<')) {
          warnings.add('Class ${node.name} should extend DiagramTestBaseState for DL compliance');
        }
        // For other classes, check if they have DL functionality
        else {
          final hasDLMethods = node.members.any((member) {
            if (member is MethodDeclaration) {
              final name = member.name.lexeme;
              return name == '_createDiagramLayer' || 
                     name == 'createCoordinateSystem' ||
                     name == 'render';
            }
            return false;
          });
          
          if (hasDLMethods) {
            warnings.add('Class ${node.name} has DL methods but does not extend DL base classes');
          }
        }
      }
    }
  }
}

/// Main class for checking diagram compliance
class DiagramComplianceChecker {
  /// Check a single file for compliance
  static Future<ComplianceResult> checkFile(String filePath) async {
    final collection = AnalysisContextCollection(
      includedPaths: [filePath],
      resourceProvider: PhysicalResourceProvider.INSTANCE,
    );

    final context = collection.contextFor(filePath);
    final result = await context.currentSession.getResolvedUnit(filePath);
    
    if (result is! ResolvedUnitResult) {
      return ComplianceResult(
        filePath: filePath,
        violations: ['Failed to analyze file'],
        warnings: [],
      );
    }

    final visitor = ComplianceVisitor();
    result.unit.accept(visitor);

    return ComplianceResult(
      filePath: filePath,
      violations: visitor.violations,
      warnings: visitor.warnings,
    );
  }

  /// Check all diagram files in a directory
  static Future<List<ComplianceResult>> checkDirectory(String dirPath) async {
    final dir = Directory(dirPath);
    if (!dir.existsSync()) {
      throw ArgumentError('Directory does not exist: $dirPath');
    }

    final results = <ComplianceResult>[];
    await for (final file in dir.list(recursive: true)) {
      if (file is File && file.path.endsWith('.dart')) {
        final result = await checkFile(file.path);
        results.add(result);
      }
    }

    return results;
  }
}

/// CLI entry point
void main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart diagram_compliance_checker.dart <file_or_directory_path>');
    return;
  }

  final target = args[0];
  
  try {
    if (FileSystemEntity.isDirectorySync(target)) {
      final results = await DiagramComplianceChecker.checkDirectory(target);
      for (final result in results) {
        print('\n${result.toString()}');
      }
    } else {
      final result = await DiagramComplianceChecker.checkFile(target);
      print(result.toString());
    }
  } catch (e) {
    print('Error: $e');
  }
}
