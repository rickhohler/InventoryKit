import Foundation

/// Protocol for storage providers that persist and load inventory documents.
///
/// `InventoryStorageProvider` abstracts storage operations, allowing InventoryKit to work
/// with any storage backend (files, databases, cloud services, etc.). Implement this protocol
/// to integrate InventoryKit with your storage system.
///
/// ## Required Implementation
///
/// - `identifier`: Unique identifier for logging and debugging
/// - `transformer`: Data transformer for serialization format
/// - `loadInventory(validatingAgainst:)`: Load document from storage
/// - `saveInventory(_:)`: Persist document to storage
///
/// - SeeAlso: ``InventoryDataTransformer`` for serialization
/// - SeeAlso: ``InventoryService`` for service integration
/// - SeeAlso: FileSystemKit for file and binary data management
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryStorageProvider: Sendable {
    /// Human-friendly identifier for diagnostics/logging.
    var identifier: String { get }

    /// Transformer that provider expects data to be encoded/decoded with.
    var transformer: AnyInventoryDataTransformer { get }
    
    /// Vendor information for this storage provider.
    /// nil if vendor information is not available or not applicable.
    /// Allows tracking which vendor/company provides the storage backend.
    var vendor: (any InventoryVendor)? { get }

    /// Loads an inventory document from storage.
    ///
    /// - Parameter version: Schema version to validate against
    /// - Returns: The loaded inventory document
    /// - Throws: `InventoryError` if loading fails or schema validation fails
    func loadInventory(validatingAgainst version: InventorySchemaVersion) async throws -> any InventoryDocument

    /// Persists an inventory document to storage.
    ///
    /// - Parameter document: The inventory document to persist
    /// - Throws: `InventoryError` if persistence fails
    func saveInventory(_ document: any InventoryDocument) async throws

    /// Optional hook when replacing entire document via catalog update.
    ///
    /// Default implementation calls `saveInventory(_:)`. Override to optimize
    /// bulk replacement operations.
    ///
    /// - Parameter document: The inventory document to replace with
    /// - Throws: `InventoryError` if replacement fails
    func replaceInventory(with document: any InventoryDocument) async throws
    
    // MARK: - Vendor Operations
    
    /// Create a new vendor in storage.
    ///
    /// Creates a new vendor record. Throws an error if a vendor with the same ID already exists.
    ///
    /// - Parameter vendor: The vendor to create
    /// - Throws: `InventoryError` if creation fails or vendor already exists
    func createVendor(_ vendor: any InventoryVendor) async throws
    
    /// Save a vendor to storage (create or update).
    ///
    /// Upsert operation: creates a new vendor if it doesn't exist, or updates an existing one.
    /// Use `createVendor` if you want to ensure the vendor doesn't already exist.
    ///
    /// - Parameter vendor: The vendor to save
    /// - Throws: `InventoryError` if save fails
    func saveVendor(_ vendor: any InventoryVendor) async throws
    
    /// Load a vendor from storage by ID.
    ///
    /// - Parameter id: Vendor identifier
    /// - Returns: The vendor if found, nil otherwise
    /// - Throws: `InventoryError` if loading fails
    func loadVendor(id: UUID) async throws -> (any InventoryVendor)?
    
    /// Fetch all vendors from storage.
    ///
    /// - Returns: Array of all vendors
    /// - Throws: `InventoryError` if fetch fails
    func fetchVendors() async throws -> [any InventoryVendor]
    
    /// Delete a vendor from storage.
    ///
    /// - Parameter id: Vendor identifier
    /// - Throws: `InventoryError` if deletion fails
    func deleteVendor(id: UUID) async throws
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension InventoryStorageProvider {
    /// Default implementation: no vendor information
    public var vendor: (any InventoryVendor)? {
        return nil
    }
    
    /// Default implementation that calls `saveInventory(_:)`.
    public func replaceInventory(with document: any InventoryDocument) async throws {
        try await saveInventory(document)
    }
    
    // MARK: - Vendor Operations Default Implementations
    
    /// Default implementation: throws error indicating vendor operations are not supported
    public func createVendor(_ vendor: any InventoryVendor) async throws {
        throw InventoryError.vendorOperationNotSupported("Vendor operations are not supported by this storage provider")
    }
    
    /// Default implementation: throws error indicating vendor operations are not supported
    public func saveVendor(_ vendor: any InventoryVendor) async throws {
        throw InventoryError.vendorOperationNotSupported("Vendor operations are not supported by this storage provider")
    }
    
    /// Default implementation: returns nil (vendor not found)
    public func loadVendor(id: UUID) async throws -> (any InventoryVendor)? {
        return nil
    }
    
    /// Default implementation: returns empty array
    public func fetchVendors() async throws -> [any InventoryVendor] {
        return []
    }
    
    /// Default implementation: throws error indicating vendor operations are not supported
    public func deleteVendor(id: UUID) async throws {
        throw InventoryError.vendorOperationNotSupported("Vendor operations are not supported by this storage provider")
    }
}
