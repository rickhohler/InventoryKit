//
//  InventoryDataSourceProtocol.swift
//  InventoryKit
//
//  Created by InventoryKit Unified Catalog Design.
//

import Foundation

// MARK: - Inventory Data Source Protocol

/// Protocol defining the source of catalog data (e.g., Archive.org, MobyGames).
///
/// This distinguishes the "Provider" of the data from the "Manufacturer" of the product.
/// - **Manufacturer**: Apple, Nintendo (Who made the thing)
/// - **Data Source**: Archive.org, TOSEC (Who provided the record)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryDataSourceProtocol: Identifiable, Sendable,
                                           InventoryDataSourceInfoProtocol,
                                           InventoryDataSourceTypeProtocol {
    /// Unique identifier for the data source.
    var id: UUID { get }
}

// MARK: - Component Protocols

/// Defines basic information about a data source.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryDataSourceInfoProtocol {
    /// Name of the data source (e.g., "Internet Archive").
    var name: String { get }
    
    /// URL to the data source root or homepage.
    var url: URL? { get }
    
    /// The protocol used to fetch data (e.g., "https", "ftp").
    var transport: String? { get }
    
    /// The name of the adapter handling this source (e.g., "ArchiveOrgAdapter").
    var adapter: String? { get }
}

/// Defines the type of data source.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryDataSourceTypeProtocol {
    /// The categorization of the data source.
    var type: InventoryDataSourceType { get }
}

// MARK: - Enums

/// Categorization of data sources.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public enum InventoryDataSourceType: String, Codable, Sendable {
    /// Digital archive (e.g., Archive.org).
    case archive
    /// Physical museum or institution.
    case museum
    /// Community database (e.g., MobyGames).
    case database
    /// Personal collection or manual entry.
    case personal
    /// Other or unspecified.
    case other
}
