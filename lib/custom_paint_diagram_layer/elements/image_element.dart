import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';

import '../drawable_element.dart';
import '../coordinate_system.dart';

/// Source type for the image
enum ImageSource {
  /// Image from network URL
  network,
  /// Image from local assets
  asset,
  /// Image from memory (ui.Image)
  memory
}

/// A drawable image element that can display images from various sources.
class ImageElement extends DrawableElement {
  /// The image source type
  final ImageSource source;

  /// The image path or URL
  final String? path;

  /// The image object if loaded from memory
  final ui.Image? image;

  /// Width of the image in coordinate space
  final double width;

  /// Height of the image in coordinate space
  final double height;

  /// Opacity of the image (0.0 to 1.0)
  final double opacity;

  /// The loaded image
  ui.Image? _loadedImage;
  
  /// Image stream
  ImageStream? _imageStream;
  
  /// Image stream subscription
  ImageStreamListener? _listener;
  
  /// Loading state
  bool _isLoading = false;

  /// Creates a new image element.
  ImageElement({
    required double x,
    required double y,
    required this.source,
    this.path,
    this.image,
    required this.width,
    required this.height,
    this.opacity = 1.0,
    Color color = const Color(0xFF000000),
  }) : super(x: x, y: y, color: color);

  void _cleanupImageStream() {
    if (_listener != null && _imageStream != null) {
      _imageStream!.removeListener(_listener!);
      _listener = null;
      _imageStream = null;
    }
  }

  Future<void> _ensureImageLoaded() async {
    if (_loadedImage != null || _isLoading) return;
    _isLoading = true;

    try {
      debugPrint('Loading image: $path');
      
      if (source == ImageSource.network) {
        final imageProvider = NetworkImage(path!);
        final completer = Completer<ui.Image>();
        
        _imageStream = imageProvider.resolve(ImageConfiguration.empty);
        _listener = ImageStreamListener(
          (info, _) {
            debugPrint('Image loaded successfully');
            if (!completer.isCompleted) {
              completer.complete(info.image);
              _loadedImage = info.image;
            }
          },
          onError: (error, stackTrace) {
            debugPrint('Error loading image: $error');
            if (!completer.isCompleted) {
              completer.completeError(error);
            }
          },
        );
        
        _imageStream!.addListener(_listener!);
        await completer.future;
      }
    } catch (e) {
      debugPrint('Exception loading image: $e');
    } finally {
      _isLoading = false;
      // Clean up the stream if loading failed
      if (_loadedImage == null) {
        _cleanupImageStream();
      }
    }
  }

  @override
  Future<void> render(Canvas canvas, CoordinateSystem coordinates) async {
    final center = coordinates.mapValueToDiagram(x, y);
    
    // Calculate corners with y adjusted for bottom-origin coordinate system
    final topLeft = coordinates.mapValueToDiagram(
      x - width / 2,
      y + height / 2
    );
    final bottomRight = coordinates.mapValueToDiagram(
      x + width / 2,
      y - height / 2
    );

    // Draw a background rectangle
    canvas.drawRect(
      Rect.fromPoints(topLeft, bottomRight),
      Paint()..color = Colors.yellow.withOpacity(0.3),
    );

    await _ensureImageLoaded();
    
    if (_loadedImage == null) {
      // Draw an X if image failed to load
      final paint = Paint()
        ..color = Colors.red
        ..strokeWidth = 2.0;
      
      canvas.drawLine(topLeft, bottomRight, paint);
      canvas.drawLine(
        Offset(topLeft.dx, bottomRight.dy),
        Offset(bottomRight.dx, topLeft.dy),
        paint,
      );
      return;
    }

    // Draw the image
    final paint = Paint()..color = Colors.white.withOpacity(opacity);
    canvas.drawImageRect(
      _loadedImage!,
      Rect.fromLTWH(0, 0, _loadedImage!.width.toDouble(), _loadedImage!.height.toDouble()),
      Rect.fromPoints(topLeft, bottomRight),
      paint,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImageElement &&
        other.x == x &&
        other.y == y &&
        other.source == source &&
        other.path == path &&
        other.image == image &&
        other.width == width &&
        other.height == height &&
        other.opacity == opacity &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(
        x,
        y,
        source,
        path,
        image,
        width,
        height,
        opacity,
        color,
      );
}
