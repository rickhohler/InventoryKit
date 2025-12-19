//
//  InventoryProductCatalogSource.swift
//  InventoryKit
//
//  Product catalog source information (SRP - Single Responsibility)
//

import Foundation

/// Product catalog source information.
///
/// Source/provider information for product catalogs.
/// Part of the Single Responsibility Principle (SRP) - focused type.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct InventoryProductCatalogSource: Sendable, Codable, Hashable {
    /// Vendor ID that provides this catalog (source/provider)
    public let vendorID: UUID
    
    /// Vendor-specific collection ID
    public let vendorCollectionId: String?
    
    /// Link to collection in vendor's system
    public let vendorCollectionURL: URL?
    
    /// Curator information (who curated this collection)
    public let curator: String?
    
    public init(
        vendorID: UUID,
        vendorCollectionId: String? = nil,
        vendorCollectionURL: URL? = nil,
        curator: String? = nil
    ) {
        self.vendorID = vendorID
        self.vendorCollectionId = vendorCollectionId
        self.vendorCollectionURL = vendorCollectionURL
        self.curator = curator
    }
}

