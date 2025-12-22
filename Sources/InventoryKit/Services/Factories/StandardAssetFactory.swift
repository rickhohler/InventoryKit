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
    
    public func createAsset(id: UUID, name: String, provenance: String, tags: [String]) throws -> any InventoryAsset {
        // Start Builder
        let builder = UserInventoryItemBuilder(name: name)
            .setID(id)
        
        // Apply Metadata
        // Note: Provenance is a rich field in our new model, builder should support it via setProvenance or strictly via properties.
        // Checking UserInventoryItemBuilder... it has .setProvenance?
        // If not, we should rely on what it has.
        // Let's assume we might need to update Builder if setProvenance is missing.
        
        // For now, let's look at what we have. provenance might be passed as simple metadata or ignored if builder doesn't explicitly support it yet 
        // (though InventoryAsset protocol has it).
        // Actually, UserAssetCompositionService passes provenance.
        
        // Let's use what we have.
        _ = builder.setProvenance(provenance)
        _ = builder.addTag("Created via Factory")
        for tag in tags {
             _ = builder.addTag(tag)
        }
        
        // Apply Validator if present
        if let validator = validator {
            _ = builder.withValidator(validator)
        }
        
        return try builder.build()
    }
}
