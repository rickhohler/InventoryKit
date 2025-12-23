import Foundation
import InventoryTypes

/// Represents a Unit of Work (Transaction) for performing atomic operations on the Inventory.
/// Clients (Storage Providers) implement this to wrap their context (e.g. NSManagedObjectContext, Database Connection).
public protocol Transaction: Sendable {
    
    // MARK: - Factory (Creation)
    
    /// Creates a new, blank/default instance of an Asset.
    /// The client is responsible for instantiating their concrete type (e.g. UserAsset).
    func createAsset() async throws -> any InventoryAsset
    
    /// Creates a new, blank/default instance of a Reference Manufacturer.
    func createReferenceManufacturer() async throws -> any ReferenceManufacturer
    
    /// Creates a new, blank/default instance of a Reference Product.
    func createReferenceProduct() async throws -> any ReferenceProduct
    
    /// Creates a new, blank/default instance of a Reference Collection.
    func createReferenceCollection() async throws -> any ReferenceCollection
    
    /// Creates a new, blank/default instance of a Contact.
    func createContact() async throws -> any Contact
    
    /// Creates a new, blank/default instance of an Address.
    func createAddress() async throws -> any Address
    
    /// Creates a new, blank/default instance of a Space.
    func createSpace() async throws -> any Space
    
    /// Creates a new, blank/default instance of a Vendor.
    func createVendor() async throws -> any Vendor
    
    // MARK: - Queries (Read)
    
    /// Finds manufacturers matching the query.
    func fetchReferenceManufacturers(matching query: StorageQuery) async throws -> [any ReferenceManufacturer]
    
    /// Retrieve a specific manufacturer by ID.
    func retrieveReferenceManufacturer(id: UUID) async throws -> (any ReferenceManufacturer)?
    
    /// Finds products matching the query.
    func fetchReferenceProducts(matching query: StorageQuery) async throws -> [any ReferenceProduct]
    
    /// Retrieve a specific product by ID.
    func retrieveReferenceProduct(id: UUID) async throws -> (any ReferenceProduct)?
    
    /// Finds assets matching the query.
    func fetchAssets(matching query: StorageQuery) async throws -> [any InventoryAsset]
    
    /// Retrieve a specific asset by ID.
    func retrieveAsset(id: UUID) async throws -> (any InventoryAsset)?
    
    /// Finds collections matching the query.
    func fetchReferenceCollections(matching query: StorageQuery) async throws -> [any ReferenceCollection]
    
    /// Retrieve a specific collection by ID.
    func retrieveReferenceCollection(id: UUID) async throws -> (any ReferenceCollection)?
    
    /// Finds contacts matching the query.
    func fetchContacts(matching query: StorageQuery) async throws -> [any Contact]
    
    /// Retrieve a specific contact by ID.
    func retrieveContact(id: UUID) async throws -> (any Contact)?
    
    /// Finds spaces matching the query.
    func fetchSpaces(matching query: StorageQuery) async throws -> [any Space]
    
    /// Retrieve a specific space by ID.
    func retrieveSpace(id: UUID) async throws -> (any Space)?
    
    /// Finds vendors matching the query.
    func fetchVendors(matching query: StorageQuery) async throws -> [any Vendor]
    
    /// Retrieve a specific vendor by ID.
    func retrieveVendor(id: UUID) async throws -> (any Vendor)?
    
    // MARK: - Persistence (Write)
    
    /// Deletes the object.
    func delete(_ object: any PersistentModel) async throws
    
    /// Explicitly saves the transaction (if manual save is required).
    /// Note: `performTransaction` block usually handles save on success.
    func save() async throws
}

/// Marker protocol for anything that can be persisted/deleted via the Transaction.
/// (Concrete types like UserAsset, ReferenceProduct should conform to this if they want to be deletable).
/// Usually, conformance to `InventoryAsset` implies this if we make `InventoryAsset` inherit from it, or we just typecheck.
public protocol PersistentModel: Sendable, Identifiable {}
