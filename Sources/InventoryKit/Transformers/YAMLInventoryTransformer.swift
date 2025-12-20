import Foundation
import InventoryCore

/// YAML format transformer for inventory documents.
///
/// `YAMLInventoryTransformer` provides YAML serialization for inventory documents using the Yams library.
/// This is an implementation detail - prefer using ``InventoryKit/transformer(for:)`` to obtain transformers.
///
/// ## Usage
///
/// ```swift
/// // Prefer using the facade
/// let transformer = InventoryKit.transformer(for: .yaml)
///
/// // Or create directly if needed
/// let yamlTransformer = YAMLInventoryTransformer()
/// ```
///
/// - SeeAlso: ``InventoryDataTransformer`` for protocol requirements
/// - SeeAlso: ``InventoryKit/transformer(for:)`` for recommended access pattern
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct YAMLInventoryTransformer: InventoryDataTransformer {
    private let codec: InventoryCodec

    public init(codec: InventoryCodec = InventoryCodec()) {
        self.codec = codec
    }

    public var format: InventoryDataFormat { .yaml }

    public func decode(_ data: Data, validatingAgainst version: InventorySchemaVersion) throws -> any InventoryDocumentProtocol {
        try codec.decode(from: data, validatingAgainst: version)
    }

    public func encode(_ document: any InventoryDocumentProtocol) throws -> Data {
        // Codec expects concrete InventoryDocument
        let concrete = document as? InventoryDocument ?? InventoryDocument(
            schemaVersion: document.schemaVersion,
            info: document.info,
            protocolAssets: document.assets
        )
        let string = try codec.encode(concrete)
        return Data(string.utf8)
    }
}
