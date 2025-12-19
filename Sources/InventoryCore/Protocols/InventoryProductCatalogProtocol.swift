//
//  InventoryProductCatalogProtocol.swift
//  InventoryKit
//
//  Protocol for product catalogs (collections)
//

import Foundation

/// Protocol defining the contract for product catalogs (collections).
///
/// This protocol allows clients to implement their own catalog models (e.g., CloudKit/CoreData managed objects)
/// while maintaining compatibility with InventoryKit's operations.
///
/// ## CloudKit/CoreData Integration
///
/// Clients can make their CloudKit or CoreData managed objects conform to this protocol:
///
/// ```swift
/// extension CKRecord: InventoryProductCatalogProtocol {
///     public var id: UUID { /* extract from record */ }
///     public var title: String { /* extract from record */ }
///     // ... implement all protocol requirements
/// }
/// ```
///
/// - SeeAlso: ``InventoryProductCatalog`` for concrete implementation
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryProductCatalogProtocol: Identifiable, Sendable where ID == UUID {
    /// Unique identifier for the catalog
    var id: UUID { get }
    
    /// Catalog title
    var title: String { get }
    
    /// Catalog description
    var description: String? { get }
    
    /// Vendor ID that provides this catalog (source/provider)
    var vendorID: UUID { get }
    
    /// Vendor-specific collection ID
    var vendorCollectionId: String? { get }
    
    /// Link to collection in vendor's system
    var vendorCollectionURL: URL? { get }
    
    /// Curator information (who curated this collection)
    var curator: String? { get }
    
    /// Digital assets (InventoryAssets) in this collection
    /// **Many-to-Many**: Digital assets can belong to multiple collections
    var digitalAssetIDs: [UUID] { get }
    
    /// Collection type (platformCollection, gameSeries, etc.)
    var collectionType: String { get }
    
    /// One or more data storage sites/hosts (DataProviders) where collection data is stored
    /// Collections can have multiple DataProviders (mirrors, local copies, etc.)
    var dataProviderIDs: [UUID] { get }
    
    /// Extended metadata
    var metadata: [String: String] { get }
    
    /// Creation date
    var createdAt: Date { get }
    
    /// Last modification date
    var modifiedAt: Date { get }
}

