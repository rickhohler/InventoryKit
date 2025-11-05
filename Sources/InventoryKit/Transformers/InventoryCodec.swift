import Foundation
import Yams

/// Provides helpers to decode and encode YAML inventory documents.
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

    public func decode(
        contentsOf url: URL,
        validatingAgainst version: InventorySchemaVersion = .current
    ) throws -> InventoryDocument {
        guard let data = FileManager.default.contents(atPath: url.path) else {
            throw InventoryError.unreadableFile(url)
        }
        return try decode(from: data, validatingAgainst: version)
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
