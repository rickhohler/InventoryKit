import Foundation

/// Protocol for the "Domain Metadata Store" (Public Realm).
/// Handles persistence for Public Products and Public Collections in the Public Domain.
/// Typically read-only for the client application (updated via Sync).
public protocol DomainMetadataStore: Sendable {
    
    // MARK: - Products
    func fetchProducts(matching query: StorageQuery) async throws -> [any InventoryProduct]
    func retrieveProduct(id: UUID) async throws -> (any InventoryProduct)?
    func saveProduct(_ product: any InventoryProduct) async throws // Used by Sync Service
    
    // MARK: - Public Collections
    func fetchPublicCollections(matching query: StorageQuery) async throws -> [any InventoryCollection]
    func saveCollection(_ collection: any InventoryCollection) async throws // Used by Sync Service
}
