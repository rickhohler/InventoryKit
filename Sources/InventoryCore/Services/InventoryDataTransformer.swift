import Foundation

/// Supported inventory serialization formats.
///
/// InventoryKit supports YAML and JSON formats for serialization. YAML is the default
/// format and provides better readability for human-edited files. JSON is useful for
/// programmatic APIs and web services.
///
/// - SeeAlso: ``InventoryDataTransformer`` for transformer implementations
public enum InventoryDataFormat: String, Codable, Sendable {
    case yaml
    case json
}

/// Abstraction over encoding and decoding inventory documents.
///
/// `InventoryDataTransformer` defines the protocol for serializing and deserializing
/// inventory documents. Implementations handle format-specific encoding/decoding logic.
///
/// InventoryKit provides default implementations in the main module.
///
/// - SeeAlso: ``InventoryDocumentProtocol`` for document structure
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryDataTransformer: Sendable {
    var format: InventoryDataFormat { get }
    func decode(_ data: Data, validatingAgainst version: InventorySchemaVersion) throws -> any InventoryDocumentProtocol
    func encode(_ document: any InventoryDocumentProtocol) throws -> Data
}

/// Type-erased wrapper so call-sites can keep collections of transformers.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct AnyInventoryDataTransformer: InventoryDataTransformer {
    public let format: InventoryDataFormat

    private let decodeClosure: @Sendable (Data, InventorySchemaVersion) throws -> any InventoryDocumentProtocol
    private let encodeClosure: @Sendable (any InventoryDocumentProtocol) throws -> Data

    public init<T: InventoryDataTransformer>(_ base: T) {
        format = base.format
        decodeClosure = base.decode
        encodeClosure = base.encode
    }

    public func decode(_ data: Data, validatingAgainst version: InventorySchemaVersion) throws -> any InventoryDocumentProtocol {
        try decodeClosure(data, version)
    }

    public func encode(_ document: any InventoryDocumentProtocol) throws -> Data {
        try encodeClosure(document)
    }
}
