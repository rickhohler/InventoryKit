import Foundation

/// Represents an entire inventory document that contains a schema version, optional metadata, and the tracked assets.
///
/// `InventoryDocument` is the top-level container for an inventory. It includes:
/// - Schema version for compatibility checking
/// - Document metadata (title, description, etc.)
/// - Custom metadata dictionary
/// - Relationship type definitions
/// - Collection of assets
///
/// ## Schema Versioning
///
/// Documents include a schema version to enable compatibility checking during deserialization.
/// Use `ensureCompatibility(expected:)` to validate schema compatibility before processing.
///
/// ## Usage
///
/// ```swift
/// let document = InventoryDocument(
///     schemaVersion: .current,
///     info: InventoryDocumentInfo(title: "My Collection"),
///     assets: [asset1, asset2, asset3]
/// )
/// ```
///
/// - SeeAlso: ``InventorySchemaVersion`` for schema versioning
/// - SeeAlso: ``InventoryAsset`` for asset model
/// - SeeAlso: ``InventoryDocumentInfo`` for document metadata
/// - SeeAlso: ``InventoryDataTransformer`` for serialization
/// - SeeAlso: ``InventoryDocumentProtocol`` for protocol definition
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct InventoryDocument: InventoryDocumentProtocol, Codable, Sendable {
    public var schemaVersion: InventorySchemaVersion
    public var info: InventoryDocumentInfo?
    public var metadata: [String: String]
    public var relationshipTypes: [InventoryRelationshipType]
    public var assets: [any InventoryAssetProtocol]
    
    /// Convenience initializer that accepts concrete `InventoryAsset` types.
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
        self.assets = assets.map { $0 as any InventoryAssetProtocol }
    }
    
    /// Protocol-compliant initializer for protocol-based assets.
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
    }

    public func ensureCompatibility(expected version: InventorySchemaVersion = .current) throws {
        guard schemaVersion.isCompatible(with: version) else {
            throw InventoryError.schemaIncompatible(expected: version, actual: schemaVersion)
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension InventoryDocument: Equatable {
    public static func == (lhs: InventoryDocument, rhs: InventoryDocument) -> Bool {
        lhs.schemaVersion == rhs.schemaVersion &&
        lhs.info == rhs.info &&
        lhs.metadata == rhs.metadata &&
        lhs.relationshipTypes == rhs.relationshipTypes &&
        lhs.assets.count == rhs.assets.count &&
        zip(lhs.assets, rhs.assets).allSatisfy { left, right in
            left.id == right.id &&
            left.name == right.name &&
            left.identifiers == right.identifiers
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
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
        let concreteAssets = try container.decodeIfPresent([InventoryAsset].self, forKey: .assets) ?? []
        assets = concreteAssets.map { $0 as any InventoryAssetProtocol }
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
        // Convert protocol assets to concrete types for encoding
        let concreteAssets = assets.compactMap { $0 as? InventoryAsset }
        try container.encode(concreteAssets, forKey: .assets)
    }
}
