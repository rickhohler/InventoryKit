import Foundation

/// A concrete implementation of InventoryIdentifier for use in Codable models.
public struct IdentifierModel: InventoryIdentifier, Codable, Sendable, Hashable {
    public let type: IdentifierType
    public let value: String
    
    public init(type: IdentifierType, value: String) {
        self.type = type
        self.value = value
    }
}
