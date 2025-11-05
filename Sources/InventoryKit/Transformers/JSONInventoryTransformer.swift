import Foundation

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
