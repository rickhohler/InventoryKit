import Foundation

/// Represents a physical building where inventory is stored (e.g., "Main House", "Warehouse").
public struct InventoryBuilding: InventorySpace, Codable, Equatable {
    public let id: UUID
    public let name: String
    
    /// Physical address of the building.
    public let address: String?
    
    public let geoLocation: InventoryGeoLocation?
    
    public init(id: UUID = UUID(), name: String, address: String? = nil, geoLocation: InventoryGeoLocation? = nil) {
        self.id = id
        self.name = name
        self.address = address
        self.geoLocation = geoLocation
    }
}
