import Foundation

/// High-level classification for an Inventory Item.
public enum InventoryItemClassifier: String, Codable, Sendable {
    // MARK: - Software & Data
    case software       // Executables, Applications, Games
    case firmware       // ROMs, BIOS, Device Firmware
    case diskImage      // Digital representations of physical storage media (DSK, ISO, IMG)
    case archive        // Archives and bundles (ZIP, SIT, 7Z)
    case document       // Guidance, Manuals, PDF, TXT
    case multimedia     // Audio and Video files (MP3, MOV)
    case graphic        // Visual assets (Images, Maps, Schematics)

    // MARK: - Hardware & Physical
    case computerHardware // Chips, PCBs, Cables, Screws (Computing specific)
    case peripheral       // Input devices, Monitors, Printers
    case physicalItem     // General household items, Furniture, Tools, Collectibles
    case storageContainer // Boxes, Tubs, Bins
    
    // MARK: - Other
    case other          // Fallback / Unclassified
    
    // MARK: - Category
    
    public enum InventoryCategory: String, Sendable, Codable {
        case digital
        case physical
    }
    
    public var category: InventoryCategory {
        switch self {
        case .computerHardware, .peripheral, .physicalItem, .storageContainer:
            return .physical
        default:
            return .digital
        }
    }
}
