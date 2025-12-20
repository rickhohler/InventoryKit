# InventoryKit Migration Plan (v1.x -> v2.0)

This document outlines the changes required to migrate consumer code from InventoryKit v1.x to the v2.0 Protocol-First architecture.

## 1. Import Changes

Code that references base definitions or protocols should now import `InventoryCore`. High-level services remain in `InventoryKit`.

| Old Import | New Import (Definitions) | New Import (Services/Concrete) |
| :--- | :--- | :--- |
| `import InventoryKit` | `import InventoryCore` | `import InventoryKit` |

**Action**: Check your file headers. If you only look at `InventoryAssetProtocol` or `InventoryIdentifier`, you might only need `InventoryCore`. If you instantiate `InventoryService`, keep `InventoryKit`.

## 2. Type Changes

Concrete types in v1.x are now predominantly Protocols in `InventoryCore` or struct implementations in `InventoryKit`.

| v1.x Type | v2.0 Protocol (Core) | v2.0 Concrete (Kit) |
| :--- | :--- | :--- |
| `InventoryAsset` (Class) | `InventoryAssetProtocol` | `InventoryAsset` (Struct) |
| `InventoryDocument` | `InventoryDocumentProtocol` | `InventoryDocument` |
| `InventoryRelationship` | `InventoryRelationshipRequirementProtocol` | `InventoryRelationshipRequirement` |
| `InventoryCollection` | `InventoryCollectionProtocol` | (Various internal structs) |

**Action**: Update function signatures to accept `any InventoryAssetProtocol` instead of `InventoryAsset` where possible to support polymorphism.

## 3. ULID Migration

`InventoryULID` has been moved to `DesignAlgorithmsKit` as `ULID`.

*   **Old**: `InventoryKit.InventoryULID`
*   **New**: `DesignAlgorithmsKit.ULID`
*   **Compatibility**: `InventoryKit` exposes a typealias `public typealias InventoryULID = DesignAlgorithmsKit.ULID`, so mostly source compatible, but you may see "Ambiguous Type" errors if importing both.

**Action**: Prefer using `ULID` from DAK directly if possible.

## 4. Relationship Requirements

The modeling of relationships has changed to be more expressive.

*   **Old**: Simple list of relationship strings.
*   **New**: `InventoryRelationshipRequirementProtocol` defining `typeID`, `compatibleAssetIDs`, `required` status, etc.

**Action**: Review how you define or check asset compatibility. Use `InventoryService.evaluateRelationships(for:)` which returns a standardized `InventoryRelationshipEvaluation`.

## 5. Storage Providers

`InventoryStorageProvider` signatures have updated to return protocols.

*   **Old**: `func load() -> InventoryDocument`
*   **New**: `func load() -> any InventoryDocumentProtocol`

**Action**: Update your custom storage provider implementations to match the new protocol signatures. Use `as? InventoryDocument` if you specifically need the concrete struct features.

## 6. Initialization

`InventoryService` bootstrap remains largely the same, but configuration objects might expect protocols.

```swift
// v2.0
let service = try await InventoryService.bootstrap(configuration: config)
// The service now strictly relies on the provider returning a compliant document protocol.
```
