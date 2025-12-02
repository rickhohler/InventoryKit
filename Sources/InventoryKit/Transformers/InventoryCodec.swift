import Foundation
import Yams

/// Internal codec for YAML serialization.
///
/// `InventoryCodec` provides low-level YAML encoding/decoding using the Yams library.
/// This is an internal implementation detail used by ``YAMLInventoryTransformer``.
///
/// - SeeAlso: ``YAMLInventoryTransformer`` for public YAML transformer
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct InventoryCodec: Sendable {
    public init() {}

    public func decode(
        from data: Data,
        validatingAgainst version: InventorySchemaVersion = .current
    ) throws -> InventoryDocument {
        guard let string = String(data: data, encoding: .utf8) else {
            throw InventoryError.unsupportedDataEncoding
        }
        return try decode(from: string, validatingAgainst: version)
    }

    public func decode(
        from string: String,
        validatingAgainst version: InventorySchemaVersion = .current
    ) throws -> InventoryDocument {
        let decoder = YAMLDecoder()
        do {
            let document = try decoder.decode(InventoryDocument.self, from: string)
            try document.ensureCompatibility(expected: version)
            return document
        } catch let error as InventoryError {
            throw error
        } catch {
            throw InventoryError.yamlDecodingFailed(error.localizedDescription)
        }
    }


    public func encode(_ document: InventoryDocument) throws -> String {
        let encoder = YAMLEncoder()
        do {
            return try encoder.encode(document)
        } catch {
            throw InventoryError.yamlEncodingFailed(error.localizedDescription)
        }
    }
}
