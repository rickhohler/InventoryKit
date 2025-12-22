import Foundation

/// Represents a specific room within a physical building.
public struct InventoryRoom: InventorySpace, Codable, Equatable {
    public let id: UUID
    public let name: String
    
    /// The floor level (e.g., 1 for ground, -1 for basement).
    public let level: Int
    
    /// The building this room belongs to.
    public let building: InventoryBuilding
    
    public let geoLocation: InventoryGeoLocation?
    
    public init(id: UUID = UUID(), name: String, level: Int = 0, building: InventoryBuilding, geoLocation: InventoryGeoLocation? = nil) {
        self.id = id
        self.name = name
        self.level = level
        self.building = building
        self.geoLocation = geoLocation
    }
}
