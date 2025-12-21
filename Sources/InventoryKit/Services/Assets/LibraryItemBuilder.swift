import Foundation
import InventoryCore

/// Builder for creating public inventory items (Library/Catalog Products).
public class LibraryItemBuilder {
    private var id: UUID
    private var title: String
    private var platform: String?
    private var publisher: String?
    private var releaseDate: Date?
    private var tags: [String] = []
    
    public init(title: String) {
        self.id = UUID()
        self.title = title
    }
    
    public func setID(_ id: UUID) -> Self {
        self.id = id
        return self
    }
    
    public func setPlatform(_ platform: String) -> Self {
        self.platform = platform
        return self
    }
    
    public func setPublisher(_ publisher: String) -> Self {
        self.publisher = publisher
        return self
    }
    
    public func setReleaseDate(_ date: Date) -> Self {
        self.releaseDate = date
        return self
    }
    
    public func addTag(_ tag: String) -> Self {
        self.tags.append(tag)
        return self
    }
    
    public func build() -> any InventoryAsset {
        // Mapping typical Product fields to Asset fields for unified protocol
        return PublicAssetImpl(
            id: id,
            name: title,
            type: "product", // implicit type
            tags: tags,
            metadata: [
                "platform": platform ?? "",
                "publisher": publisher ?? ""
            ]
        )
    }
}

// Private concrete implementation
private struct PublicAssetImpl: InventoryAsset {
    var id: UUID
    var name: String
    var type: String?
    var tags: [String]
    var metadata: [String : String]
    
    // Defaults
    var custodyLocation: String? = "Public Library"
    var acquisitionSource: String? = nil
    var acquisitionDate: Date? = nil
    var identifiers: [any InventoryIdentifier] = []
    var productID: UUID? = nil // A product is its own product? or nil?
    var provenance: String? = nil
    var condition: String? = "Digital Reference"
    var forensicClassification: String? = nil
    var relationshipType: AssetRelationshipType? = nil
    
    var source: (any InventorySource)? = nil
    var lifecycle: (any InventoryLifecycle)? = nil
    var health: (any InventoryHealth)? = nil
    var mro: (any InventoryMROInfo)? = nil
    var copyright: (any CopyrightInfo)? = nil
    var components: [any InventoryComponentLink] = []
    var relationshipRequirements: [any InventoryRelationshipRequirement] = []
    var linkedAssets: [any InventoryLinkedAsset] = []
}
