import Foundation

/// Represents an entire YAML document that contains a schema version, optional metadata, and the tracked assets.
public struct InventoryDocument: Codable, Equatable, Sendable {
    public var schemaVersion: InventorySchemaVersion
    public var info: InventoryDocumentInfo?
    public var metadata: [String: String]
    public var relationshipTypes: [InventoryRelationshipType]
    public var assets: [InventoryAsset]

    public init(
        schemaVersion: InventorySchemaVersion = .current,
        info: InventoryDocumentInfo? = nil,
        metadata: [String: String] = [:],
        relationshipTypes: [InventoryRelationshipType] = [],
        assets: [InventoryAsset]
    ) {
        self.schemaVersion = schemaVersion
        self.info = info
        self.metadata = metadata
        self.relationshipTypes = relationshipTypes
        self.assets = assets
    }

    public func ensureCompatibility(expected version: InventorySchemaVersion = .current) throws {
        guard schemaVersion.isCompatible(with: version) else {
            throw InventoryError.schemaIncompatible(expected: version, actual: schemaVersion)
        }
    }
}

extension InventoryDocument {
    private enum CodingKeys: String, CodingKey {
        case schemaVersion
        case info
        case metadata
        case relationshipTypes
        case assets
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        schemaVersion = try container.decode(InventorySchemaVersion.self, forKey: .schemaVersion)
        info = try container.decodeIfPresent(InventoryDocumentInfo.self, forKey: .info)
        metadata = try container.decodeIfPresent([String: String].self, forKey: .metadata) ?? [:]
        relationshipTypes = try container.decodeIfPresent([InventoryRelationshipType].self, forKey: .relationshipTypes) ?? []
        assets = try container.decodeIfPresent([InventoryAsset].self, forKey: .assets) ?? []
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(schemaVersion, forKey: .schemaVersion)
        try container.encodeIfPresent(info, forKey: .info)
        if !metadata.isEmpty {
            try container.encode(metadata, forKey: .metadata)
        }
        if !relationshipTypes.isEmpty {
            try container.encode(relationshipTypes, forKey: .relationshipTypes)
        }
        try container.encode(assets, forKey: .assets)
    }
}
