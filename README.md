# InventoryKit

InventoryKit (2.x) is a general, domain-agnostic, **persistence-agnostic** Swift library for modeling inventories of physical and digital items: assets, reference products and manufacturers, collections, locations and containers, identifiers and tags. It provides protocols, small value types and stateless services; the client owns the concrete model types and their storage and plugs them in through a `Configurator` and a `StorageProvider`. Clients can also use only the protocols and value types and keep their own persistence. It depends only on DesignAlgorithmsKit.

## Products and modules

| Product / target | Contents |
| :--- | :--- |
| `InventoryTypes` | Model protocols (`InventoryAsset`, `InventoryItem`, `Product`, `Manufacturer`, `Collection`, `Space`, `ItemContainer`, ...), value types (`SchemaVersion`, `IdentifierModel`, `InventoryResourceName`, `InventoryBuilding`, `InventoryRoom`, `InventoryDigitalVolume`, `ItemContainerPhysical`/`Digital`), enums (`IdentifierType`, `ItemClassifierType`, `MediaFormatType`, `PackageContentsType`, `TagType`), localization (`InventoryLocalizedString`, en/es/fr tables) |
| `InventoryCore` | Storage contracts (`StorageProvider`, repositories, `Transaction`, `StorageQuery`, `InventoryStorageProvider`), service protocols (`TransactionService`, `RelationshipService`, `InventoryLocationService`, `InventoryTagRegistry`, `ReferenceSyncService`), stateless services (questionnaires, formatting, suggestions, validation, pipeline stages, system-requirements enrichment, `InventoryIDGenerator`, `UserAssetCompositionService`), `InventoryError` |
| `InventoryKit` | Entry point `InventoryKit(storage:configurator:)` and its `InventoryServices` facade, builders (`UserInventoryItemBuilder`, `ReferenceProductBuilder`, `ReferenceManufacturerBuilder`), `InventoryTransactionService`, `InventoryRelationshipService`, `DefaultLocationService`, `InventoryImportService`, `StandardAssetRepository`, standard validators |

## What it does (and does not do)

Capabilities:

- **schema-versioning**: semver `SchemaVersion`, major-version compatibility, string Codable form.
- **inventory-identifiers**: `IdentifierType` (including `uuid`) / `IdentifierModel`, `RawIdentifier` (any kind as a string, legacy `serialNumber` mapped), Inventory Resource Names (`inventory:<partition>:<service>:<namespace>:<type>:<id>`), deterministic UUIDv5 reference IDs, `InventoryULID`.
- **item-classification**: classifier categories, media formats, package contents, platforms, relationship and collection categories.
- **tag-taxonomy**: namespaced tag vocabulary (`condition:`, `format:`, `state:`, `region:`, ...) the `InventoryTagRegistry` contract, its default implementation `InMemoryTagRegistry`, and `TagHandlerDispatcher` for running handlers per tag.
- **localization**: client override first, then the bundled en/es/fr tables.
- **locations-and-containers**: building/room/volume models, containers, geolocation resolution, move inference.
- **inventory-model-values**: Codable value types clients can persist directly: `ComponentLinkModel`, `LinkedAsset`, `CopyrightInfoModel` (with `extract(from:)` for notices like "© 1983 Broderbund Software" and `createTags()`), `RawIdentifier`.
- **storage-contracts**: the protocols a client implements and their default behavior.
- **asset-builders**: fluent builders, validation strategies, `StandardAssetRepository`.
- **questionnaires**: answers to tags and attributes.
- **data-quality-services**: formatting, suggestions, validators, pipeline stages, enrichment.
- **asset-relationships**: compliance evaluation, link/unlink, candidate search.
- **inventory-entry-point**: `InventoryKit`, the services facade, ingest/import/composition services.

InventoryKit does **not** ship: a persistence layer or storage provider, a catalog/paging API, YAML or JSON document transformers (only the `InventoryDataTransformer` protocol and `AnyInventoryDataTransformer`),. Earlier README text describing `InventoryService.bootstrap`, `InventoryCatalog`, `InventoryConfiguration` and `DefaultTagRegistry` referred to 1.x APIs that no longer exist.

## Quick start

```swift
import InventoryTypes
import InventoryCore
import InventoryKit

// Your app supplies these: a StorageProvider (repositories, stores, transactions)
// and a Configurator that writes values into your concrete model types.
let kit = InventoryKit(storage: myStorage, configurator: myConfigurator)

// Ingest through the facade (runs inside storage.performTransaction).
let id = try await kit.services.transactions.ingestAsset(
    AssetImportData(name: "Apple IIe", manufacturerName: "Apple Computer", type: "computer")
)

// Or build an opaque asset value directly.
let asset = try UserInventoryItemBuilder(name: "Karateka (boxed)")
    .setType("software")
    .applyQuestionnaire(PhysicalSoftwareQuestionnaire(hasBox: true, hasManual: true))
    .build()
```

See `Tests/InventoryCoreTests/Scenarios/ClientIntegrationScenarioTests.swift` for a complete client integration (concrete types, Configurator, deterministic IDs).

## Platforms

macOS 12, iOS 15, tvOS 15, watchOS 8 (from `Package.swift`), Swift tools 6.0. CI runs `swift build` and `swift test` on macOS only; Linux is not verified.

## Dependencies

| Dependency | How referenced | Used by |
| :--- | :--- | :--- |
| DesignAlgorithmsKit | URL `https://github.com/nibbleware/DesignAlgorithmsKit.git`, `from: "1.12.0"` | all targets (`ThreadSafeSingleton`, `Facade`, `AsyncDataPipelineStage`, `UUIDv5Generator`, `ULID`) |

DesignAlgorithmsKit is the only dependency; `Package.resolved` pins it by version.

Resolved tree (`swift package show-dependencies`):

```
InventoryKit
└── DesignAlgorithmsKit 1.12.0
```

There are no `path:` dependencies, so this package builds on its own; sibling checkouts are not required. Consumers that reference InventoryKit by path and by URL at the same time get SwiftPM "Conflicting identity" warnings.

## Build and test

```sh
swift build
swift test
```

Tests: `InventoryCoreTests` (unit tests for InventoryTypes/InventoryCore, depends only on those two modules) and `InventoryKitTests` (InventoryKit services, builders and scenarios).

## Known issues

None tracked. Since 3.0 the library holds no retro-computing content: platform identifiers are RetroCore's `RetroPlatformID`, Apple II system requirements are RetroStorageApple's `AppleIISystemRequirementsStrategy`, and retro name tables are RetroData's `RetroDataNameTables` (pass them to `NameCorrectionStrategy(corrections:)` and `ReferenceManufacturerLookupStrategy(knownManufacturers:)`).

## Versioning

Semantic Versioning for the library API (tags `vMAJOR.MINOR.PATCH`; latest 3.0.0). The inventory document schema is versioned separately by `SchemaVersion.current` (1.0.0). See [CHANGELOG.md](CHANGELOG.md).

## More

- [docs/INVENTORY_TERMINOLOGY.md](docs/INVENTORY_TERMINOLOGY.md): glossary of the model.
- Localization: define the package's keys (for example `condition.mint`) in your app's `Localizable.strings` to override labels.
