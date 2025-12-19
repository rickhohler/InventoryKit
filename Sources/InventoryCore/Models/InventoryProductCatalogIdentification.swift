//
//  InventoryProductCatalogIdentification.swift
//  InventoryKit
//
//  Product catalog identification (SRP - Single Responsibility)
//

import Foundation

/// Product catalog identification information.
///
/// Core identification for product catalogs (collections of products by vendors).
/// Part of the Single Responsibility Principle (SRP) - focused type.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct InventoryProductCatalogIdentification: Sendable, Codable, Hashable {
    /// Unique identifier for the catalog
    public let id: UUID
    
    /// Catalog title
    public let title: String
    
    /// Catalog description
    public let description: String?
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
    }
}

