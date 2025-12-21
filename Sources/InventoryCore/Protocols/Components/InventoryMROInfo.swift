import Foundation

/// Captures Maintenance, Repair, and Operations stock information for an asset or part.
/// Captures Maintenance, Repair, and Operations stock information for an asset or part.
public protocol InventoryMROInfo: Sendable {
    var sku: String? { get }
    var vendor: String? { get }
    var quantityOnHand: Int { get }
    var reorderPoint: Int? { get }
    var reorderQuantity: Int? { get }
}
