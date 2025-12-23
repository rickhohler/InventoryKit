import Foundation
import InventoryTypes
import InventoryCore

/// Concrete implementation of a relationship evaluation result.
public struct RelationshipEvaluation: InventoryRelationshipEvaluation, Sendable {
    public let requirement: any InventoryRelationshipRequirement
    public let status: InventoryRelationshipComplianceStatus
    public let message: String
    
    public init(requirement: any InventoryRelationshipRequirement, status: InventoryRelationshipComplianceStatus, message: String) {
        self.requirement = requirement
        self.status = status
        self.message = message
    }
}
