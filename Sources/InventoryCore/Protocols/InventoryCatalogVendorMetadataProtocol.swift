//
//  InventoryCatalogVendorMetadataProtocol.swift
//  InventoryKit
//
//  Protocol for catalog vendor metadata (ISP - Interface Segregation)
//

import Foundation

/// Protocol for catalog vendor metadata.
///
/// Provides metadata about approved catalog data sources.
/// Part of the Interface Segregation Principle (ISP) - focused protocol.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryCatalogVendorMetadataProtocol: Sendable {
    /// Vendor description.
    var description: String? { get }
    
    /// Vendor type (archive, museum, database, etc.).
    var vendorType: CatalogVendorType { get }
    
    /// Vendor website URL.
    var websiteURL: URL? { get }
    
    /// Vendor API endpoint (if applicable).
    var apiEndpoint: URL? { get }
    
    /// Vendor contact information.
    var contactInfo: String? { get }
}

