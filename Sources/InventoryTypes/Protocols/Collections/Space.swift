import Foundation

/// A protocol defining a space where inventory items can be stored.
/// This can be a physical space (Building, Room) or a digital space (DigitalVolume).
public protocol Space: Sendable, Identifiable {
    /// Unique identifier for the space.
    var id: UUID { get set }
    
    /// Human-readable name of the space.
    var name: String { get set }
    
    /// Optional geographical location of the space.
    var geoLocation: InventoryGeoLocation? { get set }
}
