import Foundation

/// A concrete implementation of a Building (Physical Location).
public struct InventoryBuilding: Building, Codable, Sendable {
    public var id: UUID
    public var name: String
    public var geoLocation: InventoryGeoLocation?
    public var address: String?
    
    public init(id: UUID = UUID(), name: String, geoLocation: InventoryGeoLocation? = nil, address: String? = nil) {
        self.id = id
        self.name = name
        self.geoLocation = geoLocation
        self.address = address
    }
}
