import Foundation

/// Represents a digital storage volume (e.g., Hard Drive, Cloud Storage, NAS).
public struct InventoryVolume: InventorySpace, Codable, Equatable {
    public let id: UUID
    public let name: String
    
    /// The root URI of the volume (e.g., "file:///Volumes/Data").
    public let uri: URL
    
    /// Optional geographical location (e.g., server location).
    public let geoLocation: InventoryGeoLocation?
    
    public init(id: UUID = UUID(), name: String, uri: URL, geoLocation: InventoryGeoLocation? = nil) {
        self.id = id
        self.name = name
        self.uri = uri
        self.geoLocation = geoLocation
    }
}
