import Foundation

/// A stored component link: `{"assetID": ..., "quantity": ..., "note": ...}`.
public struct ComponentLinkModel: InventoryComponentLink, Codable, Hashable, Sendable {
    public var assetID: UUID
    public var quantity: Int
    public var note: String?

    public init(assetID: UUID, quantity: Int = 1, note: String? = nil) {
        self.assetID = assetID
        self.quantity = quantity
        self.note = note
    }
}
