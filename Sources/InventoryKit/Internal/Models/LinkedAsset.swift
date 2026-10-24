import Foundation
import InventoryTypes
import InventoryCore

/// Concrete implementation of a linked asset connection.
public struct LinkedAsset: InventoryLinkedAsset, Codable, Hashable, Sendable {
    public var assetID: UUID
    public var typeID: String
    public var note: String?
    
    public init(assetID: UUID, typeID: String, note: String? = nil) {
        self.assetID = assetID
        self.typeID = typeID
        self.note = note
    }
}
