import Foundation

/// Represents a single asset that is tracked in the inventory.
///
/// `InventoryAsset` is the core model type representing any item tracked in an inventory.
/// It supports rich metadata including identifiers, lifecycle information, health status,
/// relationships, components, and custom tags.
///
/// ## Key Properties
///
/// - **Identifiers**: Multiple identifier types (UUID, ULID, serial number, etc.)
/// - **Lifecycle**: Track acquisition, ownership, and disposal
/// - **Health**: Physical condition and operational status
/// - **Relationships**: Link to related assets with requirements
/// - **Components**: Embed child assets (e.g., computer with installed cards)
/// - **Tags**: Domain-specific tags for categorization and processing
///
/// ## Usage
///
/// ```swift
/// let asset = InventoryAsset(
///     name: "Apple IIe",
///     type: "computer",
///     identifiers: [
///         InventoryIdentifier(type: .serialNumber, value: "A2S123456")
///     ],
///     tags: ["apple", "vintage", "computer"]
/// )
/// ```
///
/// - SeeAlso: ``InventoryDocument`` for document structure
/// - SeeAlso: ``InventoryIdentifier`` for identifier types
/// - SeeAlso: ``InventoryLifecycle`` for lifecycle tracking
/// - SeeAlso: ``InventoryHealth`` for health status
/// - SeeAlso: ``InventoryRelationshipRequirement`` for relationship modeling
/// - SeeAlso: ``InventoryAssetProtocol`` for protocol definition
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct InventoryAsset: InventoryAssetProtocol, Codable, Equatable, Hashable, Sendable, Identifiable {
    public let id: UUID
    public var identifiers: [InventoryIdentifier]
    public var name: String
    public var type: String?
    public var location: String?
    public var source: InventorySource?
    public var lifecycle: InventoryLifecycle?
    public var mro: InventoryMROInfo?
    public var health: InventoryHealth?
    public var components: [InventoryComponentLink]
    public var relationshipRequirements: [InventoryRelationshipRequirement]
    public var linkedAssets: [InventoryLinkedAsset]
    public var tags: [String]
    public var copyright: CopyrightInfo?
    public var metadata: [String: String]

    public init(
        id: UUID = UUID(),
        name: String,
        type: String? = nil,
        location: String? = nil,
        source: InventorySource? = nil,
        lifecycle: InventoryLifecycle? = nil,
        mro: InventoryMROInfo? = nil,
        health: InventoryHealth? = nil,
        components: [InventoryComponentLink] = [],
        relationshipRequirements: [InventoryRelationshipRequirement] = [],
        linkedAssets: [InventoryLinkedAsset] = [],
        identifiers: [InventoryIdentifier] = [],
        tags: [String] = [],
        copyright: CopyrightInfo? = nil,
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self.identifiers = identifiers.isEmpty ? InventoryAsset.defaultIdentifiers(for: id) : identifiers
        self.name = name
        self.type = type
        self.location = location
        self.source = source
        self.lifecycle = lifecycle
        self.mro = mro
        self.health = health
        self.components = components
        self.relationshipRequirements = relationshipRequirements
        self.linkedAssets = linkedAssets
        self.tags = tags
        self.copyright = copyright
        self.metadata = metadata
    }

    private static func defaultIdentifiers(for id: UUID) -> [InventoryIdentifier] {
        let ulid = InventoryULID().string
        return [
            InventoryIdentifier(type: .uuid, value: id.uuidString.lowercased()),
            InventoryIdentifier(type: .ulid, value: ulid)
        ]
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension InventoryAsset {
    private enum CodingKeys: String, CodingKey {
        case id
        case identifiers
        case name
        case type
        case location
        case source
        case lifecycle
        case mro
        case health
        case components
        case relationshipRequirements
        case linkedAssets
        case tags
        case copyright
        case metadata
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let identifiers = try container.decodeIfPresent([InventoryIdentifier].self, forKey: .identifiers) ?? []
        let name = try container.decode(String.self, forKey: .name)
        let type = try container.decodeIfPresent(String.self, forKey: .type)
        let location = try container.decodeIfPresent(String.self, forKey: .location)
        let source = try container.decodeIfPresent(InventorySource.self, forKey: .source)
        let lifecycle = try container.decodeIfPresent(InventoryLifecycle.self, forKey: .lifecycle)
        let mro = try container.decodeIfPresent(InventoryMROInfo.self, forKey: .mro)
        let health = try container.decodeIfPresent(InventoryHealth.self, forKey: .health)
        let components = try container.decodeIfPresent([InventoryComponentLink].self, forKey: .components) ?? []
        let relationshipRequirements = try container.decodeIfPresent([InventoryRelationshipRequirement].self, forKey: .relationshipRequirements) ?? []
        let linkedAssets = try container.decodeIfPresent([InventoryLinkedAsset].self, forKey: .linkedAssets) ?? []
        let tags = try container.decodeIfPresent([String].self, forKey: .tags) ?? []
        let copyright = try container.decodeIfPresent(CopyrightInfo.self, forKey: .copyright)
        let metadata = try container.decodeIfPresent([String: String].self, forKey: .metadata) ?? [:]

        self.init(
            id: id,
            name: name,
            type: type,
            location: location,
            source: source,
            lifecycle: lifecycle,
            mro: mro,
            health: health,
            components: components,
            relationshipRequirements: relationshipRequirements,
            linkedAssets: linkedAssets,
            identifiers: identifiers,
            tags: tags,
            copyright: copyright,
            metadata: metadata
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        if !identifiers.isEmpty {
            try container.encode(identifiers, forKey: .identifiers)
        }
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(lifecycle, forKey: .lifecycle)
        try container.encodeIfPresent(mro, forKey: .mro)
        try container.encodeIfPresent(health, forKey: .health)
        if !components.isEmpty {
            try container.encode(components, forKey: .components)
        }
        if !relationshipRequirements.isEmpty {
            try container.encode(relationshipRequirements, forKey: .relationshipRequirements)
        }
        if !linkedAssets.isEmpty {
            try container.encode(linkedAssets, forKey: .linkedAssets)
        }
        if !tags.isEmpty {
            try container.encode(tags, forKey: .tags)
        }
        if let copyright = copyright {
            try container.encode(copyright, forKey: .copyright)
        }
        if !metadata.isEmpty {
            try container.encode(metadata, forKey: .metadata)
        }
    }
}
