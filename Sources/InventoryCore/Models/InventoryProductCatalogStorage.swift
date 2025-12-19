//
//  InventoryProductCatalogStorage.swift
//  InventoryKit
//
//  Product catalog storage information (SRP - Single Responsibility)
//

import Foundation

/// Product catalog storage information.
///
/// Storage site/host information for product catalogs.
/// Part of the Single Responsibility Principle (SRP) - focused type.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct InventoryProductCatalogStorage: Sendable, Codable, Hashable {
    /// One or more data storage sites/hosts (DataProviders) where collection data is stored
    /// Collections can have multiple DataProviders (mirrors, local copies, etc.)
    public let dataProviderIDs: [UUID]
    
    public init(dataProviderIDs: [UUID] = []) {
        self.dataProviderIDs = dataProviderIDs
    }
}

