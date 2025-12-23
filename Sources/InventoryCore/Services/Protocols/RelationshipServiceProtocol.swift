import Foundation
import InventoryTypes

/// Service for managing asset relationships and compliance.
public protocol RelationshipService: Sendable {
    
    /// Evaluates the relationship compliance for a given asset.
    /// Checks if all requirements defined in `relationshipRequirements` are met by `linkedAssets`.
    /// - Parameter asset: The asset to evaluate.
    /// - Returns: A list of evaluation results for each requirement.
    func evaluateCompliance(for asset: any InventoryAsset) async throws -> [any InventoryRelationshipEvaluation]
    
    /// Establishes a link between two assets.
    /// - Parameters:
    ///   - sourceID: The UUID of the asset requiring the relationship.
    ///   - targetID: The UUID of the asset satisfying the relationship.
    ///   - typeID: The identifier for the type of relationship (e.g. "peripheral", "dependency").
    ///   - note: Optional note describing the specific usage.
    func link(sourceID: UUID, targetID: UUID, typeID: String, note: String?) async throws
    
    /// Removes a link between two assets.
    /// - Parameters:
    ///   - sourceID: The source asset ID.
    ///   - targetID: The target asset ID to unlink.
    func unlink(sourceID: UUID, targetID: UUID) async throws
    
    /// Finds candidate assets in the inventory that could satisfy a specific requirement.
    /// - Parameter requirement: The requirement to match against.
    /// - Returns: A list of compatible asset summaries (e.g. just ID and name/tags).
    func findCandidates(for requirement: any InventoryRelationshipRequirement) async throws -> [any InventoryAsset]
}
