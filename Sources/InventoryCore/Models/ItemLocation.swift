import Foundation

/// Defines the specific location of an item or container.
public enum ItemLocation: Sendable, Codable, Equatable {
    
    /// A physical location within a room (e.g., "Shelf A", "Bin 4").
    /// - Parameters:
    ///   - room: The room containing the item.
    ///   - exactLocation: Optional descriptive text (e.g. "Top Shelf").
    ///   - geoLocation: Optional specific GPS coordinates for this item/container.
    case physical(room: InventoryRoom, exactLocation: String?, geoLocation: InventoryGeoLocation?)
    
    /// a digital location (e.g., a file path on a volume).
    /// - Parameters:
    ///   - url: The full URI to the item.
    ///   - volume: The name of the volume (optional/redundant if in URI, but helpful for UI).
    case digital(url: URL, volume: String?)
}
