# Changelog

All notable changes to RPG Boss Bar will be documented in this file.

## [12.0.0-3] - 2026-02-03

### Changed
- Refactored Database.lua - separated functions, data, and defaults
- Refactored Settings.lua - re-ordered settings, cleaned up names
- Added test frame count slider to settings

### Fixed
- Fixed test name resetting on update
- Fixed percentage health disable count

## [12.0.0-2]

### Added
- LibEditMode integration for edit mode moving and editing of frames
- LibSharedMedia support for adjusting textures and fonts
- Database.lua for centralized database handling with getter/setter methods
- Settings panel for addon customization
- `/rpgbb reset` command for resetting the database

### Changed
- Major code refactor with new data structure
- Format large health numbers with commas
- Made `/test` command more logical - shows test if not currently testing
- Use built-in ScaleTo100 curve

### Removed
- Removed abbreviations from health display
- Removed lock command (use edit mode instead)

### Note
- Old position info will be deleted on install; reposition via edit mode
