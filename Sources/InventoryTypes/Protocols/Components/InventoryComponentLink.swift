import Foundation

/// Describes an embedded component that belongs to a parent asset.
/// Describes an embedded component that belongs to a parent asset.
public protocol InventoryComponentLink: Sendable {
    var assetID: UUID { get }
    var quantity: Int { get }
    var note: String? { get }
}
