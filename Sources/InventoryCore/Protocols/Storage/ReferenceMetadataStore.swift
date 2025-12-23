import Foundation
import InventoryTypes

/// Protocol for the Reference Library Metadata Store.
/// Manages "Authority Records" (Products, Manufacturers, Reference Collections).
public protocol ReferenceMetadataStore: Sendable {
    
    // MARK: - Products
    func fetchProducts(matching query: StorageQuery) async throws -> [any Product]
    func retrieveProduct(id: UUID) async throws -> (any Product)?
    func saveProduct(_ product: any Product) async throws // Used by Sync Service
    
    // MARK: - Public Collections
    func fetchPublicCollections(matching query: StorageQuery) async throws -> [any Collection]
    func saveCollection(_ collection: any Collection) async throws // Used by Sync Service
}
