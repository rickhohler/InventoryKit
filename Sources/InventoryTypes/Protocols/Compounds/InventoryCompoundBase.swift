import Foundation

/// The abstract base type for ANY compound group of files/items (Public or Private).
/// Represents a logical unit that holds content.
public protocol InventoryCompoundBase: Sendable {
    /// Unique Identity.
    var id: UUID { get set }
    var title: String { get set }
    
    /// Description.
    var description: String? { get set }
    
    /// Manufacturer.
    var manufacturer: (any Manufacturer)? { get set }
    
    /// Release Date.
    var releaseDate: Date? { get set }
    
    /// The Data Source (Provider).
    /// Where did this description come from?
    var dataSource: (any DataSource)? { get set }
    
    /// Children (Content).
    /// Represents the files or items contained within this unit.
    var children: [any InventoryItem] { get set }
    
    /// Visual Representation (Images of the hardware/box).
    /// Represents separate image items associated with the product.
    var images: [any InventoryItem] { get set }
}
