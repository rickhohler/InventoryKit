import Foundation

/// Represents a physical building where inventory is stored (e.g., "Main House", "Warehouse").
public protocol Building: Space {
    /// Physical address of the building.
    var address: String? { get set }
}
