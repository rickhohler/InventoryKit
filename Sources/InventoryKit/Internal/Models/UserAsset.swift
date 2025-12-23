import Foundation
import InventoryTypes
import InventoryCore

internal struct UserAsset: InventoryAsset {
    var id: UUID
    var name: String
    // InventoryCompoundBase Conformance
    var title: String {
        get { name }
        set { name = newValue }
    }
    var description: String? = nil
    var manufacturer: (any Manufacturer)? = nil
    var releaseDate: Date? = nil
    var dataSource: (any DataSource)? = nil
    var children: [any InventoryItem] = []
    var images: [any InventoryItem] = []
    
    var accessionNumber: String? = nil
    var typeIdentifier: String { type ?? "asset" }
    var type: String?
    var custodyLocation: String?
    var acquisitionSource: String?
    var acquisitionDate: Date?
    var tags: [String]
    var provenance: String?
    
    // Default/Empty implementations for other protocol requirements
    var identifiers: [any InventoryIdentifier] = []
    var productID: UUID? = nil
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
    var location: ItemLocationType? = nil
    
    // InventoryItem Conformance
    var sizeOrWeight: Int64? = nil
    var fileHashes: [String : String]? = nil
    var serialNumber: String? = nil
    var typeClassifier: ItemClassifierType { .physicalItem } // Default
    var mediaFormat: MediaFormatType? = nil
    var container: (any ItemContainer)? = nil
    
    var sourceCode: (any InventorySourceCode)? = nil
}
