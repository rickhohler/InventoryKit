import Foundation
import InventoryCore

/// Standard implementation of InventoryAssetFactory.
/// Uses the UserInventoryItemBuilder to construct assets, ensuring validation rules are applied.
public struct StandardAssetFactory: InventoryAssetFactory {
    
    // Optional strategy to apply to all assets created by this factory
    private let validator: (any InventoryValidationStrategy)?
    
    public init(validator: (any InventoryValidationStrategy)? = nil) {
        self.validator = validator
    }
    
    public func createAsset(id: UUID, name: String, provenance: String, tags: [String], metadata: [String: String]) throws -> any InventoryAsset {
        // Start Builder
        let builder = UserInventoryItemBuilder(name: name)
            .setID(id)
        
        // Apply Metadata
        _ = builder.setProvenance(provenance)
        _ = builder.addTag("Created via Factory")
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
}
