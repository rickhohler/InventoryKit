import Foundation

/// Describes the physical contents of a software package.
/// The "90% Case" for retro software is: Box + Manual + Media (Disk/Cart).
public struct InventoryPackageContents: OptionSet, Codable, Sendable {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    // MARK: - Core Components (The "90%" Case)
    public static let box = InventoryPackageContents(rawValue: 1 << 0)
    public static let manual = InventoryPackageContents(rawValue: 1 << 1)
    public static let media = InventoryPackageContents(rawValue: 1 << 2) // Disk, Cartridge, Cassette, CD
    
    // MARK: - Extras
    public static let registrationCard = InventoryPackageContents(rawValue: 1 << 3)
    public static let map = InventoryPackageContents(rawValue: 1 << 4)
    public static let overlays = InventoryPackageContents(rawValue: 1 << 5) // Keypad overlays
    public static let catalog = InventoryPackageContents(rawValue: 1 << 6) // Promotional catalog
    public static let trinkets = InventoryPackageContents(rawValue: 1 << 7) // Pins, Coins, Feelies
    
    // MARK: - Hardware Extras
    public static let cables = InventoryPackageContents(rawValue: 1 << 8) // AV cables, USB cables
    public static let powerSupply = InventoryPackageContents(rawValue: 1 << 9) // PSU, Power Brick, AC Adapter
    
    // MARK: - Composites
    
    /// Standard "Complete In Box" (CIB) for most software.
    public static let standardCIB: InventoryPackageContents = [.box, .manual, .media]
    
    /// Standard "Complete In Box" (CIB) for hardware.
    public static let hardwareCIB: InventoryPackageContents = [.box, .manual, .media, .cables, .powerSupply]
    
    /// Loose media only.
    public static let loose: InventoryPackageContents = [.media]
}
