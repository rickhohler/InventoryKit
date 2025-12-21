import Foundation
import InventoryCore

/// Builder for creating private inventory assets (User Custody).
public class UserInventoryItemBuilder {
    private var id: UUID
    private var name: String
    private var type: String?
    private var location: String?
    private var acquisitionSource: String?
    private var acquisitionDate: Date?
    private var tags: [String] = []
    
    public init(name: String) {
        self.id = UUID()
        self.name = name
    }
    
    public func setID(_ id: UUID) -> Self {
        self.id = id
        return self
    }
    
    public func setType(_ type: String) -> Self {
        self.type = type
        return self
    }
    
    public func setLocation(_ location: String) -> Self {
        self.location = location
        return self
    }
    
    public func setAcquisition(source: String, date: Date?) -> Self {
        self.acquisitionSource = source
        self.acquisitionDate = date
        return self
    }
    
    public func addTag(_ tag: String) -> Self {
        self.tags.append(tag)
        return self
    }
    
    public func build() -> any InventoryAsset {
        // We need a concrete implementation to return.
        // Defining a private struct here to satisfy the requirement
        // that "InventoryKit" only *exposes* pure protocol types (via return).
        
        return PrivateAssetImpl(
            id: id,
            name: name,
            type: type,
            custodyLocation: location,
            acquisitionSource: acquisitionSource,
            acquisitionDate: acquisitionDate,
            tags: tags
        )
    }
}

// Private concrete implementation, hidden from public API
private struct PrivateAssetImpl: InventoryAsset {
    var id: UUID
    var name: String
    var type: String?
    var custodyLocation: String?
    var acquisitionSource: String?
    var acquisitionDate: Date?
    var tags: [String]
    
    // Default/Empty implementations for other protocol requirements
    var identifiers: [any InventoryIdentifier] = []
    var productID: UUID? = nil
    var provenance: String? = nil
    var condition: String? = nil
    var forensicClassification: String? = nil
    var relationshipType: AssetRelationshipType? = nil
    var metadata: [String : String] = [:]
    
    var source: (any InventorySource)? = nil
    var lifecycle: (any InventoryLifecycle)? = nil
    var health: (any InventoryHealth)? = nil
    var mro: (any InventoryMROInfo)? = nil
    var copyright: (any CopyrightInfo)? = nil
    var components: [any InventoryComponentLink] = []
    var relationshipRequirements: [any InventoryRelationshipRequirement] = []
    var linkedAssets: [any InventoryLinkedAsset] = []
}
