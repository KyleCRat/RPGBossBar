# Changelog

## [12.0.7-11] - 2026-06-23

### Added
- Add profile skins with default skin selection, skin application, and profile creation from skins
- Add selectable accent presets with per-slot color, offset, scale, rotation, mirroring, and custom atlas controls
- Add configurable frame borders, including Blizzard nine-slice styles and bundled Vigor border art
- Add power bar display with configurable texture, color, border, text, sizing, and visibility
- Add vertical boss bar layout with offset, secondary scale, secondary width, and a one-time account warning
- Add font outline controls and Comfortaa font options
- Add Alliance, Horde, Kyrian, Necrolord, Night Fae, Venthyr, and Vigor skin presets

### Changed
- Rework Edit Mode settings with collapsible sections, scrolling, text input support, and improved dropdown behavior
- Render each vertical secondary boss bar with its own background and border
- Use the Center Accent settings for vertical secondary bar side accents
- Expand profile import/export and profile skin reset/apply flows

### Fixed
- Fix health and spark color channel ordering
- Fix Venthyr skin ID and display name typo
- Fix power bar visibility when boss units have no power
- Fix covenant and Vigor skin sizing issues
- Fix bad border texture selection falling back to no border instead of writing a nil setting
- Fix incomplete WIP skin file before release

## [12.0.7-10] - 2026-06-16

### Added
- Profile export and import support

### Changed
- Update TOC interface metadata for WoW 12.0.7
