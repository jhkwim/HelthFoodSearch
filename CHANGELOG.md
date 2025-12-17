# Changelog

## [1.0.2] - 2025-12-17

### Added
- **UI Design**: Applied `Pretendard` font for improved typography and modern aesthetics.
- **Data Info**: Added display of stored data count and size in Settings.
- **Legibility**: Enhanced visibility of "Report Number" and "Main Ingredients" in search result cards.

### Changed
- **UX**: Reordered search result card layout to `[Meta(Report#)] -> [Title] -> [Content]` for better scannability.
- **Detail Screen**: Improved text contrast for labels and standardized font sizes.
- **Search**: Changed aspect ratio of grid items to prevent text overflow.

### Fixed
- **Bug**: Fixed `RenderFlex overflow` error in Grid View by adjusting card aspect ratio.
- **Bug**: Fixed `RenderFlex unbounded height` error in List View by removing improper `Expanded` usage.
