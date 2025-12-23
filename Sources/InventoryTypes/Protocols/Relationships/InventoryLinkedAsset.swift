import Foundation

/// Represents a related asset connection (peripheral, accessory, dependency, etc.).
public protocol InventoryLinkedAsset: Sendable {
    var assetID: UUID { get }
    var typeID: String { get }
    var note: String? { get }
}
