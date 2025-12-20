import Foundation
import InventoryCore

// MARK: - Identifiers

public struct InventoryIdentifier: InventoryIdentifierProtocol, Codable, Equatable, Hashable, Sendable {
    public var type: InventoryIdentifierType
    public var value: String

    public init(type: InventoryIdentifierType, value: String) {
        self.type = type
        self.value = value
    }
}

// MARK: - Source

public struct InventorySource: InventorySourceProtocol, Codable, Equatable, Hashable, Sendable {
    public var origin: String
    public var department: String?
    public var contactEmail: String?
    public var contactPhone: String?

    public init(origin: String, department: String? = nil, contactEmail: String? = nil, contactPhone: String? = nil) {
        self.origin = origin
        self.department = department
        self.contactEmail = contactEmail
        self.contactPhone = contactPhone
    }
}

// MARK: - Lifecycle

public struct InventoryLifecycle: InventoryLifecycleProtocol, Codable, Equatable, Hashable, Sendable {
    public var stage: InventoryLifecycleStage
    
    // Concrete storage
    private var _events: [InventoryLifecycleEvent]
    public var events: [any InventoryLifecycleEventProtocol] { _events }
    
    private enum CodingKeys: String, CodingKey {
        case stage, events
    }
    
    public init(stage: InventoryLifecycleStage, events: [any InventoryLifecycleEventProtocol] = []) {
        self.stage = stage
        self._events = events.compactMap { $0 as? InventoryLifecycleEvent ?? InventoryLifecycleEvent(timestamp: $0.timestamp, actor: $0.actor, note: $0.note) }
    }
    
    public init(stage: InventoryLifecycleStage, concreteEvents: [InventoryLifecycleEvent]) {
        self.stage = stage
        self._events = concreteEvents
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stage = try container.decode(InventoryLifecycleStage.self, forKey: .stage)
        self._events = try container.decode([InventoryLifecycleEvent].self, forKey: .events)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stage, forKey: .stage)
        try container.encode(_events, forKey: .events)
    }
}

public struct InventoryLifecycleEvent: InventoryLifecycleEventProtocol, Codable, Equatable, Hashable, Sendable {
    public var timestamp: Date?
    public var actor: String?
    public var note: String?

    public init(timestamp: Date? = nil, actor: String? = nil, note: String? = nil) {
        self.timestamp = timestamp
        self.actor = actor
        self.note = note
    }
}

// MARK: - Health

public struct InventoryHealth: InventoryHealthProtocol, Codable, Equatable, Hashable, Sendable {
    public var physicalCondition: InventoryPhysicalCondition
    public var operationalStatus: InventoryOperationalStatus
    public var notes: String?
    public var lastDiagnosticAt: Date?

    public init(physicalCondition: InventoryPhysicalCondition = .unknown, operationalStatus: InventoryOperationalStatus = .unknown, notes: String? = nil, lastDiagnosticAt: Date? = nil) {
        self.physicalCondition = physicalCondition
        self.operationalStatus = operationalStatus
        self.notes = notes
        self.lastDiagnosticAt = lastDiagnosticAt
    }
}

// MARK: - MRO

public struct InventoryMROInfo: InventoryMROInfoProtocol, Codable, Equatable, Hashable, Sendable {
    public var sku: String?
    public var vendor: String?
    public var quantityOnHand: Int
    public var reorderPoint: Int?
    public var reorderQuantity: Int?
    
    public init(sku: String? = nil, vendor: String? = nil, quantityOnHand: Int = 0, reorderPoint: Int? = nil, reorderQuantity: Int? = nil) {
        self.sku = sku
        self.vendor = vendor
        self.quantityOnHand = quantityOnHand
        self.reorderPoint = reorderPoint
        self.reorderQuantity = reorderQuantity
    }
}

// MARK: - Copyright

public struct CopyrightInfo: CopyrightInfoProtocol, Codable, Equatable, Hashable, Sendable {
    public var text: String?
    public var year: Int?
    public var holder: String?
    public var license: String?
    public var metadata: [String: String]

    public init(text: String? = nil, year: Int? = nil, holder: String? = nil, license: String? = nil, metadata: [String: String] = [:]) {
        self.text = text
        self.year = year
        self.holder = holder
        self.license = license
        self.metadata = metadata
    }
}

// MARK: - Graph

public struct InventoryComponentLink: InventoryComponentLinkProtocol, Codable, Equatable, Hashable, Sendable {
    public var assetID: UUID
    public var quantity: Int
    public var note: String?

    public init(assetID: UUID, quantity: Int = 1, note: String? = nil) {
        self.assetID = assetID
        self.quantity = quantity
        self.note = note
    }
}

public struct InventoryRelationshipRequirement: InventoryRelationshipRequirementProtocol, Codable, Equatable, Hashable, Sendable {
    public var name: String
    public var typeID: String
    public var required: Bool
    public var compatibleAssetIDs: [UUID]
    public var requiredTags: [String]
    public var complianceNotes: String?

    public init(name: String, typeID: String, required: Bool = true, compatibleAssetIDs: [UUID] = [], requiredTags: [String] = [], complianceNotes: String? = nil) {
        self.name = name
        self.typeID = typeID
        self.required = required
        self.compatibleAssetIDs = compatibleAssetIDs
        self.requiredTags = requiredTags
        self.complianceNotes = complianceNotes
    }
}

public struct InventoryLinkedAsset: InventoryLinkedAssetProtocol, Codable, Equatable, Hashable, Sendable {
    public var assetID: UUID
    public var typeID: String
    public var note: String?

    public init(assetID: UUID, typeID: String, note: String? = nil) {
        self.assetID = assetID
        self.typeID = typeID
        self.note = note
    }
}

// MARK: - Relationship Type (Missing in Core)

public struct InventoryRelationshipType: Codable, Equatable, Hashable, Sendable {
    public var id: String
    public var displayName: String
    public var inverseID: String?
    public var category: InventoryRelationshipKind
    
    public init(id: String, displayName: String, inverseID: String? = nil, category: InventoryRelationshipKind = .other) {
        self.id = id
        self.displayName = displayName
        self.inverseID = inverseID
        self.category = category
    }
}

// MARK: - Evaluation (Implementation Detail)

public struct InventoryRelationshipEvaluation: Equatable, Sendable {
    public var requirement: any InventoryRelationshipRequirementProtocol
    public var status: InventoryRelationshipComplianceStatus
    public var message: String
    
    public init(requirement: any InventoryRelationshipRequirementProtocol, status: InventoryRelationshipComplianceStatus, message: String) {
        self.requirement = requirement
        self.status = status
        self.message = message
    }
    
    public static func == (lhs: InventoryRelationshipEvaluation, rhs: InventoryRelationshipEvaluation) -> Bool {
        // Approximate equality for protocol
        lhs.requirement.name == rhs.requirement.name &&
        lhs.status == rhs.status &&
        lhs.message == rhs.message
    }
}
