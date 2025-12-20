import Foundation
import InventoryCore

/// JSON format transformer for inventory documents.
///
/// `JSONInventoryTransformer` provides JSON serialization for inventory documents using Foundation's `JSONEncoder`/`JSONDecoder`.
/// This is an implementation detail - prefer using ``InventoryKit/transformer(for:)`` to obtain transformers.
///
/// ## Usage
///
/// ```swift
/// // Prefer using the facade
/// let transformer = InventoryKit.transformer(for: .json)
///
/// // Or create directly if needed
/// let jsonTransformer = JSONInventoryTransformer()
/// ```
///
/// - SeeAlso: ``InventoryDataTransformer`` for protocol requirements
/// - SeeAlso: ``InventoryKit/transformer(for:)`` for recommended access pattern
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct JSONInventoryTransformer: InventoryDataTransformer {
    public var format: InventoryDataFormat { .json }

    public init() {}

    public func decode(_ data: Data, validatingAgainst version: InventorySchemaVersion) throws -> any InventoryDocumentProtocol {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let document = try decoder.decode(InventoryDocument.self, from: data)
        try document.ensureCompatibility(expected: version)
        return document
    }

    public func encode(_ document: any InventoryDocumentProtocol) throws -> Data {
        // Note: metadata copy missing in abbreviated init?
        // InventoryDocument init from protocol assets handles metadata if passed.
        // We really want the FULL copy.
        // Let's rely on InventoryDocument(protocolAssets:) which I created in Step 779.
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        
        // If it's already concrete, use it. If not, use wrapper.
        // If use Protocol Init, it copies everything?
        // InventoryDocument init Step 779:
        // init(..., protocolAssets: ...) { ... self.assets = protocolAssets ... }
        // Wait, metadata? The init takes metadata.
        // Accessing metdata from `document: any Protocol`?
        // InventoryDocumentProtocol does NOT have `metadata` property (Step 448).
        // InventoryDocumentProtocol HAS `info`.
        // If metadata is missing from Protocol, we LOSE it if we convert.
        // But `InventoryDocument` has it.
        // Assuming we mostly deal with `InventoryDocument`, we cast.
        
        if let concreteDoc = document as? InventoryDocument {
            return try encoder.encode(concreteDoc)
        }
        
        // Fallback: Create generic document from protocol.
        // Warning: Data loss for non-protocol properties (metadata, relationships).
        let wrapper = InventoryDocument(
            schemaVersion: document.schemaVersion,
            info: document.info,
            protocolAssets: document.assets
        )
        return try encoder.encode(wrapper)
    }
}
