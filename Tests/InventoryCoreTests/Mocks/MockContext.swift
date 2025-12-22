import Foundation
import InventoryCore

public struct MockContext: InventoryContext, Sendable {
    public let storage: any StorageProvider
    public let assetFactory: any InventoryAssetFactory
    
    public let configurator: any InventoryConfigurator
    
    public init(
        storage: any StorageProvider = MockStorageProvider(),
        assetFactory: any InventoryAssetFactory = MockAssetFactory(),
        configurator: any InventoryConfigurator = MockInventoryConfigurator()
    ) {
        self.storage = storage
        self.assetFactory = assetFactory
        self.configurator = configurator
    }
}

public struct MockAssetFactory: InventoryAssetFactory, Sendable {
    public init() {}
    
    public func createAsset(id: UUID, name: String, provenance: String, tags: [String], metadata: [String: String]) throws -> any InventoryAsset {
        return MockAsset(
            id: id,
            name: name,
            tags: tags,
            provenance: provenance
        )
    }
}
