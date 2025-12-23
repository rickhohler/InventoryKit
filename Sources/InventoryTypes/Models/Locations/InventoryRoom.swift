import Foundation

/// A concrete implementation of a Room (Physical Location).
public struct InventoryRoom: Room, Codable, Sendable {
    public var id: UUID
    public var name: String
    public var geoLocation: InventoryGeoLocation?
    public var level: Int
    /// The building this room belongs to. Note: Stored as concrete struct for Codable support?
    /// Protocol 'Room' defines 'var building: any Building'.
    /// Codable structs usually require concrete types.
    /// We can store `InventoryBuilding`.
    public var building: any Building {
        get { _building }
        set {
            guard let valid = newValue as? InventoryBuilding else {
                // For now, enforce concrete type.
                fatalError("InventoryRoom requires InventoryBuilding")
            }
            _building = valid
        }
    }
    private var _building: InventoryBuilding
    
    // Explicit Generic Coding logic might be needed if "any Building" is required for polymorphism,
    // but typically we use concrete types in models.
    
    public init(id: UUID = UUID(), name: String, geoLocation: InventoryGeoLocation? = nil, level: Int = 0, building: InventoryBuilding) {
        self.id = id
        self.name = name
        self.geoLocation = geoLocation
        self.level = level
        self._building = building
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, geoLocation, level, building = "_building"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        geoLocation = try container.decodeIfPresent(InventoryGeoLocation.self, forKey: .geoLocation)
        level = try container.decode(Int.self, forKey: .level)
        _building = try container.decode(InventoryBuilding.self, forKey: .building)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(geoLocation, forKey: .geoLocation)
        try container.encode(level, forKey: .level)
        try container.encode(_building, forKey: .building)
    }
}
