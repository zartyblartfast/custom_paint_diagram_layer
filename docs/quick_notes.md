# Quick Reference Notes

## Running Diagrams

### From Root Directory
```bash
# Run standalone demo from root
flutter run -t devtest/standalone_migrated_main.dart -d chrome

# Run embedded demo from root
flutter run -t devtest/embedded_migrated_main.dart -d chrome
```

### From Devtest Directory
```bash
cd devtest
flutter run -d chrome -t migrated_main.dart        # Main migrated demo
flutter run -d chrome -t standalone_migrated_main.dart  # Standalone version
```

### Embedded Diagram Demo
```bash
cd devtest
flutter run -d chrome -t embedded_migrated_main.dart
```

### Individual Demos
```bash
cd devtest
# Butterfly Art Demo
flutter run -d chrome -t demos/migrated_butterfly_art.dart

# FUML Process Flow Demo
flutter run -d chrome -t demos/migrated_fuml_process_flow.dart

# FUML Test Demo
flutter run -d chrome -t demos/migrated_fuml_test.dart

# Example Migrated Diagram
flutter run -d chrome -t demos/example_migrated_diagram.dart
```

### Web Build
```bash
cd web_build
flutter build web --web-renderer canvaskit --release
```

## Common Development Commands

### Git Commands
```bash
git status                  # Check status
git add .                  # Stage all changes
git commit -m "message"    # Commit changes
git push origin Dev5       # Push to Dev5 branch
```

### Flutter Commands
```bash
flutter clean              # Clean build
flutter pub get           # Get dependencies
flutter analyze           # Run static analysis
```

## Notes
- Can run from root directory or devtest directory
- Always specify -d chrome for web development and testing
- The canvaskit renderer is preferred for better performance
