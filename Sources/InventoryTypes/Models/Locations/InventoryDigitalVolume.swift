import Foundation

/// A concrete implementation of a DigitalVolume (Digital Location).
public struct InventoryDigitalVolume: DigitalVolume, Codable, Sendable {
    public var id: UUID
    public var name: String
    public var geoLocation: InventoryGeoLocation? // Server location?
    public var uri: URL
    
    public init(id: UUID = UUID(), name: String, geoLocation: InventoryGeoLocation? = nil, uri: URL) {
        self.id = id
        self.name = name
        self.geoLocation = geoLocation
        self.uri = uri
    }
}
