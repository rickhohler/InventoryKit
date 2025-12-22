# InventoryKit Client Integration Guide

InventoryKit is designed as a **Logic & Definitions Layer**. It defines *what* an inventory item is, but relies on the Client Application (e.g., RetroData) to define *how* it is stored and structured.

To successfully integrate InventoryKit, the client application must supply three core components:

## 1. Concrete Type Implementations

The client must provide concrete implementations for the core protocols. These types act as the **Storage Models**. They can be simple structs, Core Data `NSManagedObjects`, SwiftData `@Model` classes, or CloudKit record wrappers.

**Required Protocols:**
- `InventoryManufacturer`
- `InventoryProduct`
- `InventorySystemRequirements`
- `InventoryAddress`
- `InventoryContact`
- `InventorySourceCode`

**Contract:**
- Types must conform to `Codable`, `Sendable`, `Identifiable`.
- Properties `must` be mutable (`var { get set }`) to allow InventoryKit services to populate them.

## 2. InventoryConfigurator Implementation

The client must provide an implementation of the `InventoryConfigurator` protocol. This serves as the **Bridge** between InventoryKit's logic and the Client's storage types.

**Why?**
InventoryKit Services (like `EnrichmentService` or `ImportService`) do not know how to instantiate your specific `CoreData` objects. Instead, you create the object (or provide an existing one), and pass it to the service, which uses your `Configurator` to fill in the details.

**Example Implementation:**
```swift
struct MyAppConfigurator: InventoryConfigurator {
    func configure<T: InventorySystemRequirements>(_ instance: inout T, minMemory: Int64?, ...) {
        // Populate the instance properties
        instance.minMemory = minMemory
        // ...
    }
}
```

## 3. Storage Provider (Implicit)

InventoryKit is **Persistence Agnostic**. It does not fetch or save data to a database.
- **Client Responsibility**: Fetching object (e.g. `context.fetch(...)`), Saving changes (`context.save()`), and managing the object lifecycle.
- **InventoryKit Responsibility**: analyzing data and calling `configurator.configure(&object)` to update its in-memory state.

## 4. Storage Provider (Optional)

If the client application wants `InventoryService` to manage persistence fully (e.g., for syncing or automated management), it must provide a `StorageProvider`.

**Protocol:** `StorageProvider`
- **Container**: Acts as a factory for specific stores.
- **Components**:
  - `userMetadata`: `UserMetadataStore` (Private DB / Core Data)
  - `domainMetadata`: `DomainMetadataStore` (Public DB / Read-only Cache)
  - `userData`: `UserDataStore` (Private Files)
  - `domainData`: `DomainDataStore` (Public Files)

**When to Implement:**
- Only required if you want `InventoryKit` to handle high-level "Save Asset" operations that internally route to the correct store.
- **Most Clients**: Will just use `InventoryConfigurator` to populate their own objects and manage their own persistence context (e.g. `viewContext.save()`).

## 5. ID Strategy
InventoryKit recommends extracting **UUIDs** for portability.
- **Internal IDs**: Core Data/CloudKit manage their own internal IDs.
- **Domain IDs**: Client types must handle the `id: UUID` property defined in protocols.
- **Recommendation**: Use **UUIDv5** (Deterministic UUIDs) for Reference Data to prevent duplicates across imports.

## 6. Reference Implementation
For a complete, working example of how to implement a Client Integration (Configurator + Types + ID Generation), please see the **Unit Test Scenario**:

- **File**: `InventoryKit/Tests/InventoryCoreTests/Scenarios/ClientIntegrationScenarioTests.swift`
- **Demonstrates**:
  - Defining Client Types (simulated).
  - Implementing `InventoryConfigurator`.
  - Using `InventoryIDGenerator` for deterministic IDs.
  - Populating instances via the Configurator pattern.
