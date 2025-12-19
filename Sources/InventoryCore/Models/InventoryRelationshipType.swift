import Foundation

/// Describes a named relationship type that can be referenced by requirements and links.
public struct InventoryRelationshipType: Codable, Equatable, Hashable, Sendable {
    public let id: String
    public var displayName: String
    public var description: String?

    public init(id: String, displayName: String, description: String? = nil) {
        self.id = id
        self.displayName = displayName
        self.description = description
    }
}
