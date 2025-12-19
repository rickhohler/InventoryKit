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

    public func decode(_ data: Data, validatingAgainst version: InventorySchemaVersion) throws -> InventoryDocument {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let document = try decoder.decode(InventoryDocument.self, from: data)
        try document.ensureCompatibility(expected: version)
        return document
    }

    public func encode(_ document: InventoryDocument) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(document)
    }
}
