# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2025-01-27

### Added
- Initial release of Phoenix Three
- `mix threejs.setup` command for complete Three.js setup
- `mix threejs.download` command for downloading Three.js files
- `mix threejs.configure` command for configuring app.js imports
- Support for version selection with `--version` flag
- Force overwrite option with `--force` flag
- Automatic global THREE variable setup for LiveView hooks
- Downloads multiple Three.js variants (module, core, webgpu, nodes, tsl)
- Idempotent operations - safe to run multiple times
- Smart import detection to avoid duplicates

### Features
- One-command Three.js integration for Phoenix projects
- Automatic CDN download from CDNJS
- Phoenix asset convention compliance
- LiveView hook compatibility
- Version control support
- Build process integration

[Unreleased]: https://github.com/benjaminjacobberg/phoenix_three/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/benjaminjacobberg/phoenix_three/releases/tag/v0.1.0