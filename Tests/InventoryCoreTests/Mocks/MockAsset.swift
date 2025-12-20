import Foundation
import InventoryCore

public struct MockAsset: InventoryAssetProtocol, Sendable {
    public let id: UUID

    public let name: String
    public let type: String?
    public let identifiers: [any InventoryIdentifierProtocol]
    public let tags: [String]
    public let metadata: [String: String]
    
    // Rich Data
    public let source: (any InventorySourceProtocol)?
    public let lifecycle: (any InventoryLifecycleProtocol)?
    public let health: (any InventoryHealthProtocol)?
    public let mro: (any InventoryMROInfoProtocol)?
    public let copyright: (any CopyrightInfoProtocol)?
    public let components: [any InventoryComponentLinkProtocol]
    public let relationshipRequirements: [any InventoryRelationshipRequirementProtocol]
    public let linkedAssets: [any InventoryLinkedAssetProtocol]
    
    // Flat properties
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
        type: String? = nil,
        identifiers: [any InventoryIdentifierProtocol] = [],
        tags: [String] = [],
        metadata: [String: String] = [:],
        provenance: String? = nil,
        acquisitionSource: String? = nil,
        forensicClassification: String? = nil,
        custodyLocation: String? = nil,
        productID: UUID? = nil,
        relationshipType: AssetRelationshipType? = nil,
        source: (any InventorySourceProtocol)? = nil,
        lifecycle: (any InventoryLifecycleProtocol)? = nil,
        health: (any InventoryHealthProtocol)? = nil,
        mro: (any InventoryMROInfoProtocol)? = nil,
        copyright: (any CopyrightInfoProtocol)? = nil,
        components: [any InventoryComponentLinkProtocol] = [],
        relationshipRequirements: [any InventoryRelationshipRequirementProtocol] = [],
        linkedAssets: [any InventoryLinkedAssetProtocol] = []
    ) {
        self.id = id
        self.name = name
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
public struct MockIdentifier: InventoryIdentifierProtocol, Sendable {
    public var type: InventoryIdentifierType
    public var value: String
    public init(type: InventoryIdentifierType, value: String) {
        self.type = type
        self.value = value
    }
}

public struct MockSource: InventorySourceProtocol, Sendable {
    public var origin: String
    public var department: String?
    public var contactEmail: String?
    public var contactPhone: String?
    public init(origin: String) { self.origin = origin }
}

public struct MockLifecycle: InventoryLifecycleProtocol, Sendable {
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

