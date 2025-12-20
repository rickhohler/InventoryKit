# Changelog

All notable changes to InventoryKit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Future changes will be documented here

### Changed
- Future changes will be documented here

### Fixed
- Future changes will be documented here

## [2.0.0] - 2025-12-20

### Changed
- **Protocol-First Architecture**:
  - `InventoryCore` is now a pure protocol definition layer.
  - Concrete model implementations (`InventoryAsset`, `InventoryDocument`, etc.) moved to `InventoryKit`.
  - Introduced `InventoryRelationshipRequirementProtocol`, `InventoryCollectionProtocol`, and others to formalize interfaces.
- **Project Structure**:
  - Massive cleanup of unused source files and documentation (`VENDOR_*.md`).
  - Added architectural documentation:
    - `docs/INVENTORY_KIT_ARCHITECTURE.md`
    - `docs/INVENTORY_TERMINOLOGY.md`
    - `docs/INVENTORY_KIT_MIGRATION_PLAN.md`

### Fixed
- **Build Quality**: Resolved all "initialization of immutable value was never used" and "no async operations" warnings.
- **Clean Build**: Project now builds cleanly with 0 errors and significantly reduced warnings.

## [1.2.0] - 2025-12-18

### Added
- **InventoryCore Target**: New library target for shared primitives and models to improve modularity.
- **New Product Models**: 
  - `InventoryProduct`: Rich representation of hardware and software products.
  - `InventoryCatalogVendor`: Structured vendor identification for cataloging.
  - `InventoryProductCatalog`: Comprehensive catalog for product-level data and specifications.
- **Implementation Guidelines**: Added `docs/IMPLEMENTATION_GUIDELINES.md` to formalize project standards.

### Changed
- **Modularity & Reorganization**: 
  - Extracted shared protocols and models from `InventoryKit` to `InventoryCore`.
  - Reorganized project structure: `Sources/InventoryCore` for primitives, `Sources/InventoryKit` for high-level services and features.
  - `InventoryKit` now depends on `InventoryCore`.
  - Refactored `InventoryAssetProtocol` and `AnyInventoryAsset` to support broader product metadata.
- **Improved Performance**: Internal optimizations for catalog resolution, identifier management, and relationship checks.

## [1.1.1] - 2025-12-03

### Fixed
- **CI Compatibility**: Lowered Swift tools version from 6.2 to 6.0 for GitHub Actions compatibility
  - Updated Package.swift to use `swift-tools-version: 6.0`
  - Compatible with GitHub Actions macos-latest runner (Swift 6.1.0)
  - Simplified CI workflow to use latest Xcode only

## [1.1.0] - 2025-12-03

### Added
- **Tag Registry System**: Domain-based tag registration with code execution support
  - `InventoryTagRegistry` protocol for tag registration and execution
  - `DefaultTagRegistry` actor implementation with thread-safe operations
  - Integration with `InventoryService` via optional `tagRegistry` configuration
  - Support for domain-based tag organization (e.g., "retroboxfs", "acme")
  - Code execution handlers that run when tags are encountered
  - Case-insensitive tag and domain handling
  - Comprehensive unit tests (20 tests)
- **Copyright and Vendor Support**: Added copyright and vendor information to inventory assets
  - `CopyrightInfo` model for structured copyright information
  - `VendorProtocol` for vendor identification
  - `AnyInventoryAsset` type-erased wrapper for inventory assets
  - `InventoryAssetProtocol` protocol for asset abstraction
- **Enhanced Storage Provider**: Improved storage provider capabilities
  - Enhanced `InventoryStorageProvider` with additional methods
  - Removed `TextFileInventoryStorageProvider` (consolidated functionality)
- **Documentation**: Added vendor protocol documentation
  - VENDOR_PROTOCOL.md: Vendor protocol design
  - VENDOR_CLIENT_IMPLEMENTATION.md: Client implementation guide
  - VENDOR_USAGE_EXAMPLES.md: Usage examples

### Changed
- `InventoryConfiguration` now accepts optional `tagRegistry: InventoryTagRegistry?` parameter
- `InventoryService` exposes `tagRegistry` property (defaults to `DefaultTagRegistry` if none provided)
- Enhanced `InventoryService` with improved initialization and configuration
- Enhanced `InventoryCatalog` with improved pagination and query capabilities
- Enhanced `InventoryDocument` with copyright and vendor support
- Enhanced transformers with improved error handling
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

