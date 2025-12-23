import Foundation

/// Represents the source or provenance of an asset.
/// Represents the source or provenance of an asset.
public protocol InventorySource: Sendable {
    var origin: String { get }
    var department: String? { get }
    var contactEmail: String? { get }
    var contactPhone: String? { get }
}
