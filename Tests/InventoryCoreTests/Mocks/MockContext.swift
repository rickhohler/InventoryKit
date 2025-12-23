import Foundation
import InventoryCore
import InventoryTypes

public struct MockContext: Context, Sendable {
    public let storage: any StorageProvider
    
    public let configurator: any Configurator
    
    public init(
        storage: any StorageProvider = MockStorageProvider(),
        configurator: any Configurator = MockConfigurator()
    ) {
        self.storage = storage
        self.configurator = configurator
    }
}

public struct MockAssetRepository: AssetRepository, Sendable {
    public init() {}
    
    public typealias Entity = any InventoryAsset
    
    public func createAsset(id: UUID, name: String, provenance: String?, tags: [String], metadata: [String: String]) throws -> any InventoryAsset {
        let asset = MockAsset(
            id: id,
            name: name,
            tags: tags,
            metadata: metadata,
            provenance: provenance
        )
        return asset
    }
    
    // EntityRepository Conformance
    public func create() async throws -> Entity {
        MockAsset(name: "Mock Asset")
    }
    
    public func save(_ entity: Entity) async throws {}
    
    public func update(_ entity: Entity) async throws {}
    
    public func delete(id: UUID) async throws {}
    
    public func fetch(matching query: StorageQuery) async throws -> [Entity] { [] }
    
    public func retrieve(id: UUID) async throws -> Entity? { nil }
}
