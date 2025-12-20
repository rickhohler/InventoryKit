import Foundation

/// Protocol for a generic identifier for inventory items.
public protocol InventoryIdentifierProtocol: Sendable, Codable {
    /// The type of identifier (e.g., "upc", "asin", "serial").
    var type: InventoryIdentifierType { get }
    
    /// The identifier value.
    var value: String { get }
}
