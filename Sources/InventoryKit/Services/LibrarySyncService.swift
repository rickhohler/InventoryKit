//
//  LibrarySyncService.swift
//  InventoryKit
//
//  Service for library synchronization and delta updates
//

import Foundation
import InventoryCore

/// Service for applying delta updates to library data.
///
/// Deltas represent changes since a bundle snapshot date.
/// The storage provider (e.g., CloudKit) holds deltas between bundle date and current time.
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public actor LibrarySyncService {
    
    private let storageProvider: any InventoryLibraryStorageProvider
    
    public init(storageProvider: any InventoryLibraryStorageProvider) {
        self.storageProvider = storageProvider
    }
    
    /// Apply delta updates to a library bundle.
    ///
    /// - Parameters:
    ///   - bundle: The base library bundle
    ///   - delta: The delta update to apply
    /// - Returns: Updated array of products
    /// - Throws: InventoryError if applying delta fails
    public func applyDelta(to bundle: any LibraryBundleProtocol, delta: any LibraryDeltaProtocol) async throws -> [any InventoryProductProtocol] {
        // Start with products from bundle
        var products: [UUID: any InventoryProductProtocol] = Dictionary(uniqueKeysWithValues: bundle.products.map { ($0.id, $0) })
        
        // Apply created products
        for product in delta.createdProducts {
            products[product.id] = product
        }
        
        // Apply updated products
        for product in delta.updatedProducts {
            products[product.id] = product
        }
        
        // Remove deleted products
        for productId in delta.deletedProductIds {
            products.removeValue(forKey: productId)
        }
        
        return Array(products.values)
    }
    
    /// Fetch delta updates from storage provider.
    ///
    /// - Parameters:
    ///   - bundleId: The bundle ID to fetch deltas for
    ///   - bundleVersion: The bundle version
    ///   - fromDate: Start date for delta (bundle snapshot date)
    /// - Returns: LibraryDelta with all changes since bundle
    /// - Throws: InventoryError if fetching fails
    public func fetchDelta(
        bundleId: String,
        bundleVersion: Int64,
        fromDate: Date
    ) async throws -> any LibraryDeltaProtocol {
        return try await storageProvider.fetchDelta(
            bundleId: bundleId,
            bundleVersion: bundleVersion,
            fromDate: fromDate,
            toDate: nil
        )
    }
}
