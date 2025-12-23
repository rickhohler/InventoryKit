import Foundation
import InventoryCore
import InventoryTypes

public struct MockManufacturer: Manufacturer, Sendable {
    public var id: UUID
    public var name: String
    public var slug: String
    public var aliases: [String]
    public var alsoKnownAs: [String] = []
    public var alternativeSpellings: [String] = []
    public var commonMisspellings: [String] = []
    public var description: String?
    public var metadata: [String: String]
    public var website: URL?
    public var email: String?
    
    public var addresses: [any Address] = []
    public var associatedPeople: [any Contact] = []
    public var developers: [any Contact] = []
    
    public init(
        id: UUID = UUID(),
        name: String,
        slug: String = "",
        aliases: [String] = [],
        description: String? = nil,
        metadata: [String: String] = [:],
        website: URL? = nil,
        email: String? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.aliases = aliases
        self.description = description
        self.metadata = metadata
        self.website = website
        self.email = email
    }
}
