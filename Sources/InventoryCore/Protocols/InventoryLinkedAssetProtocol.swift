import Foundation

/// Represents a related asset connection (peripheral, accessory, dependency, etc.).
public protocol InventoryLinkedAssetProtocol: Sendable {
    var assetID: UUID { get }
    var typeID: String { get }
    var note: String? { get }
}
