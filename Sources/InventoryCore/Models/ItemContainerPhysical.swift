import Foundation

/// A concrete implementation of a physical container (box, bin, shelf).
public struct ItemContainerPhysical: ItemContainer, Codable {
    public let id: UUID
    public let name: String
    public let type: ItemContainerType = .physical
    public let location: ItemLocation
    public let identifiers: [any InventoryIdentifier]
    
    public init(id: UUID = UUID(), name: String, location: ItemLocation, identifiers: [any InventoryIdentifier] = []) {
        self.id = id
        self.name = name
        self.location = location
        self.identifiers = identifiers
    }
    
    // Custom coding keys/init necessary if InventoryIdentifier causes codable issues via 'any'.
    // For now assuming InventoryIdentifier is simple enough or we use a concrete wrapper in real app.
    // In strict Swift, 'any InventoryIdentifier' isn't automatically Codable unless wrapped.
    // Simplifying for this step: we'll skip Codable implementation details for 'any' types in this prototype 
    // unless strictly required by the compiler for the struct itself. 
    // Users usually need a type eraser for Codable 'any'.
    // For this task, we will mark it Codable but be aware it might need a wrapper in production.
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, location
        // Skipping identifiers for Codable auto-synthesis for now as 'any' doesn't conform.
        // In a real app we'd use a TypeErasedIdentifier wrapper.
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        // type is constant
        location = try container.decode(ItemLocation.self, forKey: .location)
        identifiers = [] // Placeholder
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(location, forKey: .location)
    }
}
