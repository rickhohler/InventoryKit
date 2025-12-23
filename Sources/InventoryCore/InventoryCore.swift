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
    /// Core module version
    public static let version = "1.0.0"
}

