# InventoryKit

InventoryKit is a Swift Package Manager (SPM) library for modeling, validating, and persisting complex asset inventories (e.g., vintage computers, automotive parts). It provides a YAML/JSON-backed schema, relationship modeling, high-volume catalog indexing, pagination, and pluggable storage so apps can manage hundreds of thousands of assets safely.

## Features

- **Protocol-First Architecture**: Core definitions (`InventoryCore`) are separated from concrete implementations (`InventoryKit`), enabling a flexible, modular design.
- **Rich Models**: Schema-versioned `InventoryDocument` with assets, lifecycle, MRO, health, embedded components, and relationship requirements.
- **Relationship + Compatibility Checks**: Define relationships via `InventoryRelationshipRequirementProtocol` and evaluate compliance (e.g., peripherals required for a computer).
- **Storage Abstractions**: Use `InventoryStorageProvider` to plug in any backend (CloudKit, Databases, FileSystemKit).
- **Transformers**: Default YAML/JSON transformers built on Yams + JSONEncoder.
- **High-Volume Catalog**: `InventoryCatalog` actor indexes assets, supports identifier lookup, and paginated queries.
- **Tag Registry System**: Domain-based tag registration with code execution support.
- **SDK Entry Point**: `InventoryService` bootstraps provider + catalog with configurable logging.
- **CI + Tests**: Validated with >90% code coverage.

## Platform Support

InventoryKit targets Swift 6 toolchains and is validated on:

- **macOS** (Xcode toolchain, macOS 13+)
- **Linux** (swift.org toolchains, Ubuntu 22.04+ via CI)

Because the package only depends on Foundation and Yams, it can be embedded in server-side Swift services or Apple-platform apps alike.

## Quick Start

```swift
import InventoryKit

// Implement a storage provider (e.g., using FileSystemKit for file operations)
struct MyStorageProvider: InventoryStorageProvider {
    let identifier = "my-provider"
    let transformer = InventoryKit.transformer(for: .yaml)
    
    // Vendor support is optional, defaults to nil/unsupported
    
    func loadInventory(validatingAgainst version: InventorySchemaVersion) async throws -> any InventoryDocumentProtocol {
        // Use FileSystemKit to read file data
        let data = try await FileSystemKit.readData(from: self.url)
        return try transformer.decode(data, validatingAgainst: version)
    }
    
    func saveInventory(_ document: any InventoryDocumentProtocol) async throws {
        // Use FileSystemKit to write file data
        let data = try transformer.encode(document)
        try await FileSystemKit.writeData(data, to: self.url)
    }
}

let provider = MyStorageProvider()
let configuration = InventoryConfiguration(
    provider: provider,
    schemaVersion: .current,
    logLevel: .info
)

let service = try await InventoryService.bootstrap(configuration: configuration)

let newAsset = AnyInventoryAsset(name: "IBM PC/AT")
await service.catalog.upsert(newAsset)
try await service.persistChanges()

let page = await service.listAssets(page: InventoryPageRequest(offset: 0, limit: 20))
print("Loaded \(page.items.count) assets (total \(page.total))")
```

### Integrating a Custom Storage Provider

Implement the `InventoryStorageProvider` protocol inside your app or backend. For example, a CloudKit provider would:

1. Fetch CloudKit records and build an `InventoryDocument`.
2. Use `transformer.decode/encode` for YAML/JSON serialization if storing blobs.
3. Return its identifier and transformer so InventoryKit can log and encode consistently.

```swift
struct CloudKitInventoryProvider: InventoryStorageProvider {
    let identifier = "cloudkit-provider"
    let transformer = InventoryKit.transformer(for: .json)

    func loadInventory(validatingAgainst version: InventorySchemaVersion) async throws -> any InventoryDocumentProtocol {
        let data = try await fetchDataFromCloudKit()
        return try transformer.decode(data, validatingAgainst: version)
    }

    func saveInventory(_ document: any InventoryDocumentProtocol) async throws {
        let data = try transformer.encode(document)
        try await saveDataToCloudKit(data)
    }

    func replaceInventory(with document: any InventoryDocumentProtocol) async throws {
        try await saveInventory(document)
    }
}
```

