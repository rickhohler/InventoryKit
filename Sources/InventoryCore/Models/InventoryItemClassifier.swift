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
    case tapeImage      // Digital representations of magnetic tape (T64, TAP, CAS)

    // MARK: - Hardware & Physical
    case computerHardware // Chips, PCBs, Cables, Screws (Computing specific)
    case peripheral       // Input devices, Monitors, Printers
    case physicalItem     // General household items, Furniture, Tools, Collectibles
    case storageContainer // Boxes, Tubs, Bins
    case physicalSoftware // Physical copies of software (Boxed games, Cartridges, Original Media)
    
    // MARK: - Other
    case other          // Fallback / Unclassified
    
    // MARK: - Category
    
    public enum InventoryCategory: String, Sendable, Codable {
        case digital
        case physical
    }
    
    public var category: InventoryCategory {
        switch self {
        case .computerHardware, .peripheral, .physicalItem, .storageContainer, .physicalSoftware:
            return .physical
        default:
            return .digital
        }
    }
}
