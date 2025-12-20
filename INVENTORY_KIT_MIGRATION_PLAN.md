# InventoryKit Migration & Unification Plan

## Objective
Migrate core catalog services (Products, Vendors, Deltas) from `RetroInventoryKit` to `InventoryKit` to create a unified core service that manages both **User Assets** (Inventory) and **Public Catalog Data** (Products).

## Current State
*   **InventoryKit**: Manages user-specific `InventoryAsset` data via `InventoryService` and `InventoryStorageProvider`.
*   **RetroInventoryKit**: Manages public `InventoryProduct` data via `CatalogStorageProvider`, `CatalogDeltaManager`, and Protocol Buffers.

## Target Architecture
*   **InventoryKit (Package)**:
    *   **InventoryCore (Module)**: Use standard protocols for both Inventory (Assets) and Catalog (Products/Vendors).
    *   **InventoryKit (Module)**: `InventoryService` orchestrates both user inventory and public catalog operations.
*   **RetroInventoryKit (Package)**:
    *   Becomes a client-specific implementation layer (e.g., providing Retro-specific catalog data via CloudKit or Protobuf).
    *   Conforms to `InventoryKit` protocols.

## Migration Steps

### Phase 1: Move Core Protocols & Models (InventoryCore)
- [x] Move `InventoryProduct` to `InventoryCore`.
- [x] Move `InventoryProductCatalog` to `InventoryCore`.
- [x] Move `InventoryCatalogVendor` to `InventoryCore`.
- [x] Move `CatalogDelta` and `CatalogBundle` to `InventoryCore`.
- [x] Move `CatalogStorageProvider` protocol to `InventoryCore` (renamed to `InventoryCatalogStorageProvider`).

### Phase 2: Move Service Logic (InventoryKit)
- [x] Move `CatalogDeltaManager` logic to `InventoryKit` (implemented as `CatalogSyncService`).
- [x] Update `InventoryConfiguration` to support a `ProductCatalogStorageProvider`.
- [x] Update `InventoryService` to hold a reference to the product catalog service/provider.

### Phase 3: Update Clients
- [ ] Refactor `RetroInventoryKit` to use the new `InventoryKit` types and protocols.
- [ ] Ensure `RetroboxIntegration` uses the unified `InventoryService`.

## Detailed Task List

### 1. Unified Storage Protocols
Refactor `CatalogStorageProvider` into `InventoryKit` context.
*   **Proposed Name**: `InventoryCatalogStorageProvider`
*   **Location**: `InventoryCore/Storage/InventoryCatalogStorageProvider.swift`
*   **Role**: Handles CRUD for `InventoryProduct`, `InventoryCatalogVendor`, and delta/sync operations.

### 2. Service Integration
Extend `InventoryService` to support catalog operations.
*   Add `catalogProvider` to `InventoryConfiguration`.
*   Expose `productCatalog` (manager) alongside `assetCatalog` (user inventory).

### 3. Delta Management
Move `CatalogDeltaManager` to `InventoryKit`.
*   It should be generic enough to handle any `InventoryCatalogStorageProvider`.

## Naming Conventions
*   **User Data**: `InventoryAccount` (or similar, existing `InventoryAsset` context).
*   **Public Data**: `InventoryCatalog` (Products, Vendors).
