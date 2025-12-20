import Foundation
@_exported import InventoryCore

/// Convenience namespace that surfaces common helpers for consumers that prefer static access.
///
/// `InventoryKit` provides static methods for common operations like decoding/encoding
/// inventory documents, creating catalogs, and bootstrapping services. This namespace
/// is ideal for consumers who prefer functional-style APIs over instance-based APIs.
///
/// ## Usage
///
/// ```swift
/// // Decode from data
/// let document = try InventoryKit.decodeInventory(from: data, format: .yaml)
///
/// // Create catalog from data
/// let catalog = try InventoryKit.catalog(from: data, format: .yaml)
///
/// // Bootstrap service
/// let service = try await InventoryKit.service(configuration: configuration)
/// ```
///
/// - SeeAlso: ``InventoryService`` for instance-based service operations
/// - SeeAlso: ``InventoryCatalog`` for catalog operations
/// - SeeAlso: ``InventoryDataTransformer`` for custom serialization
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public enum InventoryKitInfo {
    private static let yamlTransformer = AnyInventoryDataTransformer(YAMLInventoryTransformer())
    private static let jsonTransformer = AnyInventoryDataTransformer(JSONInventoryTransformer())

    public static func transformer(for format: InventoryDataFormat) -> AnyInventoryDataTransformer {
        switch format {
        case .yaml:
            return yamlTransformer
        case .json:
            return jsonTransformer
        }
    }

    public static func decodeInventory(
        from data: Data,
        format: InventoryDataFormat = .yaml,
        validatingAgainst version: InventorySchemaVersion = .current
    ) throws -> InventoryDocument {
        let doc = try transformer(for: format).decode(data, validatingAgainst: version)
        guard let concrete = doc as? InventoryDocument else {
             // Fallback: Attempt to construct concrete from protocol (lossy?)
             return InventoryDocument(
                 schemaVersion: doc.schemaVersion,
                 info: doc.info,
                 protocolAssets: doc.assets
             )
        }
        return concrete
    }

    public static func decodeInventory(
        from string: String,
        format: InventoryDataFormat = .yaml,
        validatingAgainst version: InventorySchemaVersion = .current
    ) throws -> InventoryDocument {
        guard let data = string.data(using: .utf8) else {
            throw InventoryError.unsupportedDataEncoding
        }
        return try decodeInventory(from: data, format: format, validatingAgainst: version)
    }


    public static func encodeInventory(
        _ document: InventoryDocument,
        format: InventoryDataFormat = .yaml
    ) throws -> Data {
        try transformer(for: format).encode(document)
    }

    public static func encodeInventoryString(
        _ document: InventoryDocument,
        format: InventoryDataFormat = .yaml
    ) throws -> String {
        let data = try encodeInventory(document, format: format)
        guard let string = String(data: data, encoding: .utf8) else {
            throw InventoryError.unsupportedDataEncoding
        }
        return string
    }

    // MARK: - Catalog Helpers

    public static func catalog(
        from data: Data,
        format: InventoryDataFormat = .yaml,
        validatingAgainst version: InventorySchemaVersion = .current
    ) throws -> InventoryCatalog {
        let document = try decodeInventory(from: data, format: format, validatingAgainst: version)
        return InventoryCatalog(document: document)
    }


    public static func encodeCatalog(
        _ catalog: InventoryCatalog,
        format: InventoryDataFormat = .yaml
    ) async throws -> Data {
        let document = await catalog.snapshotDocument()
        return try encodeInventory(document, format: format)
    }

    public static func encodeCatalogString(
        _ catalog: InventoryCatalog,
        format: InventoryDataFormat = .yaml
    ) async throws -> String {
        let data = try await encodeCatalog(catalog, format: format)
        guard let string = String(data: data, encoding: .utf8) else {
            throw InventoryError.unsupportedDataEncoding
        }
        return string
    }
    public static func catalog(from provider: InventoryStorageProvider, validatingAgainst version: InventorySchemaVersion = .current) async throws -> InventoryCatalog {
        let doc = try await provider.loadInventory(validatingAgainst: version)
        guard let document = doc as? InventoryDocument else {
             // Fallback construct
             return InventoryCatalog(document: InventoryDocument(
                 schemaVersion: doc.schemaVersion,
                 info: doc.info,
                 protocolAssets: doc.assets
             ))
        }
        return InventoryCatalog(document: document)
    }

    public static func persist(_ catalog: InventoryCatalog, to provider: InventoryStorageProvider) async throws {
        let document = await catalog.snapshotDocument()
        try await provider.saveInventory(document)
    }

    // MARK: - Service bootstrap

    public static func service(configuration: InventoryConfiguration) async throws -> InventoryService {
        try await InventoryService.bootstrap(configuration: configuration)
    }
}
