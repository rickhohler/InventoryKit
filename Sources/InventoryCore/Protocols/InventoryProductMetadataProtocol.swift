//
//  InventoryProductMetadataProtocol.swift
//  InventoryKit
//
//  Protocol for product metadata (ISP - Interface Segregation)
//

import Foundation

/// Protocol for product metadata.
///
/// Provides basic descriptive information about a product.
/// Part of the Interface Segregation Principle (ISP) - focused protocol.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryProductMetadataProtocol: Sendable {
    /// Product title (e.g., "Championship Lode Runner").
    var title: String { get }
    
    /// Product description.
    var description: String? { get }
    
    /// Classification from Nomenclature 4.0 or other controlled vocabulary.
    var classification: String? { get }
    
    /// Product type (software or hardware).
    var productType: ProductType { get }
}