Pass your provider into `InventoryConfiguration` to bootstrap `InventoryService`.

## Tag Registry System

InventoryKit provides a tag registry system that enables domain-specific tag resolution through code execution handlers. This allows clients to register custom tags that execute code when encountered, enabling powerful tag-based processing workflows.

### Basic Usage

```swift
import InventoryKit

// Create a service (tag registry is automatically created if not provided)
let service = try await InventoryService.bootstrap(configuration: configuration)

// Access the tag registry
let registry = service.tagRegistry

// Register a tag with a code execution handler
try await registry.register(tag: "dsk", domain: "retroboxfs") { tag in
    return "AppleDiskImage" // Returns type identifier
}

// Check if a tag is registered
let isRegistered = try await registry.isRegistered(tag: "dsk", domain: "retroboxfs")
print(isRegistered) // true

// Execute handler when tag is encountered
if let result = try await registry.execute(tag: "dsk", domain: "retroboxfs") {
    print("Resolved type: \(result)") // "AppleDiskImage"
}

// Get all tags for a domain
let tags = try await registry.tags(for: "retroboxfs")
print(tags) // ["dsk", "woz", "a2r", ...]

// Resolve tag to domain
if let domain = try await registry.domain(for: "dsk") {
    print("Domain: \(domain)") // "retroboxfs"
}
```

### Domain Organization

Tags are organized by domain, allowing multiple clients to register tags without conflicts:

```swift
// Register tags for different domains
try await registry.register(tag: "dsk", domain: "retroboxfs") { _ in "AppleDiskImage" }
try await registry.register(tag: "verified", domain: "acme") { _ in "true" }

// Tags with the same name can exist in different domains
let retroboxfsTags = try await registry.tags(for: "retroboxfs")
let acmeTags = try await registry.tags(for: "acme")
```

### Custom Tag Registry

You can provide a custom tag registry implementation:

```swift
struct CustomTagRegistry: InventoryTagRegistry {
    // Implement protocol methods
    // ...
}

let customRegistry = CustomTagRegistry()
let configuration = InventoryConfiguration(
    provider: provider,
    tagRegistry: customRegistry
)
let service = try await InventoryService.bootstrap(configuration: configuration)
```

### Integration with RetroboxFS

The tag registry system is designed to work with RetroboxFS for disk image type resolution:

```swift
// RetroboxFS registers tags during disk image processing
// Tags are stored in InventoryAsset.tags

// Later, RetroboxFS can resolve tags to internal types
let asset = await service.asset(identifierType: .uuid, value: assetID)
if let asset = asset {
    for tag in asset.tags {
        if let resolvedType = try await registry.execute(tag: tag, domain: "retroboxfs") {
            print("Tag \(tag) resolved to: \(resolvedType)")
        }
    }
}
```

### Thread Safety

The default `DefaultTagRegistry` implementation uses Swift actors for thread-safe operations. All tag registry operations are safe for concurrent access.

## Testing

Run the full suite via:

```bash
swift test
```

CI enforces the same command on GitHub Actions (macOS runners) for every push and pull request to `main`.

## Versioning Strategy

InventoryKit follows **Semantic Versioning (SemVer)** for the library API:

- **MAJOR**: breaking API changes.
+- **MINOR**: backwards-compatible feature additions.
- **PATCH**: backwards-compatible bug fixes.

Schema evolution is tracked separately via `InventorySchemaVersion`. Each release documents both the package version and the current schema version. When introducing schema changes:

1. Bump `InventorySchemaVersion.current`.
2. Provide migration helpers or validation logic.
3. Publish release notes explaining schema compatibility expectations.

Recommended release workflow:

1. Update `Package.swift` (if needed) and documentation for the new version.
2. Tag the commit `vMAJOR.MINOR.PATCH`.
3. Publish release notes summarizing API + schema changes.

## Roadmap

- Ship additional storage providers (CloudKit, SQLite).
- Publish DocC documentation with schema samples.
- Bundle JSON/YAML schema definitions for validation tooling.

Contributions and feedback are welcome—please open issues or pull requests!
