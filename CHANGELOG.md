# Changelog

## [12.1.0-13] - 2026-09-11

### Added
- Add a Maximum Frames setting to cap visible boss bars at 1-5, filling gaps left by dead or missing bosses and also limiting previews
- Add a Track Target option to display one enemy hard or soft target instead of bosses, with hard-target priority, automatic target updates, and disabled frame-count controls
- Add Test Frames, Track Target, and Maximum Frames to the addon settings menu, synchronized with Edit Mode
- Add a per-profile Hide Default Boss Frames checkbox, off by default, with combat-safe visibility changes

### Changed
- Move Track Target and Maximum Frames below Test Frames, outside the collapsible sections

### Fixed
- Stop unchanged slider callbacks from rebuilding and randomizing the preview while a slider is held
- Hide dead enemy hard and soft targets, including when the tracked target dies

## [12.1.0-12] - 2026-08-10

### Added
- Add a colorable Vertex Border texture to the LibSharedMedia border options

### Changed
- Add compatibility metadata for World of Warcraft 12.1.0

### Fixed
- Keep Edit Mode sliders synchronized when related settings or dialog controls refresh them
