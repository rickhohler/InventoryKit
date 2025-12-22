# InventoryKit Service Standards

## Core Philosophy
InventoryKit Services are **stateless logic containers**. They process data but do not own it.
- **Context**: The `InventoryContext` is the "Environment" provided to a service. It is immutable and contains all dependencies.
- **Configurator**: The "Tool" used to write data into concrete types.

## 1. The Service Context (`InventoryContext`)
**Standard**: All Services must accept an `InventoryContext` in their initializer or method signature.
**Purpose**: To provide a unified, testable entry point for all infrastructure dependencies.

```swift
public protocol InventoryContext: Sendable {
    var storage: any StorageProvider { get }          // Access to DB/Files
    var assetFactory: any InventoryAssetFactory { get } // Creating standardized Assets
    var configurator: any InventoryConfigurator { get } // Populating specific Concrete Types
}
```

## 2. The Configurator Pattern
**Standard**: Services **must not** instantiate concrete types (e.g., `RetroSystemRequirements`) directly.
**Usage**:
1. Client creates/fetches the instance (e.g. `let reqs = RetroSystemRequirements()`).
2. Service receives the instance via `inout`.
3. Service calls `context.configurator.configure(&reqs, ...)` to populate it.

**Why?**
This allows the Service to be generic (`<T: InventorySystemRequirements>`) and work with *any* storage backing (CoreData, generic struct, Protobuf) without coupling.

## 3. ID Generation
**Standard**: Use `InventoryIDGenerator` for Reference Data.
**Usage**: `InventoryIDGenerator.generate(for: .manufacturer, name: "Atari")`.
**Benefit**: Deterministic IDs ensure "Atari" is always the same UUID, enabling reliable deduplication across disparate imports.

## 4. Service Pipelines (DAK Integration)
**Standard**: Complex processing flows (Import/Enrichment) should be implemented as `AsyncDataPipeline` stages.
**Components**:
- **FormattingStage**: Normalizes data (e.g. whitespace, capitalization) using `FormattingService`.
- **EnrichmentStage**: Augments data (e.g. database lookups) using `SuggestionService`.
- **ValidationStage**: Verifies integrity using `ValidationService`.
**Flow**: `Raw Input` -> `Formatting` -> `Enrichment` -> `Validation` -> `Persisted Entity`.
