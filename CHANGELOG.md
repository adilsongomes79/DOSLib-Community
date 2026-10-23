# Changelog

## 9.1.2-brx27.1 — initial community candidate, 2026-10-23

### Added

- `Debug_BRX27|x64` and `Release_BRX27|x64` solution and project targets.
- BRX V27 SDK discovery and a PowerShell build entry point.
- Community documentation, contribution guidance and release packaging.

### Fixed

- Select `bool` for the `dos_getsecret` message filter callback on BRX27,
  matching `AcedFilterWinMsgFn` in the V27 SDK.
- Use host x64 tools for BRX27, avoiding the locally observed host x86
  linker/PDB error.
- Resolve 64-bit Program Files correctly when MSBuild runs as a 32-bit process.

### Validation

- Release build succeeded using BRX SDK 27.1.05.0, MSVC v143 14.44.35207,
  ATL/MFC and Windows SDK 10.0.26100.0.
- Maintainer reported successful loading in BricsCAD V27, `(dos_version)`
  returning `(9 1 2)`, and successful IDK/IDCAD application startup.
- Broad function coverage, other CAD versions, Debug and Linux/macOS builds
  remain unverified. This is an initial Windows x64 candidate.

The package suffix identifies this community build; the upstream DOSLib
library version remains 9.1.2 and the LISP version result is unchanged.
