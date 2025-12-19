import Foundation

/// Represents a related asset connection (peripheral, accessory, dependency, etc.).
public struct InventoryLinkedAsset: Codable, Equatable, Hashable, Sendable {
    public var assetID: UUID
    public var typeID: String
    public var note: String?

    public init(assetID: UUID, typeID: String, note: String? = nil) {
        self.assetID = assetID
        self.typeID = typeID
        self.note = note
    }
}
