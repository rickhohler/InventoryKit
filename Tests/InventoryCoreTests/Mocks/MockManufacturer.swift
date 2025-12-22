import Foundation
import InventoryCore

public struct MockManufacturer: InventoryManufacturer, Sendable {
    public let id: UUID
    public let name: String
    public let aliases: [String]
    public let description: String?
    public var metadata: [String: String]
    public let website: URL?
    public let supportEmail: String?
    
    public init(
        id: UUID = UUID(),
        name: String,
        aliases: [String] = [],
        description: String? = nil,
        metadata: [String: String] = [:],
        website: URL? = nil,
        supportEmail: String? = nil
    ) {
        self.id = id
        self.name = name
        self.aliases = aliases
        self.description = description
        self.metadata = metadata
        self.website = website
        self.supportEmail = supportEmail
    }
}
