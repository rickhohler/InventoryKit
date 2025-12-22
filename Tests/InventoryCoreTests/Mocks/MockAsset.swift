import Foundation
import InventoryCore

public struct MockAsset: InventoryAsset, Sendable {
    public let id: UUID

    public let name: String
    public var title: String { name }
    public let description: String?
    public let manufacturer: (any InventoryManufacturer)?
    public let releaseDate: Date?
    public let dataSource: (any InventoryDataSource)?
    public var children: [any InventoryItem]
    public var images: [any InventoryItem]
    public let type: String?
    public let identifiers: [any InventoryIdentifier]
    public let tags: [String]
    public let metadata: [String: String]
    
    // Rich Data
    public let source: (any InventorySource)?
    public let lifecycle: (any InventoryLifecycle)?
    public let health: (any InventoryHealth)?
    public let mro: (any InventoryMROInfo)?
    public let copyright: (any CopyrightInfo)?
    public let components: [any InventoryComponentLink]
    public let relationshipRequirements: [any InventoryRelationshipRequirement]
    public let linkedAssets: [any InventoryLinkedAsset]
    
    // Flat properties
    public var accessionNumber: String? = nil
    public var mediaFormat: InventoryMediaFormat? = nil
    
    public var provenance: String? { _provenance }
    public var acquisitionSource: String? { _acquisitionSource }
    public var acquisitionDate: Date? { lifecycle?.events.first?.timestamp }
    public var condition: String? { health?.physicalCondition.rawValue }
    
    private let _provenance: String?
    private let _acquisitionSource: String?
    public let forensicClassification: String?
    public let custodyLocation: String?
    public let productID: UUID?
    public let relationshipType: AssetRelationshipType?
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String? = nil,
        manufacturer: (any InventoryManufacturer)? = nil, // Base
        releaseDate: Date? = nil, // Base
        dataSource: (any InventoryDataSource)? = nil, // Base
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
        self._provenance = provenance
        self._acquisitionSource = acquisitionSource
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
    }
}

// Minimal Mocks for Core Tests
public struct MockIdentifier: InventoryIdentifier, Sendable {
    public var type: InventoryIdentifierType
    public var value: String
    public init(type: InventoryIdentifierType, value: String) {
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

