# Changelog

## [12.0.7-10] - 2026-06-16

### Added
- Profile export and import support

### Changed
- Update TOC interface metadata for WoW 12.0.7

## [12.0.5-9] - 2026-04-24

### Added
- Full profile system — create, copy, rename, and delete profiles
- Profiles are stored account-wide; each character selects which profile to use
- Confirmation dialog when resetting settings to defaults in Edit Mode

### Fixed
- Fix "Create Profile" dialog accessing wrong edit box field

### Internal
- Extract LibSimpleDB-1.0 as a standalone library
- Migrate old per-character/global SavedVariables to new profile format
