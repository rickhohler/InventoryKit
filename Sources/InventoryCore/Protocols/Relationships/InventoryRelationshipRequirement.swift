import Foundation

/// Defines a related asset requirement (peripheral, dependency, accessory, etc.).
public protocol InventoryRelationshipRequirement: Sendable {
    var name: String { get }
    var typeID: String { get }
    var required: Bool { get }
    var compatibleAssetIDs: [UUID] { get }
    var requiredTags: [String] { get }
    var complianceNotes: String? { get }
}

/// Relationship category for related assets.
public enum InventoryRelationshipKind: String, Codable, Sendable {
    case peripheral
    case dependency
    case accessory
    case service
    case other
}



public enum InventoryRelationshipComplianceStatus: String, Sendable {
    case satisfied
    case missingRequired
    case missingOptional
    case incompatible
    case nonCompliantTags
}
