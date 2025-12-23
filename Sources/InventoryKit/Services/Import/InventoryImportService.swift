import Foundation
import InventoryTypes
import InventoryCore

/// Protocol defining the API for importing data into the Inventory System.
public protocol InventoryImportServiceProtocol: Sendable {
    /// Imports a raw asset description into the inventory.
    /// - Parameter data: The import data object containing asset details.
    /// - Returns: The UUID of the created (or updated) asset.
    func importAsset(_ data: AssetImportData) async throws -> UUID
    
    /// Imports a product reference into the library.
    /// - Parameter data: The import data object containing product details.
    /// - Returns: The UUID of the created (or updated) product.
    func importProduct(_ data: ProductImportData) async throws -> UUID
}

/// Default implementation of the Import Service.
/// Orchestrates validation, resolution, and persistence via low-level services.
public actor InventoryImportService: InventoryImportServiceProtocol {
    
    private let transactionService: any TransactionService
    
    public init(transactionService: any TransactionService) {
        self.transactionService = transactionService
    }
    
    public func importAsset(_ data: AssetImportData) async throws -> UUID {
        // Here we could add extra validation or enrichment layers
        // before passing to the transaction service.
        return try await transactionService.ingestAsset(data)
    }
    
    public func importProduct(_ data: ProductImportData) async throws -> UUID {
        return try await transactionService.ingestProduct(data)
    }
}
