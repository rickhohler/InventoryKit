import Foundation

/// Convenience namespace that surfaces common helpers for consumers that prefer static access.
public enum InventoryKit {
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
        try transformer(for: format).decode(data, validatingAgainst: version)
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

    public static func decodeInventory(
        contentsOf url: URL,
        format: InventoryDataFormat = .yaml,
        validatingAgainst version: InventorySchemaVersion = .current
    ) throws -> InventoryDocument {
        guard let data = FileManager.default.contents(atPath: url.path) else {
            throw InventoryError.unreadableFile(url)
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

    public static func catalog(
        contentsOf url: URL,
        format: InventoryDataFormat = .yaml,
        validatingAgainst version: InventorySchemaVersion = .current
    ) throws -> InventoryCatalog {
        guard let data = FileManager.default.contents(atPath: url.path) else {
            throw InventoryError.unreadableFile(url)
        }
        return try catalog(from: data, format: format, validatingAgainst: version)
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
        let document = try await provider.loadInventory(validatingAgainst: version)
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
