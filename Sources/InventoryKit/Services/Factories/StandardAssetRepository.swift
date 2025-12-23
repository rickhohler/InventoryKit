import Foundation
import InventoryTypes
import InventoryCore

/// Standard implementation of AssetRepository.
/// Uses the UserInventoryItemBuilder to construct assets, ensuring validation rules are applied.
public struct StandardAssetRepository: AssetRepository {
    public typealias Entity = any InventoryAsset
    
    // Optional strategy to apply to all assets created by this repository
    private let validator: (any InventoryValidationStrategy)?
    
    public init(validator: (any InventoryValidationStrategy)? = nil) {
        self.validator = validator
    }
    
    // MARK: - Lifecycle
    
    public func create() async throws -> any InventoryAsset {
        return try createAsset(id: UUID(), name: "New Asset", provenance: nil, tags: [], metadata: [:])
    }
    
    public func save(_ entity: any InventoryAsset) async throws {
        // No-op
    }
    
    public func createAsset(id: UUID, name: String, provenance: String?, tags: [String], metadata: [String: String]) throws -> any InventoryAsset {
        // Start Builder
        let builder = UserInventoryItemBuilder(name: name)
            .setID(id)
        
        // Apply Metadata
        if let provenance {
            _ = builder.setProvenance(provenance)
        }
        _ = builder.addTag("Created via Repository")
        for tag in tags {
             _ = builder.addTag(tag)
        }
        for (key, value) in metadata {
            _ = builder.addMetadata(key, value)
        }
        
        // Apply Validator if present
        if let validator = validator {
            _ = builder.withValidator(validator)
        }
        
        return try builder.build()
    }
    
    public func update(_ entity: any InventoryAsset) async throws {
        // No-op for standard struct-based repo unless connected to backing store
    }
    
    public func delete(id: UUID) async throws {
        // No-op
    }
    
    public func fetch(matching query: StorageQuery) async throws -> [any InventoryAsset] {
        return []
    }
    
    public func retrieve(id: UUID) async throws -> (any InventoryAsset)? {
        return nil
    }
}
