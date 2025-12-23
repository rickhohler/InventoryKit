import Foundation

/// A digital container for logical grouping (e.g. Folder, Archive, Playlist).
public struct ItemContainerDigital: ItemContainer, Codable, Sendable {
    public let id: UUID
    public var name: String
    public let type: ItemContainerType = .digital
    public var location: ItemLocationType
    private var storedIdentifiers: [IdentifierModel]
    public var identifiers: [any InventoryIdentifier] { storedIdentifiers }
    
    // Digital specifics
    /// "Folder", "ZIP", "DiskImage"
    public var format: String?
    
    /// Filesystem path (relative or absolute)
    public var path: String?
    
    public init(id: UUID = UUID(),
                name: String,
                location: ItemLocationType,
                identifiers: [IdentifierModel] = [],
                format: String? = nil,
                path: String? = nil) {
        self.id = id
        self.name = name
        self.location = location
        self.storedIdentifiers = identifiers
        self.format = format
        self.path = path
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, location, format, path
        case storedIdentifiers = "identifiers"
    }
}
