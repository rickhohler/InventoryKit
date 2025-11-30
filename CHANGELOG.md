# Changelog

All notable changes to InventoryKit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Tag Registry System**: Domain-based tag registration with code execution support
  - `InventoryTagRegistry` protocol for tag registration and execution
  - `DefaultTagRegistry` actor implementation with thread-safe operations
  - Integration with `InventoryService` via optional `tagRegistry` configuration
  - Support for domain-based tag organization (e.g., "retroboxfs", "acme")
  - Code execution handlers that run when tags are encountered
  - Case-insensitive tag and domain handling
  - Comprehensive unit tests (20 tests)

### Changed
- `InventoryConfiguration` now accepts optional `tagRegistry: InventoryTagRegistry?` parameter
- `InventoryService` exposes `tagRegistry` property (defaults to `DefaultTagRegistry` if none provided)
- Backward compatible: tag registry is optional and defaults to `DefaultTagRegistry` if not provided

### Documentation
- Added comprehensive Tag Registry System section to README.md
- Usage examples for tag registration and execution
- Integration patterns with RetroboxFS documented
- Thread safety notes added

## [1.0.0] - 2025-11-29

### Added
- Initial release
- Core inventory management functionality
- YAML/JSON schema support
- Storage provider abstraction
- High-volume catalog with pagination
- Relationship modeling
- Component tracking
- Lifecycle management
- MRO (Maintenance, Repair, Operations) support
- Health tracking

