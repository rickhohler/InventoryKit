import Foundation
import InventoryTypes

/// Protocol for the "User Metadata Store" (Private Realm).
/// Handles persistence for User Assets and Personal Collections.
public protocol UserMetadataStore: Sendable {
    
    // MARK: - Assets
    func fetchAssets(matching query: StorageQuery) async throws -> [any InventoryAsset]
    func retrieveAsset(id: UUID) async throws -> (any InventoryAsset)?
    func saveAsset(_ asset: any InventoryAsset) async throws
    func deleteAsset(id: UUID) async throws
    
    // MARK: - Personal Collections
    func fetchPersonalCollections(matching query: StorageQuery) async throws -> [any Collection]
    func saveCollection(_ collection: any Collection) async throws
    func deleteCollection(id: UUID) async throws
    
    // MARK: - Transaction
    func performBatch(operations: @escaping @Sendable () async throws -> Void) async throws
}
