//
//  InventoryProductProtocol.swift
//  InventoryKit
//
//  Main product protocol (composition of focused protocols)
//

import Foundation

/// Main protocol for products (Authority Records).
///
/// Composes all focused product protocols following the Interface Segregation Principle (ISP).
/// Products represent catalog entries for software titles or hardware products.
///
/// ## Protocol Composition
///
/// This protocol composes:
/// - `InventoryProductIdentificationProtocol` - Core identification
/// - `InventoryProductMetadataProtocol` - Basic metadata
/// - `InventoryProductCreatorProtocol` - Creator/publisher information
/// - `InventoryProductSpecificationProtocol` - Specifications (hardware/software)
///
/// ## Usage
///
/// ```swift
/// struct MyProduct: InventoryProductProtocol {
///     // Implement all composed protocol requirements
///     var id: UUID { ... }
///     var title: String { ... }
///     // ... etc
/// }
/// ```
///
/// - SeeAlso: ``InventoryProductIdentificationProtocol``
/// - SeeAlso: ``InventoryProductMetadataProtocol``
/// - SeeAlso: ``InventoryProductCreatorProtocol``
/// - SeeAlso: ``InventoryProductSpecificationProtocol``
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryProductProtocol: InventoryProductIdentificationProtocol
    & InventoryProductMetadataProtocol
    & InventoryProductCreatorProtocol
    & InventoryProductSpecificationProtocol {
    
    /// Release date.
    var releaseDate: Date? { get }
    
    /// Production date.
    var productionDate: Date? { get }
    
    /// Product identifiers (UPC, etc.) using InventoryIdentifier.
    var identifiers: [InventoryIdentifier] { get }
}

