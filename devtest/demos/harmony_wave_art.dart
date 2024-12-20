import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

class HarmonyWaveArt extends StatefulWidget {
  const HarmonyWaveArt({super.key});
  @override
  State<HarmonyWaveArt> createState() => _HarmonyWaveArtState();
}

class _HarmonyWaveArtState extends State<HarmonyWaveArt> {
  late IDiagramLayer diagramLayer;
  double _zoomLevel = 0.5;
  double _waveSpacing = 0.5;
  double _scale = 1.0;
  Timer? _animationTimer;
  String? _activeAnimation;  // 'zoom' or 'spacing' or null
  static const double _animationSpeed = 0.001;  // Change per tick

  // C major scale notes and their frequencies (C4 to C5)
  static const scaleNotes = {
    'C4': 261.63,   // 1
    'D4': 293.66,   // 2
    'E4': 329.63,   // 3
    'F4': 349.23,   // 4
    'G4': 392.00,   // 5
    'A4': 440.00,   // 6
    'B4': 493.88,   // 7
    'C5': 523.25,   // 8
    // Add some additional notes for minor chords
    'Eb4': 311.13,  // E flat for minor third
    'Ab4': 415.30,  // A flat
    'Bb4': 466.16   // B flat
  };

  // Note colors for visualization
  static const noteColors = {
    'C4': Colors.red,
    'D4': Colors.orange,
    'E4': Colors.yellow,
    'Eb4': Color(0xFF9ACD32),  // Yellow-green for flat notes
    'F4': Colors.green,
    'G4': Colors.blue,
    'Ab4': Color(0xFF4169E1),  // Royal blue for flat notes
    'A4': Colors.indigo,
    'Bb4': Color(0xFF8A2BE2),  // Blue-violet for flat notes
    'B4': Colors.purple,
    'C5': Colors.red,
  };

  // Selected notes (start with C major triad: C, E, G)
  final Set<String> _selectedNotes = {'C4', 'E4', 'G4'};

  // Predefined chord patterns
  static const chordPatterns = {
    'Major Triad (1-3-5)': ['C4', 'E4', 'G4'],
    'Minor Triad (1-♭3-5)': ['C4', 'Eb4', 'G4'],
    'Power Chord (1-5)': ['C4', 'G4'],
    'Major 7th (1-3-5-7)': ['C4', 'E4', 'G4', 'B4'],
    'Minor 7th (1-♭3-5-♭7)': ['C4', 'Eb4', 'G4', 'Bb4'],
    'Full Scale': ['C4', 'D4', 'E4', 'F4', 'G4', 'A4', 'B4', 'C5'],
  };

