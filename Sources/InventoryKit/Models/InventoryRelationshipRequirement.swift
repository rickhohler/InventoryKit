import Foundation

/// Defines a related asset requirement (peripheral, dependency, accessory, etc.).
public struct InventoryRelationshipRequirement: Codable, Equatable, Hashable, Sendable {
    public var name: String
    public var typeID: String
    public var required: Bool
    public var compatibleAssetIDs: [UUID]
    public var requiredTags: [String]
    public var complianceNotes: String?

    public init(
        name: String,
        typeID: String,
        required: Bool = true,
        compatibleAssetIDs: [UUID] = [],
        requiredTags: [String] = [],
        complianceNotes: String? = nil
    ) {
        self.name = name
        self.typeID = typeID
        self.required = required
        self.compatibleAssetIDs = compatibleAssetIDs
        self.requiredTags = requiredTags
        self.complianceNotes = complianceNotes
    }
}

/// Relationship category for related assets.
public enum InventoryRelationshipKind: String, Codable, Sendable {
    case peripheral
    case dependency
    case accessory
    case service
    case other
}

/// Result emitted when checking related asset requirements.
public struct InventoryRelationshipEvaluation: Equatable, Sendable {
    public var requirement: InventoryRelationshipRequirement
    public var status: InventoryRelationshipComplianceStatus
    public var message: String

    public init(
        requirement: InventoryRelationshipRequirement,
        status: InventoryRelationshipComplianceStatus,
        message: String
    ) {
        self.requirement = requirement
        self.status = status
        self.message = message
    }
}

public enum InventoryRelationshipComplianceStatus: String, Sendable {
    case satisfied
    case missingRequired
    case missingOptional
    case incompatible
    case nonCompliantTags
}
