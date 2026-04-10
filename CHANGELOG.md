# Changelog

All notable changes to RPG Boss Bar will be documented in this file.

## [12.0.1-7] - 2026-04-10

### Fixed
- Fix border and bar frame level ordering
- Fix global variable leaks (`y_left_offset`, `received_frame_count_arg`, `color`)
- Fix typo in `received_frame_count_arg`
- Remove dead `PLAYER_ENTERING_WORLD` event handler

## [12.0.1-6] - 2026-02-04

### Fixed
- Global toggle updated to not change when pressing "Reset to Default"

## [12.0.1-5] - 2026-02-04

### Fixed
- Health text offset Y labeled as offset X
- Defaults changed to be more reasonbly sized for non 4k monitor
- Curseforge changelog should now show in markdown

### Added
- Global toggle, allows for setting settings for all characters with the global toggle enabled
- Health text offset y adjustable in settings

### Fixed
- changelog showing as plain text
