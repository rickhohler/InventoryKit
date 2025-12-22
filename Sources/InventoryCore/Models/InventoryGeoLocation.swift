import Foundation

/// A simple structure representing a geographical location.
/// Used to tag physical spaces or items with GPS coordinates.
public struct InventoryGeoLocation: Sendable, Codable, Equatable {
    /// The latitude in degrees.
    public let latitude: Double
    
    /// The longitude in degrees.
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
