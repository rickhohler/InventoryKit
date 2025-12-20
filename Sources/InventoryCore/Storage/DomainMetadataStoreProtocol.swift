import Foundation

/// Protocol for the "Domain Metadata Store" (Public Realm).
/// Handles persistence for Public Products and Public Collections in the Public Domain.
/// Typically read-only for the client application (updated via Sync).
public protocol DomainMetadataStoreProtocol: Sendable {
    
    // MARK: - Products
    func fetchProducts(matching query: StorageQuery) async throws -> [any InventoryProductProtocol]
    func retrieveProduct(id: UUID) async throws -> (any InventoryProductProtocol)?
    func saveProduct(_ product: any InventoryProductProtocol) async throws // Used by Sync Service
    
    // MARK: - Public Collections
    func fetchPublicCollections(matching query: StorageQuery) async throws -> [any InventoryCollectionProtocol]
    func saveCollection(_ collection: any InventoryCollectionProtocol) async throws // Used by Sync Service
}
