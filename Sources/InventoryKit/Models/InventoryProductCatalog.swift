//
//  InventoryProductCatalog.swift
//  InventoryKit
//
//  Product catalog model (composition of focused types)
//

import Foundation
import InventoryCore

/// Product catalog (collection of products by a vendor).
///
/// Composes focused types following the Single Responsibility Principle (SRP).
/// Product catalogs represent organized groupings of digital assets from vendors.
///
/// ## Protocol Composition
///
/// This model composes:
/// - `InventoryProductCatalogIdentification` - Core identification
/// - `InventoryProductCatalogSource` - Source/provider information
/// - `InventoryProductCatalogContent` - Content (digital assets)
/// - `InventoryProductCatalogStorage` - Storage sites/hosts
///
/// ## Many-to-Many Relationships
///
/// Digital assets can belong to multiple collections (many-to-many relationship).
///
/// ## Usage
///
/// ```swift
/// let catalog = InventoryProductCatalog(
///     title: "Apple II Disk Images",
///     vendorID: archiveOrgVendorID,
///     digitalAssetIDs: [asset1ID, asset2ID],
///     dataProviderIDs: [provider1ID, provider2ID]
/// )
/// ```
///
/// - SeeAlso: ``InventoryProductCatalogProtocol``
/// - SeeAlso: ``InventoryProductCatalogIdentification``
/// - SeeAlso: ``InventoryProductCatalogSource``
/// - SeeAlso: ``InventoryProductCatalogContent``
/// - SeeAlso: ``InventoryProductCatalogStorage``
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct InventoryProductCatalog: InventoryProductCatalogProtocol, Identifiable, Hashable, Sendable, Codable {
    // MARK: - Identification
    
    /// Unique identifier for the catalog
    public let id: UUID
    
    /// Catalog title
    public let title: String
    
    /// Catalog description
    public let description: String?
    
    // MARK: - Source
    
    /// Vendor ID that provides this catalog (source/provider)
    public let vendorID: UUID
    
    /// Vendor-specific collection ID
    public let vendorCollectionId: String?
    
    /// Link to collection in vendor's system
    public let vendorCollectionURL: URL?
    
    /// Curator information (who curated this collection)
    public let curator: String?
    
    // MARK: - Content
    
    /// Digital assets (InventoryAssets) in this collection
    /// **Many-to-Many**: Digital assets can belong to multiple collections
    public let digitalAssetIDs: [UUID]
    
    /// Collection type (platformCollection, gameSeries, etc.)
    public let collectionType: String
    
    // MARK: - Storage
    
    /// One or more data storage sites/hosts (DataProviders) where collection data is stored
    /// Collections can have multiple DataProviders (mirrors, local copies, etc.)
    public let dataProviderIDs: [UUID]
    
    // MARK: - Metadata
    
    /// Extended metadata
    public let metadata: [String: String]
    
    // MARK: - Timestamps
    
    /// Creation date
    public let createdAt: Date
    
    /// Last modification date
    public let modifiedAt: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        vendorID: UUID,
        vendorCollectionId: String? = nil,
        vendorCollectionURL: URL? = nil,
        curator: String? = nil,
        digitalAssetIDs: [UUID] = [],
        collectionType: String,
        dataProviderIDs: [UUID] = [],
        metadata: [String: String] = [:],
        createdAt: Date = Date(),
        modifiedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.vendorID = vendorID
        self.vendorCollectionId = vendorCollectionId
        self.vendorCollectionURL = vendorCollectionURL
        self.curator = curator
        self.digitalAssetIDs = digitalAssetIDs
        self.collectionType = collectionType
        self.dataProviderIDs = dataProviderIDs
        self.metadata = metadata
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }
}

