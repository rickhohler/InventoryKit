import Foundation

/// The abstract base type for ANY compound group of files/items (Public or Private).
/// Represents a logical unit that holds content.
public protocol InventoryCompoundBase: Sendable {
    /// Unique Identity.
    var id: UUID { get }
    var title: String { get }
    
    /// Description.
    var description: String? { get }
    
    /// Manufacturer.
    var manufacturer: (any InventoryManufacturer)? { get }
    
    /// Release Date.
    var releaseDate: Date? { get }
    
    /// The Data Source (Provider).
    /// Where did this description come from?
    var dataSource: (any InventoryDataSource)? { get }
    
    /// Children (Content).
    /// Represents the files or items contained within this unit.
    var children: [any InventoryItem] { get }
    
    /// Visual Representation (Images of the hardware/box).
    /// Represents separate image items associated with the product.
    var images: [any InventoryItem] { get }
}
