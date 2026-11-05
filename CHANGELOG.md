# Changelog

## [Unreleased]

### Added
- Add Forever 1.60.1 compatibility metadata (Interface 16001)

## [12.1.5-14] - 2026-10-06

- Updated for WoW 12.1.5.

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
