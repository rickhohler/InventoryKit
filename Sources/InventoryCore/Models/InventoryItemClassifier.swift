import Foundation

/// High-level classification for an Inventory Item.
public enum InventoryItemClassifier: String, Codable, Sendable {
    case media      // Disk images, ROMs, Cassettes
    case artwork    // Scans, Photos, Maps
    case document   // Manuals, PDF, TXT
    case hardware   // Chips, PCBs, Cables, Screws
    case other      // Unclassified
}
