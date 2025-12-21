import Foundation

public protocol InventoryRelationshipType: Sendable {
    var id: String { get }
    var displayName: String { get }
    var inverseID: String? { get }
    var category: InventoryRelationshipKind { get }
}

public protocol InventoryRelationshipEvaluation: Sendable {
    var requirement: any InventoryRelationshipRequirement { get }
    var status: InventoryRelationshipComplianceStatus { get }
    var message: String { get }
}
