import Foundation

/// A physical container for storing items (e.g. Box, Bin, Shelf).
public struct ItemContainerPhysical: ItemContainer, Codable, Sendable {
    public let id: UUID
    public var name: String
    public let type: ItemContainerType = .physical
    public var location: ItemLocationType
    private var storedIdentifiers: [IdentifierModel]
    public var identifiers: [any InventoryIdentifier] { storedIdentifiers }
    
    // Physical specifics
    /// "Box", "Bin", "Shelf", "Room"
    public var role: String?
    
    public init(id: UUID = UUID(),
                name: String,
                location: ItemLocationType,
                identifiers: [IdentifierModel] = [],
                role: String? = nil) {
        self.id = id
        self.name = name
        self.location = location
        self.storedIdentifiers = identifiers
        self.role = role
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, location, role
        case storedIdentifiers = "identifiers"
    }
}
