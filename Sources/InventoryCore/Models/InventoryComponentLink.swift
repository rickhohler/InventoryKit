import Foundation

/// Describes an embedded component that belongs to a parent asset.
public struct InventoryComponentLink: Codable, Equatable, Hashable, Sendable {
    public var assetID: UUID
    public var quantity: Int
    public var note: String?

    public init(assetID: UUID, quantity: Int = 1, note: String? = nil) {
        self.assetID = assetID
        self.quantity = quantity
        self.note = note
    }
}