  @override
  void initState() {
    super.initState();
    diagramLayer = _createDiagramLayer();
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  IDiagramLayer _createDiagramLayer() {
    return BasicDiagramLayer(
      coordinateSystem: CoordinateSystem(
        origin: Offset.zero,  // Let DL's CanvasAlignment handle centering
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: -5,
        yRangeMax: 5,
        scale: _scale,
      ),
      showAxes: false,  // Disable default axes
      elements: _createElements(0.0, 1.0),
    );
  }

  List<DrawableElement> _createElements(double timePosition, double timeRange) {
    final elements = <DrawableElement>[];
    
    // Add X and Y axes using DL's axis elements
    elements.add(const XAxisElement(yValue: 0, tickInterval: 1.0));  // X-axis at y=0
    elements.add(const YAxisElement(xValue: 0, tickInterval: 1.0));  // Y-axis at x=0
    
    // Grid lines every unit
    for (double x = -10; x <= 10; x += 1) {
      elements.add(LineElement(
        x1: x,
        y1: -5,  // Adjusted Y range
        x2: x,
        y2: 5,   // Adjusted Y range
        color: Colors.grey.withOpacity(0.1),
        strokeWidth: 1,
      ));
    }
    for (double y = -5; y <= 5; y += 1) {  // Adjusted Y range
      elements.add(LineElement(
        x1: -10,
        y1: y,
        x2: 10,
        y2: y,
        color: Colors.grey.withOpacity(0.1),
        strokeWidth: 1,
      ));
    }

    // Create waveforms for selected notes
    // Two-stage scaling for better control
    final baseScale = 0.00001 * math.pow(1000, _waveSpacing);
    final baseTimeScale = baseScale * math.pow(10, _zoomLevel);
    final amplitude = 3.0;  // Wave amplitude ±3 units, staying within -10 to +10 range

    // Helper function to create wave points
    List<Point2D> createWavePoints(double frequency, double timeScale) {
      final points = <Point2D>[];
      for (double x = -10; x <= 10; x += 0.1) {  // Smaller steps for smoother curves
        final t = x * timeScale;
        final y = math.sin(2 * math.pi * frequency * t) * amplitude;  // Centered at y=0
        points.add(Point2D(x, y));
      }
      return points;
    }

    // Create a wave for each selected note
    for (final note in _selectedNotes) {
      final frequency = scaleNotes[note];
      if (frequency != null) {  
        elements.add(PolygonElement(
          points: createWavePoints(frequency, baseTimeScale),
          x: 0,
          y: 0,
          color: noteColors[note] ?? Colors.grey,  
          strokeWidth: 2,
          closed: false,
        ));
      }
    }

    return elements;
  }

  void _updateDiagram() {
    setState(() {
      diagramLayer = _createDiagramLayer();
    });
  }

  void _toggleAnimation(String type) {
    if (_activeAnimation == type) {
      // Stop current animation
      _animationTimer?.cancel();
      _animationTimer = null;
      _activeAnimation = null;
    } else {
      // Stop any existing animation
      _animationTimer?.cancel();
      
      // Start new animation
      _activeAnimation = type;
      _animationTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        setState(() {
          if (type == 'zoom') {
            _zoomLevel = (_zoomLevel + _animationSpeed) % 1.0;
          } else {
            _waveSpacing = (_waveSpacing + _animationSpeed) % 1.0;
          }
          _updateDiagram();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Musical Harmony Visualization'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Musical Harmonies'),
                  content: const SingleChildScrollView(
                    child: Text(
                      'This visualization shows the wave patterns of musical notes and their harmonies.\n\n'
                      '• Each note is represented by a sine wave\n'
                      '• The frequency determines the wave\'s pattern\n'
                      '• Colors help identify different notes\n\n'
                      'Try these combinations:\n'
                      '• Major Triad (1-3-5): Bright, happy sound\n'
                      '• Minor Triad (1-♭3-5): Darker, melancholic sound\n'
                      '• Power Chord (1-5): Strong, basic harmony\n'
                      '• Full Scale: All notes in sequence\n\n'
                      'Use the zoom control to adjust the wave spacing.'
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Note selection chips
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: scaleNotes.keys.map((note) {
                return FilterChip(
                  label: Text(note),
                  selected: _selectedNotes.contains(note),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedNotes.add(note);
                      } else {
                        _selectedNotes.remove(note);
                      }
                      _updateDiagram();
                    });
                  },
                  selectedColor: noteColors[note]?.withOpacity(0.3),
                );
              }).toList(),
            ),
          ),
          // Preset chord patterns
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Wrap(
              spacing: 8.0,
              children: chordPatterns.entries.map((entry) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedNotes.clear();
                      _selectedNotes.addAll(entry.value);
                      _updateDiagram();
                    });
                  },
                  child: Text(entry.key),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 800,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: CustomPaint(
                  painter: CustomPaintRenderer(diagramLayer),
                  size: const Size(800, 400),  // DL will handle scaling
                ),
              ),
            ),
          ),
          // Control sliders
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      child: Column(
                        children: [
                          const Text('Wave Spacing'),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.compress, size: 20),
                              SizedBox(
                                width: 200,
                                child: Slider(
                                  value: _waveSpacing,
                                  min: 0.0,
                                  max: 1.0,
                                  onChanged: (value) {
                                    setState(() {
                                      _waveSpacing = value;
                                      _updateDiagram();
                                    });
                                  },
                                ),
                              ),
                              const Icon(Icons.expand, size: 20),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(
                                  _activeAnimation == 'spacing' ? Icons.pause : Icons.play_arrow,
                                  color: _activeAnimation == 'spacing' ? Colors.blue : null,
                                  size: 20,
                                ),
                                onPressed: () => _toggleAnimation('spacing'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      child: Column(
                        children: [
                          const Text('Zoom In/Out'),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.zoom_out, size: 20),
                              SizedBox(
                                width: 200,
                                child: Slider(
                                  value: _zoomLevel,
                                  min: 0.0,
                                  max: 1.0,
                                  onChanged: (value) {
                                    setState(() {
                                      _zoomLevel = value;
                                      _updateDiagram();
                                    });
                                  },
                                ),
                              ),
                              const Icon(Icons.zoom_in, size: 20),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(
                                  _activeAnimation == 'zoom' ? Icons.pause : Icons.play_arrow,
                                  color: _activeAnimation == 'zoom' ? Colors.blue : null,
                                  size: 20,
                                ),
                                onPressed: () => _toggleAnimation('zoom'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
