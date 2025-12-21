import Foundation

/// The abstract base type for ANY compound group of files/items (Public or Private).
/// Represents a logical unit that holds content.
public protocol InventoryCompoundBaseProtocol: Sendable {
    // MARK: - Identity
    var id: UUID { get }
    var title: String { get }
    var description: String? { get }
    
    // MARK: - Metadata
    var manufacturer: (any InventoryManufacturer)? { get }
    var releaseDate: Date? { get }
    var tags: [String] { get }
    
    /// The canonical product definition this asset represents.
    var product: (any InventoryProduct)? { get }
    
    // MARK: - Structure
    /// The content parts (files, hardware components).
    var children: [any InventoryItem] { get }
    
    // MARK: - Visual Representation
    /// Visual assets (photos of box, hardware, screenshots).
    var images: [any InventoryItem] { get }
    
    // MARK: - Source
    /// The provider of this description/data.
    var dataSource: (any InventoryDataSource)? { get }
}
