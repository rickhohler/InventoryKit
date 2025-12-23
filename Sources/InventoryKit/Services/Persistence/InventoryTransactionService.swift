import Foundation
import InventoryTypes
import InventoryCore

/// A high-level service that orchestrates the ingestion and manipulation of Inventory items
/// using a transactional storage provider and a configurator.
public actor InventoryTransactionService: TransactionService {
    
    // MARK: - Dependencies
    private let storage: any StorageProvider
    private let configurator: any Configurator
    
    // MARK: - Initialization
    public init(storage: any StorageProvider, configurator: any Configurator) {
        self.storage = storage
        self.configurator = configurator
    }
    
    // MARK: - Asset Ingestion
    
    /// Ingests a new Asset, automatically handling Manufacturer creation/lookup.
    public func ingestAsset(_ input: AssetImportData) async throws -> UUID {
        return try await storage.performTransaction { tx in
            
            // 1. Resolve Manufacturer
            var manufacturer: any Manufacturer
            let mfgQuery = StorageQuery.manufacturer(name: input.manufacturerName)
            
            if let existing = try await tx.fetchReferenceManufacturers(matching: mfgQuery).first {
                manufacturer = existing
            } else {
                // Create New
                var newMfg = try await tx.createReferenceManufacturer()
                // Configure basic details
                // Note: We need a Configurator method for Manufacturer that doesn't require all fields?
                // Or we pass defaults.
                // Assuming Configurator.configure<T: Manufacturer>(...) available.
                self.configurator.configure(&newMfg,
                                            id: nil, // Generate new or use storage default
                                            name: input.manufacturerName,
                                            slug: input.manufacturerName.lowercased().replacingOccurrences(of: " ", with: "-"),
                                            description: nil,
                                            metadata: [:],
                                            aliases: [])
                manufacturer = newMfg
            }
            
            // 2. Create Asset
            var asset = try await tx.createAsset()
            
            // 3. Configure Asset
            self.configurator.configure(&asset,
                                        id: nil,
                                        name: input.name,
                                        type: input.type,
                                        location: input.location,
                                        acquisitionSource: input.acquisitionSource,
                                        acquisitionDate: input.acquisitionDate,
                                        condition: nil,
                                        tags: input.tags,
                                        metadata: input.metadata)
            
            // 4. Link Relationships
            asset.manufacturer = manufacturer
            
            // 5. Save/Commit handled by transaction scope
            return asset.id
        }
    }
    
    // MARK: - Product Ingestion (Reference)
    
    public func ingestProduct(_ input: ProductImportData) async throws -> UUID {
        return try await storage.performTransaction { tx in
            
            // 1. Resolve Manufacturer
            var manufacturer: any Manufacturer
            let mfgQuery = StorageQuery.manufacturer(name: input.manufacturerName)
            
            if let existing = try await tx.fetchReferenceManufacturers(matching: mfgQuery).first {
                manufacturer = existing
            } else {
                var newMfg = try await tx.createReferenceManufacturer()
                self.configurator.configure(&newMfg,
                                            id: nil,
                                            name: input.manufacturerName,
                                            slug: input.manufacturerName.lowercased().replacingOccurrences(of: " ", with: "-"),
                                            description: nil,
                                            metadata: [:],
                                            aliases: [])
                manufacturer = newMfg
            }
            
            // 2. Create Product
            var product = try await tx.createReferenceProduct()
            
            // 3. Configure Product
            self.configurator.configure(&product,
                                        id: nil,
                                        title: input.title,
                                        description: nil,
                                        sku: nil,
                                        productType: nil,
                                        classification: nil,
                                        genre: nil,
                                        releaseDate: input.releaseDate,
                                        platform: input.platform)
            
            // 4. Link
            product.manufacturer = manufacturer
            
            return product.id
        }
    }
}
