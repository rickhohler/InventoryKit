import Foundation

/// Abstraction over storage backends (files, cloud, databases) that manage inventory documents at scale.
public protocol InventoryStorageProvider: Sendable {
    /// Human-friendly identifier for diagnostics/logging.
    var identifier: String { get }

    /// Transformer that provider expects data to be encoded/decoded with.
    var transformer: AnyInventoryDataTransformer { get }

    /// Loads an inventory document.
    func loadInventory(validatingAgainst version: InventorySchemaVersion) async throws -> InventoryDocument

    /// Persists an inventory document.
    func saveInventory(_ document: InventoryDocument) async throws

    /// Optional hook when replacing entire document via catalog update.
    func replaceInventory(with document: InventoryDocument) async throws
}
