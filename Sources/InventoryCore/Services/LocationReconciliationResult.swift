import Foundation

/// The result of a location reconciliation check (Smart Move).
public enum LocationReconciliationResult: Sendable {
    /// No move detected; element is where it should be.
    case noChange
    
    /// A potential move was detected based on nearby items.
    /// - Parameters:
    ///   - to: The new space (Room/Volume) the system believes the item is in.
    ///   - confidence: A value between 0.0 and 1.0 indicating certainty.
    case potentialMove(to: any InventorySpace, confidence: Double)
    
    /// The location is ambiguous (e.g. conflicting nearby items).
    case ambiguous(reasons: [String])
}
