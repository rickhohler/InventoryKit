import Foundation

/// Captures Maintenance, Repair, and Operations stock information for an asset or part.
public struct InventoryMROInfo: Codable, Equatable, Hashable, Sendable {
    public var sku: String?
    public var vendor: String?
    public var quantityOnHand: Int
    public var reorderPoint: Int?
    public var reorderQuantity: Int?

    public init(
        sku: String? = nil,
        vendor: String? = nil,
        quantityOnHand: Int,
        reorderPoint: Int? = nil,
        reorderQuantity: Int? = nil
    ) {
        self.sku = sku
        self.vendor = vendor
        self.quantityOnHand = quantityOnHand
        self.reorderPoint = reorderPoint
        self.reorderQuantity = reorderQuantity
    }
}
