# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- New `DiagramElementFactory` class to replace `DiagramElementBuilder`
  - Follows factory pattern for clearer intent and better encapsulation
  - Provides same functionality with improved naming and structure

### Deprecated
- `DiagramElementBuilder` class is now deprecated
  - Will be removed in a future version
  - Use `DiagramElementFactory` instead
  - All methods have equivalent counterparts in the new factory class:
    - `buildElements()` -> `createElements()`
    - `buildCircle()` -> `createCircle()`
    - Other methods follow the same pattern

### Changed
- Updated all demo files to use `DiagramElementFactory` instead of `DiagramElementBuilder`
- Added deprecation notices and migration guidance in code comments
