import Foundation
import InventoryCore

/// Type-erased wrapper for `InventoryAssetProtocol`.
public struct AnyInventoryAsset: InventoryAssetProtocol, Identifiable, Sendable, Codable {
    public let id: UUID
    public let name: String
    public let type: String?
    public let location: String?
    
    // Identifiers
    private let _identifiers: [InventoryIdentifier]
    public var identifiers: [any InventoryIdentifierProtocol] { _identifiers }
    
    // Source
    private let _source: InventorySource?
    public var source: (any InventorySourceProtocol)? { _source }
    
    // Lifecycle
    private let _lifecycle: InventoryLifecycle?
    public var lifecycle: (any InventoryLifecycleProtocol)? { _lifecycle }
    
    // MRO
    private let _mro: InventoryMROInfo?
    public var mro: (any InventoryMROInfoProtocol)? { _mro }
    
    // Health
    private let _health: InventoryHealth?
    public var health: (any InventoryHealthProtocol)? { _health }
    
    // Copyright
    private let _copyright: CopyrightInfo?
    public var copyright: (any CopyrightInfoProtocol)? { _copyright }
    
    // Components
    private let _components: [InventoryComponentLink]
    public var components: [any InventoryComponentLinkProtocol] { _components }
    
    // Relationships
    private let _relationshipRequirements: [InventoryRelationshipRequirement]
    public var relationshipRequirements: [any InventoryRelationshipRequirementProtocol] { _relationshipRequirements }
    
    private let _linkedAssets: [InventoryLinkedAsset]
    public var linkedAssets: [any InventoryLinkedAssetProtocol] { _linkedAssets }
    
    public let tags: [String]
    public let metadata: [String: String]
    public let productID: UUID?
    
    // Conformance to InventoryAssetProtocol simple properties
    public let acquisitionSource: String?
    public let provenance: String?
    public let acquisitionDate: Date?
    public let condition: String?
    public let forensicClassification: String?
    public var custodyLocation: String? { location }
    public let relationshipType: AssetRelationshipType? 
    
    public init(_ asset: any InventoryAssetProtocol) {
        self.id = asset.id
        self._identifiers = asset.identifiers.compactMap { $0 as? InventoryIdentifier ?? InventoryIdentifier(type: $0.type, value: $0.value) }
        
        self.name = asset.name
        self.type = asset.type
        self.location = asset.custodyLocation
        
        if let s = asset.source {
            self._source = s as? InventorySource ?? InventorySource(origin: s.origin, department: s.department, contactEmail: s.contactEmail, contactPhone: s.contactPhone)
        } else { self._source = nil }
        
        if let l = asset.lifecycle {
            self._lifecycle = l as? InventoryLifecycle ?? InventoryLifecycle(stage: l.stage, events: l.events)
        } else { self._lifecycle = nil }
        
        if let m = asset.mro {
            self._mro = m as? InventoryMROInfo ?? InventoryMROInfo(sku: m.sku, vendor: m.vendor, quantityOnHand: m.quantityOnHand, reorderPoint: m.reorderPoint, reorderQuantity: m.reorderQuantity)
        } else { self._mro = nil }
        
        if let h = asset.health {
            self._health = h as? InventoryHealth ?? InventoryHealth(physicalCondition: h.physicalCondition, operationalStatus: h.operationalStatus, notes: h.notes, lastDiagnosticAt: h.lastDiagnosticAt)
        } else { self._health = nil }
        
        if let c = asset.copyright {
            self._copyright = c as? CopyrightInfo ?? CopyrightInfo(text: c.text, year: c.year, holder: c.holder, license: c.license, metadata: c.metadata)
        } else { self._copyright = nil }

        self._components = asset.components.compactMap { $0 as? InventoryComponentLink ?? InventoryComponentLink(assetID: $0.assetID, quantity: $0.quantity, note: $0.note) }
        self._relationshipRequirements = asset.relationshipRequirements.compactMap { $0 as? InventoryRelationshipRequirement ?? InventoryRelationshipRequirement(name: $0.name, typeID: $0.typeID, required: $0.required, compatibleAssetIDs: $0.compatibleAssetIDs, requiredTags: $0.requiredTags, complianceNotes: $0.complianceNotes) }
        self._linkedAssets = asset.linkedAssets.compactMap { $0 as? InventoryLinkedAsset ?? InventoryLinkedAsset(assetID: $0.assetID, typeID: $0.typeID, note: $0.note) }
        
        self.tags = asset.tags
        self.metadata = asset.metadata
        self.productID = asset.productID
        self.provenance = asset.provenance
        self.acquisitionSource = asset.acquisitionSource
        self.acquisitionDate = asset.acquisitionDate
        self.condition = asset.condition
        self.forensicClassification = asset.forensicClassification
        self.relationshipType = asset.relationshipType
    }
    
