//
//  InventoryCatalogVendorProtocol.swift
//  InventoryKit
//
//  Main catalog vendor protocol (composition of focused protocols)
//

import Foundation

/// Main protocol for catalog vendors (approved catalog data sources).
///
/// Composes all focused catalog vendor protocols following the Interface Segregation Principle (ISP).
/// Catalog vendors are approved sources of catalog data (Archive.org, MobyGames, etc.).
///
/// **Note**: This is distinct from `InventoryVendorProtocol` which is for manufacturers of physical assets.
///
/// ## Protocol Composition
///
/// This protocol composes:
/// - `InventoryCatalogVendorIdentificationProtocol` - Core identification
/// - `InventoryCatalogVendorMetadataProtocol` - Metadata
/// - `InventoryCatalogVendorApprovalProtocol` - Approval info
///
/// ## Usage
///
/// ```swift
/// struct MyCatalogVendor: InventoryCatalogVendorProtocol {
///     // Implement all composed protocol requirements
///     var id: UUID { ... }
///     var name: String { ... }
///     // ... etc
/// }
/// ```
///
/// - SeeAlso: ``InventoryCatalogVendorIdentificationProtocol``
/// - SeeAlso: ``InventoryCatalogVendorMetadataProtocol``
/// - SeeAlso: ``InventoryCatalogVendorApprovalProtocol``
/// - SeeAlso: ``InventoryVendorProtocol`` (for manufacturers of physical assets)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryCatalogVendorProtocol: InventoryCatalogVendorIdentificationProtocol
    & InventoryCatalogVendorMetadataProtocol
    & InventoryCatalogVendorApprovalProtocol {
    
    /// Vendor-specific metadata.
    var metadata: [String: String] { get }
}

