# InventoryKit Architecture

InventoryKit (v2.0+) adopts a **Protocol-First Architecture** to ensure clean separation between domain definitions, concrete implementations, and storage bridges. This architecture is critical for modularity, testability, and avoiding circular dependencies in a complex ecosystem.

## Core Layers

### 1. InventoryCore (The Definition Layer)
*   **Role**: Defines the *What*, not the *How*.
*   **Content**: Pure Protocols, Enums, and Value Types (Structs). No heavy classes or Actors.
*   **Dependencies**: `Foundation` only.
*   **Key Protocols**:
    *   `InventoryAssetProtocol`
    *   `InventoryDocumentProtocol`
    *   `InventoryRelationshipRequirementProtocol`
    *   `InventoryCollectionProtocol`

**Goal**: Allows downstream consumers (like DSLs, analyzers, or lightweight scripts) to import *only* definitions without pulling in the entire persistence and service machinery.

### 2. InventoryKit (The Implementation Layer)
*   **Role**: Provides the *How*. Standard concrete implementations and high-level Services.
*   **Content**:
    *   **Concrete Models**: `InventoryAsset`, `InventoryDocument`, `InventoryRelationshipRequirement` (Structs conforming to Core protocols).
    *   **Services**: `InventoryService`, `InventoryCatalog` (Actors), `LibrarySyncService`.
    *   **Transformers**: JSON/YAML serialization logic.
*   **Dependencies**: `InventoryCore`, `Yams`, `DesignAlgorithmsKit` (for ULID, Hashing).

### 3. Storage Providers (The Bridge Layer)
*   **Role**: Bridges abstract storage to real-world backends.
*   **Interface**: `InventoryStorageProvider` (defined in Core).
*   **Implementations**:
    *   `FileSystemStorageProvider` (likely via `RetroStorageTandy` or similar).
    *   `CloudKitStorageProvider` (Future).
    *   `SQLiteStorageProvider` (Future).

## Key Patterns

### Protocol-Oriented Models
Instead of forcing a single `class InventoryAsset`, the system processes `any InventoryAssetProtocol`. This allows:
*   **Polymorphism**: A `PublicResource` (Archive.org item) and a `UserAsset` (Local file) can both be treated as "Assets" by the Catalog.
*   **Flexibility**: Different storage backends can hydrate lightweight or heavyweight structs as needed.

### Separation of Concerns (Relationships)
Relationships are defined as first-class citizens:
*   `InventoryRelationshipRequirementProtocol`: Defines what an asset *needs* (e.g., "Requires a Monitor").
*   `InventoryComponentLinkProtocol`: Defines what an asset *contains* or references.

### Service Facade
`InventoryService` acts as the primary entry point:
*   Bootstraps the `InventoryCatalog`.
*   Connects `InventoryStorageProvider`.
*   Initializes `LibrarySyncService` (optional).
*   Configures Logging.

## Dependency Graph

```
[Consumers (RetroApp, CLI)]
       |
       v
[InventoryKit (Concrete + Services)]
       |
       v
[InventoryCore (Protocols)]
       ^
       |
[Storage Providers (Impl)]
```

## Migration from v1.x

See `INVENTORY_KIT_MIGRATION_PLAN.md` for details on moving from monolithic implementations to the Protocol-First design.
