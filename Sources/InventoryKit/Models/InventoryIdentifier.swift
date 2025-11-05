import Foundation

/// Unique identifier metadata for an asset.
public struct InventoryIdentifier: Codable, Equatable, Hashable, Sendable {
    public var type: InventoryIdentifierType
    public var value: String

    public init(type: InventoryIdentifierType, value: String) {
        self.type = type
        self.value = value
    }
}

public enum InventoryIdentifierType: String, Codable, Sendable {
    case uuid
    case ulid
    case serialNumber
    case assetTag
    case sku
    case custom
}
