import Foundation

/// Represents a container that holds inventory items.
/// Can be a physical box/bin or a digital folder/archive.
public protocol ItemContainer: Sendable, Identifiable {
    var id: UUID { get }
    
    /// The name of the container (e.g. "Box A", "Apple II Games").
    var name: String { get }
    
    /// The type of container (physical vs digital).
    var type: ItemContainerType { get }
    
    /// The location of this container.
    var location: ItemLocationType { get }
    
    /// Scannable identifiers for this container (NFC, Barcode, QR).
    var identifiers: [any InventoryIdentifier] { get }
}
