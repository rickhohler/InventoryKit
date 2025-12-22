import Foundation

/// A concrete implementation of a digital container (folder).
public struct ItemContainerDigital: ItemContainer, Codable {
    public let id: UUID
    public let name: String
    public let type: ItemContainerType = .digital
    public let location: ItemLocation
    public let identifiers: [any InventoryIdentifier]
    
    public init(id: UUID = UUID(), name: String, location: ItemLocation, identifiers: [any InventoryIdentifier] = []) {
        self.id = id
        self.name = name
        self.location = location
        self.identifiers = identifiers
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, location
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        location = try container.decode(ItemLocation.self, forKey: .location)
        identifiers = []
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(location, forKey: .location)
    }
}