    // Explicit init
    public init(
        id: UUID = UUID(),
        identifiers: [InventoryIdentifier] = [],
        name: String,
        type: String? = nil,
        location: String? = nil,
        source: InventorySource? = nil,
        lifecycle: InventoryLifecycle? = nil,
        mro: InventoryMROInfo? = nil,
        health: InventoryHealth? = nil,
        copyright: CopyrightInfo? = nil,
        components: [InventoryComponentLink] = [],
        relationshipRequirements: [InventoryRelationshipRequirement] = [],
        linkedAssets: [InventoryLinkedAsset] = [],
        tags: [String] = [],
        metadata: [String: String] = [:],
        productID: UUID? = nil,
        provenance: String? = nil,
        acquisitionSource: String? = nil,
        acquisitionDate: Date? = nil,
        condition: String? = nil,
        forensicClassification: String? = nil,
        relationshipType: AssetRelationshipType? = nil
    ) {
        self.id = id
        self._identifiers = identifiers
        self.name = name
        self.type = type
        self.location = location
        self._source = source
        self._lifecycle = lifecycle
        self._mro = mro
        self._health = health
        self._copyright = copyright
        self._components = components
        self._relationshipRequirements = relationshipRequirements
        self._linkedAssets = linkedAssets
        self.tags = tags
        self.metadata = metadata
        self.productID = productID
        self.provenance = provenance
        self.acquisitionSource = acquisitionSource
        self.acquisitionDate = acquisitionDate
        self.condition = condition
        self.forensicClassification = forensicClassification
        self.relationshipType = relationshipType
    }
    
    enum CodingKeys: String, CodingKey {
        case id, identifiers, name, type, location, source, lifecycle, mro, health
        case components, relationshipRequirements, linkedAssets, tags, copyright, metadata
        case productID, provenance, acquisitionSource, acquisitionDate, condition
        case forensicClassification, relationshipType
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self._identifiers = try container.decodeIfPresent([InventoryIdentifier].self, forKey: .identifiers) ?? []
        
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self._source = try container.decodeIfPresent(InventorySource.self, forKey: .source)
        self._lifecycle = try container.decodeIfPresent(InventoryLifecycle.self, forKey: .lifecycle)
        self._mro = try container.decodeIfPresent(InventoryMROInfo.self, forKey: .mro)
        self._health = try container.decodeIfPresent(InventoryHealth.self, forKey: .health)
        
        self._components = try container.decodeIfPresent([InventoryComponentLink].self, forKey: .components) ?? []
        self._relationshipRequirements = try container.decodeIfPresent([InventoryRelationshipRequirement].self, forKey: .relationshipRequirements) ?? []
        self._linkedAssets = try container.decodeIfPresent([InventoryLinkedAsset].self, forKey: .linkedAssets) ?? []
        self.tags = try container.decodeIfPresent([String].self, forKey: .tags) ?? []
        
        self._copyright = try container.decodeIfPresent(CopyrightInfo.self, forKey: .copyright)
        self.metadata = try container.decodeIfPresent([String: String].self, forKey: .metadata) ?? [:]
        self.productID = try container.decodeIfPresent(UUID.self, forKey: .productID)
        
        self.provenance = try container.decodeIfPresent(String.self, forKey: .provenance)
        self.acquisitionSource = try container.decodeIfPresent(String.self, forKey: .acquisitionSource)
        self.acquisitionDate = try container.decodeIfPresent(Date.self, forKey: .acquisitionDate)
        self.condition = try container.decodeIfPresent(String.self, forKey: .condition)
        self.forensicClassification = try container.decodeIfPresent(String.self, forKey: .forensicClassification)
        self.relationshipType = try container.decodeIfPresent(AssetRelationshipType.self, forKey: .relationshipType)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        if !_identifiers.isEmpty { try container.encode(_identifiers, forKey: .identifiers) }
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(_source, forKey: .source)
        try container.encodeIfPresent(_lifecycle, forKey: .lifecycle)
        try container.encodeIfPresent(_mro, forKey: .mro)
        try container.encodeIfPresent(_health, forKey: .health)
        if !_components.isEmpty { try container.encode(_components, forKey: .components) }
        if !_relationshipRequirements.isEmpty { try container.encode(_relationshipRequirements, forKey: .relationshipRequirements) }
        if !_linkedAssets.isEmpty { try container.encode(_linkedAssets, forKey: .linkedAssets) }
        if !tags.isEmpty { try container.encode(tags, forKey: .tags) }
        try container.encodeIfPresent(_copyright, forKey: .copyright)
        if !metadata.isEmpty { try container.encode(metadata, forKey: .metadata) }
        try container.encodeIfPresent(productID, forKey: .productID)
        try container.encodeIfPresent(provenance, forKey: .provenance)
        try container.encodeIfPresent(acquisitionSource, forKey: .acquisitionSource)
        try container.encodeIfPresent(acquisitionDate, forKey: .acquisitionDate)
        try container.encodeIfPresent(condition, forKey: .condition)
        try container.encodeIfPresent(forensicClassification, forKey: .forensicClassification)
        try container.encodeIfPresent(relationshipType, forKey: .relationshipType)
    }
}

extension AnyInventoryAsset: Equatable {
    public static func == (lhs: AnyInventoryAsset, rhs: AnyInventoryAsset) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs._identifiers == rhs._identifiers &&
        lhs._lifecycle == rhs._lifecycle
    }
}

extension AnyInventoryAsset: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
