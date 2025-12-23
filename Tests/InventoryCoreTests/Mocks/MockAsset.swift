import Foundation
import InventoryCore
import InventoryTypes

public struct MockAsset: InventoryAsset, Sendable {
    public var id: UUID

    public var name: String
    public var title: String {
        get { name }
        set { name = newValue }
    }
    public var description: String?
    public var manufacturer: (any Manufacturer)?
    public var releaseDate: Date?
    public var dataSource: (any DataSource)?
    public var children: [any InventoryItem]
    public var images: [any InventoryItem]
    public var type: String?
    public var identifiers: [any InventoryIdentifier]
    public var tags: [String]
    public var metadata: [String: String]
    
    // Rich Data
    public var source: (any InventorySource)?
    public var lifecycle: (any InventoryLifecycle)?
    public var health: (any InventoryHealth)?
    public var mro: (any InventoryMROInfo)?
    public var copyright: (any CopyrightInfo)?
    public var components: [any InventoryComponentLink]
    public var relationshipRequirements: [any InventoryRelationshipRequirement]
    public var linkedAssets: [any InventoryLinkedAsset]
    
    // Flat properties
    public var accessionNumber: String? = nil
    public var mediaFormat: MediaFormatType? = nil
    
    // InventoryItem Conformance
    public var sizeOrWeight: Int64? = nil
    public var typeIdentifier: String = "mock"
    public var fileHashes: [String : String]? = nil
    public var serialNumber: String? = nil
    public var typeClassifier: ItemClassifierType = .physicalItem
    public var sourceCode: (any InventorySourceCode)? = nil
    
    // Protocol Conformance (Mutable)
    public var provenance: String?
    public var acquisitionSource: String?
    public var acquisitionDate: Date?
    public var location: ItemLocationType?
    public var container: (any ItemContainer)?
    public var condition: String?
    
    public var forensicClassification: String?
    public var custodyLocation: String?
    public var productID: UUID?
    public var relationshipType: AssetRelationshipType?
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String? = nil,
        manufacturer: (any Manufacturer)? = nil, // Base
        releaseDate: Date? = nil, // Base
        dataSource: (any DataSource)? = nil, // Base
        children: [any InventoryItem] = [], // Base
        images: [any InventoryItem] = [], // Base
        
        type: String? = nil,
        identifiers: [any InventoryIdentifier] = [],
        tags: [String] = [],
        metadata: [String: String] = [:],
        provenance: String? = nil,
        acquisitionSource: String? = nil,
        forensicClassification: String? = nil,
        custodyLocation: String? = nil,
        productID: UUID? = nil,
        relationshipType: AssetRelationshipType? = nil,
        
        // Rich Models
        source: (any InventorySource)? = nil,
        lifecycle: (any InventoryLifecycle)? = nil,
        health: (any InventoryHealth)? = nil,
        mro: (any InventoryMROInfo)? = nil,
        copyright: (any CopyrightInfo)? = nil,
        components: [any InventoryComponentLink] = [],
        relationshipRequirements: [any InventoryRelationshipRequirement] = [],
        linkedAssets: [any InventoryLinkedAsset] = []
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.manufacturer = manufacturer
        self.releaseDate = releaseDate
        self.dataSource = dataSource
        self.children = children
        self.images = images
        
        self.type = type
        self.identifiers = identifiers
        self.tags = tags
        self.metadata = metadata
        self.provenance = provenance
        self.acquisitionSource = acquisitionSource
        self.forensicClassification = forensicClassification
        self.custodyLocation = custodyLocation
        self.productID = productID
        self.relationshipType = relationshipType
        
        self.source = source
        self.lifecycle = lifecycle
        self.health = health
        self.mro = mro
        self.copyright = copyright
        self.components = components
        self.relationshipRequirements = relationshipRequirements
        self.linkedAssets = linkedAssets
        
        // Map Lifecycle/Health to flat properties if provided but not explicitly set
        if self.acquisitionDate == nil {
             self.acquisitionDate = lifecycle?.events.first?.timestamp
        }
        if self.condition == nil {
             self.condition = health?.physicalCondition.rawValue
        }
    }
}

// Minimal Mocks for Core Tests
public struct MockIdentifier: InventoryIdentifier, Sendable {
    public var type: IdentifierType
    public var value: String
    public init(type: IdentifierType, value: String) {
        self.type = type
        self.value = value
    }
}

public struct MockSource: InventorySource, Sendable {
    public var origin: String
    public var department: String?
    public var contactEmail: String?
    public var contactPhone: String?
    public init(origin: String) { self.origin = origin }
}

public struct MockLifecycle: InventoryLifecycle, Sendable {
    public var stage: InventoryLifecycleStage
    public var events: [any InventoryLifecycleEventProtocol]
    public init(stage: InventoryLifecycleStage, events: [any InventoryLifecycleEventProtocol] = []) {
        self.stage = stage
        self.events = events
    }
}

public struct MockLifecycleEvent: InventoryLifecycleEventProtocol, Sendable {
    public var timestamp: Date?
    public var actor: String?
    public var note: String?
    public init(timestamp: Date? = nil, actor: String? = nil, note: String? = nil) {
        self.timestamp = timestamp
        self.actor = actor
        self.note = note
    }
}
