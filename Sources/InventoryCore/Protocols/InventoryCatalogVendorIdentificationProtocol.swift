//
//  InventoryCatalogVendorIdentificationProtocol.swift
//  InventoryKit
//
//  Protocol for catalog vendor identification (ISP - Interface Segregation)
//

import Foundation

/// Protocol for catalog vendor identification.
///
/// Provides core identification for approved catalog data sources.
/// Part of the Interface Segregation Principle (ISP) - focused protocol.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryCatalogVendorIdentificationProtocol: Identifiable, Sendable where ID == UUID {
    /// Unique identifier for the vendor.
    var id: UUID { get }
    
    /// Vendor name.
    var name: String { get }
}

