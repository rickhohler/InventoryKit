import Foundation
import InventoryTypes

/// Protocol defining transactional inventory operations.
public protocol TransactionService: Sendable {
    /// Ingests a new Asset, resolving dependencies like Manufacturer.
    func ingestAsset(_ input: AssetImportData) async throws -> UUID
    
    /// Ingests a new Reference Product.
    func ingestProduct(_ input: ProductImportData) async throws -> UUID
}
