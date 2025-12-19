//
//  InventoryProductCatalogContent.swift
//  InventoryKit
//
//  Product catalog content information (SRP - Single Responsibility)
//

import Foundation

/// Product catalog content information.
///
/// Content information for product catalogs (digital assets in collection).
/// Part of the Single Responsibility Principle (SRP) - focused type.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct InventoryProductCatalogContent: Sendable, Codable, Hashable {
    /// Digital assets (InventoryAssets) in this collection
    /// **Many-to-Many**: Digital assets can belong to multiple collections
    public let digitalAssetIDs: [UUID]
    
    /// Collection type (platformCollection, gameSeries, etc.)
    public let collectionType: String
    
    public init(
        digitalAssetIDs: [UUID] = [],
        collectionType: String
    ) {
        self.digitalAssetIDs = digitalAssetIDs
        self.collectionType = collectionType
    }
}

