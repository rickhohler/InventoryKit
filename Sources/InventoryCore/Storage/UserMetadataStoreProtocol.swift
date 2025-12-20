import Foundation

/// Protocol for the "User Metadata Store" (Private Realm).
/// Handles persistence for User Assets and Personal Collections.
public protocol UserMetadataStoreProtocol: Sendable {
    
    // MARK: - Assets
    func fetchAssets(matching query: StorageQuery) async throws -> [any InventoryAssetProtocol]
    func retrieveAsset(id: UUID) async throws -> (any InventoryAssetProtocol)?
    func saveAsset(_ asset: any InventoryAssetProtocol) async throws
    func deleteAsset(id: UUID) async throws
    
    // MARK: - Personal Collections
    func fetchPersonalCollections(matching query: StorageQuery) async throws -> [any InventoryCollectionProtocol]
    func saveCollection(_ collection: any InventoryCollectionProtocol) async throws
    func deleteCollection(id: UUID) async throws
    
    // MARK: - Transaction
    func performBatch(operations: @escaping @Sendable () async throws -> Void) async throws
}
