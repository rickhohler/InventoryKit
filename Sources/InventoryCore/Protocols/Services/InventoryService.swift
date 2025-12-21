import Foundation

/// Primary interface for interacting with the Inventory System.
/// Handles CRUD operations for Assets, Products, and Collections.
public protocol InventoryService: Sendable {
    
    // MARK: - Asset Management
    
    /// Retrieve an asset by its UUID.
    func asset(for id: UUID) async throws -> (any InventoryAsset)?
    
    /// Retrieve assets matching a specific Product ID.
    func assets(forProductID productID: UUID) async throws -> [any InventoryAsset]
    
    /// Retrieve all assets in a specific Collection.
    func assets(inCollection collectionID: UUID) async throws -> [any InventoryAsset]
    
    /// Save or update an asset.
    /// - Parameter asset: The asset to save (must be a concrete type known to the implementation, or adaptable).
    func save(_ asset: any InventoryAsset) async throws
    
    /// Delete an asset.
    func deleteAsset(id: UUID) async throws
    
    // MARK: - Product Management
    
    /// Retrieve a product by its UUID.
    func product(for id: UUID) async throws -> (any InventoryProduct)?
    
    /// Retrieve a product by its IRN string (Universal Lookup).
    func product(for irn: InventoryResourceName) async throws -> (any InventoryProduct)?
    
    /// Search for products.
    func searchProducts(query: String) async throws -> [any InventoryProduct]
    
    // MARK: - Collection Management
    
    /// Retrieve a collection by ID.
    func collection(for id: UUID) async throws -> (any InventoryCollection)?
    
    /// List all collections.
    func collections() async throws -> [any InventoryCollection]
}
