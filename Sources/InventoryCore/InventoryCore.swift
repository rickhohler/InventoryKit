//
//  InventoryCore.swift
//  InventoryCore
//
//  Core protocols and base types for InventoryKit
//

import Foundation
import InventoryTypes

/// InventoryCore provides the foundational protocols and base types for InventoryKit.
///
/// This module contains:
/// - Protocol definitions for assets, documents, products, vendors, and storage providers
/// - Base model types used by protocols (identifiers, lifecycle, health, etc.)
/// - Enumerations and constants (ProductType, CatalogVendorType, relationship types, etc.)
///
/// Clients implement concrete types conforming to these protocols.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public enum InventoryCoreInfo {
    /// Core module version. It was never updated with releases (it said 1.0.0 in 2.x); use the
    /// package version from your dependency resolution instead.
    @available(*, deprecated, message: "Not maintained; read the InventoryKit package version from Package.resolved. Removed in 3.0.")
    public static let version = "1.0.0"
}

