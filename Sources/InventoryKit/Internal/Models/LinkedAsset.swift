import Foundation
import InventoryTypes
import InventoryCore

/// Concrete implementation of a linked asset connection.
public struct LinkedAsset: InventoryLinkedAsset, Codable, Sendable {
    public let assetID: UUID
    public let typeID: String
    public let note: String?
    
    public init(assetID: UUID, typeID: String, note: String? = nil) {
        self.assetID = assetID
        self.typeID = typeID
        self.note = note
    }
}
