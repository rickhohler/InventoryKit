import Foundation

/// Protocol for the Workbench Workflow.
/// specific interface for handling mutable working copies of assets.
public protocol WorkbenchServiceProtocol: Sendable {
    
    /// Creates a mutable WorkbenchItem from an existing Asset.
    /// This typically involves copying the asset's file to a temporary location.
    /// - Parameter assetID: The ID of the generic asset (Original/Derived) to checkout.
    /// - Returns: A new WorkbenchItem ready for modification.
    func checkout(assetID: UUID) async throws -> any WorkbenchItemProtocol
    
    /// Persists the current state of the WorkbenchItem (without graduating it to an Asset).
    /// Used for "Save Progress" functionality (e.g., saving a game state).
    func save(_ item: any WorkbenchItemProtocol) async throws
    
    /// Promotes the WorkbenchItem to a full Inventory Asset.
    /// - Parameters:
    ///   - item: The item to commit.
    ///   - classification: The new classification (e.g., "Modified", "Derived").
    /// - Returns: The newly created InventoryAsset.
    func commit(_ item: any WorkbenchItemProtocol, as classification: String) async throws -> any InventoryAssetProtocol
    
    /// Discards the WorkbenchItem and cleans up temporary files.
    func discard(_ item: any WorkbenchItemProtocol) async throws
}
