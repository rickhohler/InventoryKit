# InventoryKit

InventoryKit is a Swift Package Manager (SPM) library for modeling, validating, and persisting complex asset inventories (e.g., vintage computers, automotive parts). It provides a YAML/JSON-backed schema, relationship modeling, high-volume catalog indexing, pagination, and pluggable storage so apps can manage hundreds of thousands of assets safely.

## Features

- **Rich Models**: Schema-versioned `InventoryDocument` with assets, lifecycle, MRO, health, embedded components, and relationship requirements.
- **Relationship + Compatibility Checks**: Define relationship types, link assets, and evaluate compliance (e.g., peripherals required for a computer).
- **Storage Abstractions**: Use `InventoryStorageProvider` to plug in any backend (text files, CloudKit, databases). InventoryKit ships with a thread-safe text-file provider for local/test scenarios.
- **Transformers**: Default YAML/JSON transformers built on Yams + JSONEncoder with hooks for custom encodings.
- **High-Volume Catalog**: `InventoryCatalog` actor indexes assets, supports identifier lookup, component traversal, and paginated queries.
- **SDK Entry Point**: `InventoryService` bootstraps provider + catalog with configurable logging, giving consumers a single initialization path.
- **CI + Tests**: `swift test` coverage plus GitHub Actions on macOS and Linux to guarantee builds on push/PR.

## Platform Support

InventoryKit targets Swift 6 toolchains and is validated on:

- **macOS** (Xcode toolchain, macOS 13+)
- **Linux** (swift.org toolchains, Ubuntu 22.04+ via CI)

Because the package only depends on Foundation and Yams, it can be embedded in server-side Swift services or Apple-platform apps alike.

## Quick Start

```swift
import InventoryKit

let provider = TextFileInventoryStorageProvider(
    url: FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("inventory.yaml")
)

let configuration = InventoryConfiguration(
    provider: provider,
    schemaVersion: .current,
    logLevel: .info
)

let service = try await InventoryKit.service(configuration: configuration)

let newAsset = InventoryAsset(name: "IBM PC/AT")
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

    func loadInventory(validatingAgainst version: InventorySchemaVersion) async throws -> InventoryDocument {
        let data = try await fetchDataFromCloudKit()
        return try transformer.decode(data, validatingAgainst: version)
    }

    func saveInventory(_ document: InventoryDocument) async throws {
        let data = try transformer.encode(document)
        try await saveDataToCloudKit(data)
    }

    func replaceInventory(with document: InventoryDocument) async throws {
        try await saveInventory(document)
    }
}
```

Pass your provider into `InventoryConfiguration` to bootstrap `InventoryService`.

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
