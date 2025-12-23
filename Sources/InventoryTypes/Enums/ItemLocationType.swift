import Foundation

/// Defines the specific location of an item or container.
public enum ItemLocationType: Sendable, Codable, Equatable {
    
    /// A physical location within a room (e.g., "Shelf A", "Bin 4").
    /// - Parameters:
    ///   - roomID: The UUID of the room containing the item.
    ///   - exactLocation: Optional descriptive text (e.g. "Top Shelf").
    ///   - geoLocation: Optional specific GPS coordinates for this item/container.
    case physical(roomID: UUID, exactLocation: String?, geoLocation: InventoryGeoLocation?)
    
    /// a digital location (e.g., a file path on a volume).
    /// - Parameters:
    ///   - url: The full URI to the item.
    ///   - volumeID: The UUID of the volume (optional).
    case digital(url: URL, volumeID: UUID?)
}
