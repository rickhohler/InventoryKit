import Foundation

/// Plain-text storage provider useful for local development/testing.
public actor TextFileInventoryStorageProvider: InventoryStorageProvider {
    public nonisolated let identifier: String
    public nonisolated let transformer: AnyInventoryDataTransformer
    private let url: URL
    private let fileManager: FileManager

    public init(
        url: URL,
        format: InventoryDataFormat = .yaml,
        identifier: String = "text-file-provider",
        fileManager: FileManager = .default
    ) {
        self.url = url
        self.identifier = identifier
        self.transformer = InventoryKit.transformer(for: format)
        self.fileManager = fileManager
    }

    public func loadInventory(validatingAgainst version: InventorySchemaVersion) async throws -> InventoryDocument {
        if !fileManager.fileExists(atPath: url.path) {
            return InventoryDocument(schemaVersion: version, assets: [])
        }
        let data = try Data(contentsOf: url)
        return try transformer.decode(data, validatingAgainst: version)
    }

    public func saveInventory(_ document: InventoryDocument) async throws {
        let data = try transformer.encode(document)
        try data.write(to: url, options: .atomic)
    }

    public func replaceInventory(with document: InventoryDocument) async throws {
        try await saveInventory(document)
    }
}
