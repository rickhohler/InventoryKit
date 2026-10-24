# Changelog

All notable changes to InventoryKit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.6.0] - 2026-10-24

### Added
- `TagHandlerDispatcher<Subject>` (InventoryCore): runs value and change handlers registered per tag for any tagged subject, records handler tags in an `InventoryTagRegistry` under a default domain, and uses the registry's own handlers too. `TagHandlerError`.

## [2.5.0] - 2026-10-24

### Added
- `InMemoryTagRegistry` (InventoryCore): the default `InventoryTagRegistry` implementation (successor of 1.x `DefaultTagRegistry`); tags and domains are case-insensitive.
- Value types in InventoryTypes whose JSON matches what 1.x clients stored: `ComponentLinkModel`, `CopyrightInfoModel` (with `extract(from:)` and `createTags()`), and `RawIdentifier` (free-form `type`; `identifierType` maps known kinds and legacy `serialNumber`).
- `IdentifierType.uuid` (raw value `uuid`).

### Changed
- `LinkedAsset` is `Hashable` and its properties are mutable.

### Fixed
- Copyright extraction takes the holder from the matched text: `extract(from: "© 1983 Broderbund Software")` yields holder `Broderbund Software` (1.x yielded `roderbund Software`).

### Changed
- README rewritten to match the 2.x code (removed 1.x APIs such as `InventoryService.bootstrap`, `InventoryCatalog`, `DefaultTagRegistry` and YAML transformers).
- `docs/INVENTORY_TERMINOLOGY.md` rewritten as a glossary of implemented types (it also contained unresolved merge-conflict markers).
- Tests that use the `InventoryKit` module moved from `InventoryCoreTests` to `InventoryKitTests`, so `swift test` links with the default Swift Build backend; unused `import InventoryKit` lines removed from `InventoryCoreTests`.
- `Package.resolved` refreshed to pin DesignAlgorithmsKit 1.10.0.

### Removed
- Committed Xcode build output (`build/`), now git-ignored.

## [2.1.0] - 2025-12-20

### Changed
- **Pure Protocol-First Architecture**:
  - `InventoryKit` now only exposes pure protocol types (e.g., `any InventoryAsset`, `any InventoryDocument`).
  - Removed all public concrete model implementations from `InventoryKit`.
  - Concrete helpers (e.g., `InventoryDocumentInfo`) are now internal implementation details.
- **Service Builders**:
  - Added `UserInventoryItemBuilder` for creating private/user-owned assets.
  - Added `LibraryItemBuilder` for creating public catalog items (replaced by `ReferenceProductBuilder` and `ReferenceManufacturerBuilder` in 2.2.0).
  - Builders return opaque protocol types, enforcing the facade pattern.
- **Protocol Renaming & Organization**:
  - Renamed protocols to remove the `Protocol` suffix for idiomatic Swift usage (e.g., `InventoryAssetProtocol` -> `InventoryAsset`).
  - Restructured `InventoryCore/Protocols` into domain-specific subdirectories (`Assets`, `Components`, `Collections`, etc.).
  - Moved storage definitions to `InventoryCore/Protocols/Storage`.

### Removed
- Removed monolithic `InventoryService.swift` in favor of specialized, composable services.
- Removed `ConcreteInventoryModels.swift` from public API.

## [2.4.0] - 2025-12-23

### Added
- **Hierarchical Location System**:
  - `InventoryBuilding`: Represents physical buildings.
  - `InventoryRoom`: Represents rooms within buildings.
  - `DigitalVolume`: Represents digital storage volumes (renamed from generic Volume).
- **Container Types**:
  - `ItemContainerPhysical`: Concrete type for physical containers (boxes, bins).
  - `ItemContainerDigital`: Concrete type for digital folders/archives.
- **Location Service**:
  - `DefaultLocationService`: Robust implementation for location management.
  - **Smart Move**: `reconcileLocation` infers a likely move to another room from the rooms of nearby physical containers.
  - **Geolocation**: `resolveGeoLocation` for inferring physical coordinates.
- **Models**:
  - `IdentifierModel`: Concrete `Codable` implementation of `InventoryIdentifier`.

## [2.3.0] - 2025-12-22

### Added
- **InventoryImportService**: New service that forwards asset and product imports to a `TransactionService` (it does not scan files or directories). Note: the `v2.3.0` tag does not contain this service or `InventoryRelationshipService`; both first appear in the `v2.4.0` tag.
- **InventoryRelationshipService**: Dedicated service for managing asset links (`link`, `unlink`) and evaluating requirement compliance.
- **Documentation**:
  - Updated `INVENTORY_TERMINOLOGY.md` with new service definitions.
  - Added `docs/archive/` for retired design documents.
  - Added centralized **Documentation** section to `README.md`.

### Changed
- **Code Coverage**: Achieved **95.97%** code coverage (up from ~50%).
  - Added comprehensive tests for `RelationshipScenario`, `Questionnaire` logic, and `StorageProvider` defaults.
- **Mocking Strategy**: Refactored test suite to use robust local mocks (`MockScenarioStorage`, `MockClassAsset`) ensuring test isolation.
- **Error Handling**: Renamed internal `InventoryError` to `RelationshipError` in `InventoryRelationshipService` to avoid shadowing.

### Fixed
- **Compilation**: Resolved all compiler warnings (unused variables, immutability, Sendable conformance).
- **Architecture**: Archived older architecture notes under `docs/archive/` (`INVENTORY_KIT_ARCHITECTURE.md` itself remained until the Unreleased docs cleanup).

## [2.2.0] - 2025-12-22

### Added
- **New Metadata Types**:
  - `SourceCode`: Encapsulates URL and notes for source code references.
  - `Contact`: Structured contact info (email, social media, role).
  - `Address`: Structured physical address support with image references.
- **ReferenceManufacturer Updates**:
  - Added support for `images`, `addresses`, `associatedPeople`, `developers` (using `Contact` and `Address`).
- **Questionnaires**:
  - Added `PhysicalSoftwareQuestionnaire`, `HardwareQuestionnaire`, `DigitalSoftwareQuestionnaire` and others with localized attribute generation.
  - Added `AssetQuestionnaireTests` covering tag generation logic.

### Changed
- **Protocol Refactoring**:
  - `ReferenceProduct` now uses `SourceCode` struct instead of separate `sourceCodeUrl`/`sourceCodeNotes` properties.
  - `MockReferenceProduct` and `MockProduct` updated to conform to new protocols.
- **Test Suite**:
  - Consolidated and fixed compilation errors in `InventoryCoreTests`.
  - Added `MetadataTypesTests` to ensure coverage of new structs.

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

