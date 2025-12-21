import Foundation
import InventoryCore

public struct MockContext: InventoryContext, Sendable {
    public let storage: any StorageProvider
    public let assetFactory: any InventoryAssetFactory
    
    public init(
        storage: any StorageProvider = MockStorageProvider(),
        assetFactory: any InventoryAssetFactory = MockAssetFactory()
    ) {
        self.storage = storage
        self.assetFactory = assetFactory
    }
}

public struct MockAssetFactory: InventoryAssetFactory, Sendable {
    public init() {}
    
    public func createAsset(id: UUID, name: String, provenance: String, tags: [String]) -> any InventoryAsset {
        return MockAsset(
            id: id,
            name: name,
            tags: tags,
            provenance: provenance
        )
    }
}
