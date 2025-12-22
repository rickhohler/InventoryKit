import Foundation

/// Structured address information.
/// Structured address information.
public protocol InventoryAddress: Codable, Sendable, Identifiable {
    var id: UUID { get set }
    var label: String? { get set }    // e.g. "Headquarters", "Warehouse", "1980s Office"
    var address: String { get set }   // Street address
    var address2: String? { get set }
    var city: String? { get set }
    var region: String? { get set }   // State/Province
    var postalCode: String? { get set }
    var country: String? { get set }
    var notes: String? { get set }
    
    /// Reference IDs to photos of the office/location (InventoryItem UUIDs).
    var imageIDs: [UUID] { get }
}
