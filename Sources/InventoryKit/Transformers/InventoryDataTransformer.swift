import Foundation

/// Supported inventory serialization formats.
public enum InventoryDataFormat: String, Codable, Sendable {
    case yaml
    case json
}

/// Abstraction over encoding and decoding inventory documents.
public protocol InventoryDataTransformer: Sendable {
    var format: InventoryDataFormat { get }
    func decode(_ data: Data, validatingAgainst version: InventorySchemaVersion) throws -> InventoryDocument
    func encode(_ document: InventoryDocument) throws -> Data
}

/// Type-erased wrapper so call-sites can keep collections of transformers.
public struct AnyInventoryDataTransformer: InventoryDataTransformer {
    public let format: InventoryDataFormat

    private let decodeClosure: @Sendable (Data, InventorySchemaVersion) throws -> InventoryDocument
    private let encodeClosure: @Sendable (InventoryDocument) throws -> Data

    public init<T: InventoryDataTransformer>(_ base: T) {
        format = base.format
        decodeClosure = base.decode
        encodeClosure = base.encode
    }

    public func decode(_ data: Data, validatingAgainst version: InventorySchemaVersion) throws -> InventoryDocument {
        try decodeClosure(data, version)
    }

    public func encode(_ document: InventoryDocument) throws -> Data {
        try encodeClosure(document)
    }
}
