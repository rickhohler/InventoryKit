//
//  InventoryLibraryStorageProvider.swift
//  InventoryKit
//
//  Protocol for storage providers that persist and load Products from the library.
//

import Foundation

/// Protocol for storage providers that persist and load Products from the library.
///
/// `InventoryLibraryStorageProvider` abstracts storage operations for **public, shared library data**.
/// Unlike InventoryKit (which manages user-specific assets), the Library stores public
/// authority records that are shared across all users with no user-specific information.
///
/// ## Key Characteristics
///
/// - **Public Data**: Products are shared across all users (no user-specific data)
/// - **Authority Records**: Standardized library entries with cross-references
/// - **No User Context**: Products contain no user ownership or personal information
///
/// ## Required Implementation
///
/// - `identifier`: Unique identifier for this storage provider
/// - `createProduct(_:)`: Create a new Product in storage
/// - `getProduct(id:)`: Retrieve a Product by ID
/// - `searchProducts(query:)`: Search Products by query
/// - `updateProduct(_:)`: Update an existing Product
/// - `deleteProduct(id:)`: Delete a Product by ID
///
/// ## Usage
///
/// ```swift
/// struct CloudKitProvider: InventoryLibraryStorageProvider {
///     let identifier = "cloudkit"
///
///     func createProduct(_ product: any InventoryProduct) async throws {
///         // Save to CloudKit public database (shared, not user-specific)
///     }
///
///     func getProduct(id: UUID) async throws -> (any InventoryProduct)? {
///         // Load from CloudKit public database
///     }
/// }
/// ```
///
/// ## Comparison with InventoryKit
///
/// - **InventoryKit**: User-specific assets in private databases (user workspace)
/// - **Library**: Public authority records in shared storage (no user context)
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public protocol InventoryLibraryStorageProvider: Sendable {
    
    /// Unique identifier for this storage provider (for logging and debugging)
    var identifier: String { get }
    
    // MARK: - Product Operations
    
    /// Create a new Product in the library.
    ///
    /// - Parameter product: The product to create (conforms to InventoryProduct)
    /// - Throws: `InventoryError` if creation fails or Product already exists
    func createProduct(_ product: any InventoryProduct) async throws
    
    /// Retrieve a Product by its ID.
    ///
    /// - Parameter id: The UUID of the Product to retrieve
    /// - Returns: The product if found, `nil` otherwise (conforms to InventoryProduct)
    /// - Throws: `InventoryError` if retrieval fails
    func getProduct(id: UUID) async throws -> (any InventoryProduct)?
    
    /// Search Products in the library.
    ///
    /// - Parameter query: Search query string
    /// - Returns: Array of matching products (conform to InventoryProduct)
    /// - Throws: `InventoryError` if search fails
    func searchProducts(query: String) async throws -> [any InventoryProduct]
    
    /// Update an existing Product in the library.
    ///
    /// - Parameter product: The Product to update
    /// - Throws: `InventoryError` if update fails or Product doesn't exist
    func updateProduct(_ product: any InventoryProduct) async throws
    
    /// Delete a Product from the library.
    ///
    /// - Parameter id: The UUID of the Product to delete
    /// - Throws: `InventoryError` if deletion fails or Product doesn't exist
    func deleteProduct(id: UUID) async throws
    
    // MARK: - Batch Operations (Optional)
    
    /// Create multiple Products in a single operation.
    ///
    /// Default implementation calls `createProduct(_:)` for each Product.
    /// Override to optimize bulk creation operations.
    ///
    /// - Parameter products: Array of Products to create
    /// - Throws: `InventoryError` if any creation fails
    func createProducts(_ products: [any InventoryProduct]) async throws
    
    /// Update multiple Products in a single operation.
    ///
    /// Default implementation calls `updateProduct(_:)` for each Product.
    /// Override to optimize bulk update operations.
    ///
    /// - Parameter products: Array of Products to update
    /// - Throws: `InventoryError` if any update fails
    func updateProducts(_ products: [any InventoryProduct]) async throws
    
    // MARK: - Delta Operations (Optional)
    
    /// Fetch delta updates since a specific date.
    ///
    /// Used to get changes since a library bundle snapshot date.
    /// Storage providers should implement this to support delta updates.
    ///
    /// - Parameters:
    ///   - bundleId: The bundle ID this delta applies to
    ///   - bundleVersion: The bundle version
    ///   - fromDate: Start date for delta (bundle snapshot date)
    ///   - toDate: End date for delta (defaults to now)
    /// - Returns: LibraryDelta with all changes in the date range
    /// - Throws: `InventoryError` if fetching fails
    func fetchDelta(
        bundleId: String,
        bundleVersion: Int64,
        fromDate: Date,
        toDate: Date?
    ) async throws -> any LibraryDeltaProtocol
}

// MARK: - Default Implementations

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension InventoryLibraryStorageProvider {
    
    /// Default implementation: creates Products sequentially.
    public func createProducts(_ products: [any InventoryProduct]) async throws {
        for product in products {
            try await createProduct(product)
        }
    }
    
    /// Default implementation: updates Products sequentially.
    public func updateProducts(_ products: [any InventoryProduct]) async throws {
        for product in products {
            try await updateProduct(product)
        }
    }
    
    /// Default implementation: throws error (must be implemented by storage provider).
    public func fetchDelta(
        bundleId: String,
        bundleVersion: Int64,
        fromDate: Date,
        toDate: Date?
    ) async throws -> any LibraryDeltaProtocol {
        throw InventoryError.storageError("Delta fetching not implemented by storage provider")
    }
}
