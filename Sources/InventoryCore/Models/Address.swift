import Foundation

/// Structured address information.
public struct Address: Codable, Sendable, Hashable, Identifiable {
    public var id: UUID
    public var label: String?     // e.g. "Headquarters", "Warehouse", "1980s Office"
    public var address: String    // Street address
    public var address2: String?
    public var city: String?
    public var region: String?    // State/Province
    public var postalCode: String?
    public var country: String?
    public var notes: String?
    
    /// Reference IDs to photos of the office/location (InventoryItem UUIDs).
    public var imageIDs: [UUID]
    
    public init(id: UUID = UUID(),
                label: String? = nil,
                address: String,
                address2: String? = nil,
                city: String? = nil,
                region: String? = nil,
                postalCode: String? = nil,
                country: String? = nil,
                notes: String? = nil,
                imageIDs: [UUID] = []) {
        self.id = id
        self.label = label
        self.address = address
        self.address2 = address2
        self.city = city
        self.region = region
        self.postalCode = postalCode
        self.country = country
        self.notes = notes
        self.imageIDs = imageIDs
    }
}
