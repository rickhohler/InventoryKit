import Foundation

/// Protocol representing a Manufacturer (Creator/Publisher) entity.
/// Allows for various storage implementations (CloudKit, SwiftData, etc.).
public protocol InventoryManufacturerProtocol: Sendable {
    var id: UUID { get }
    var name: String { get }
    
    /// Alternate names or aliases (e.g., "Apple Computer, Inc.", "Apple").
    var aliases: [String] { get }
    
    /// Description or history of the manufacturer.
    var description: String? { get }
}
