import Foundation
import InventoryCore

/// Represents an entire inventory document that contains a schema version, optional metadata, and the tracked assets.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct InventoryDocument: InventoryDocumentProtocol, Codable, Sendable {
    public var schemaVersion: InventorySchemaVersion
    public var info: InventoryDocumentInfo?
    public var metadata: [String: String]
    public var relationshipTypes: [InventoryRelationshipType]
    public var assets: [any InventoryAssetProtocol]
    
    // Internal concrete storage for Codable
    private var concreteAssets: [AnyInventoryAsset]

    public init(
        schemaVersion: InventorySchemaVersion = .current,
        info: InventoryDocumentInfo? = nil,
        metadata: [String: String] = [:],
        relationshipTypes: [InventoryRelationshipType] = [],
        assets: [AnyInventoryAsset]
    ) {
        self.schemaVersion = schemaVersion
        self.info = info
        self.metadata = metadata
        self.relationshipTypes = relationshipTypes
        self.concreteAssets = assets
        self.assets = assets
    }
    
    /// Protocol-compliant initializer
    public init(
        schemaVersion: InventorySchemaVersion = .current,
        info: InventoryDocumentInfo? = nil,
        metadata: [String: String] = [:],
        relationshipTypes: [InventoryRelationshipType] = [],
        protocolAssets: [any InventoryAssetProtocol]
    ) {
        self.schemaVersion = schemaVersion
        self.info = info
        self.metadata = metadata
        self.relationshipTypes = relationshipTypes
        self.assets = protocolAssets
        // Convert to concrete
        self.concreteAssets = protocolAssets.map { AnyInventoryAsset($0) }
    }
    
    private enum CodingKeys: String, CodingKey {
        case schemaVersion, info, metadata, relationshipTypes, assets
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        schemaVersion = try container.decode(InventorySchemaVersion.self, forKey: .schemaVersion)
        info = try container.decodeIfPresent(InventoryDocumentInfo.self, forKey: .info)
        metadata = try container.decodeIfPresent([String: String].self, forKey: .metadata) ?? [:]
        relationshipTypes = try container.decodeIfPresent([InventoryRelationshipType].self, forKey: .relationshipTypes) ?? []
        concreteAssets = try container.decodeIfPresent([AnyInventoryAsset].self, forKey: .assets) ?? []
        assets = concreteAssets
    }

    public func ensureCompatibility(expected version: InventorySchemaVersion = .current) throws {
        guard schemaVersion.isCompatible(with: version) else {
            throw InventoryError.schemaIncompatible(expected: version, actual: schemaVersion)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(schemaVersion, forKey: .schemaVersion)
        try container.encodeIfPresent(info, forKey: .info)
        if !metadata.isEmpty { try container.encode(metadata, forKey: .metadata) }
        if !relationshipTypes.isEmpty { try container.encode(relationshipTypes, forKey: .relationshipTypes) }
        // Encode concrete assets
        // Update concreteAssets from self.assets in case they changed?
        // But self.assets is constant in usage usually. 
        // We will map self.assets to concrete on encode to be safe.
        let toEncode = assets.map { $0 as? AnyInventoryAsset ?? AnyInventoryAsset($0) }
        try container.encode(toEncode, forKey: .assets)
    }
}
