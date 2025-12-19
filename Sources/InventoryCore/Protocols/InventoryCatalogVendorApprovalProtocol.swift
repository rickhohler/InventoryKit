//
//  InventoryCatalogVendorApprovalProtocol.swift
//  InventoryKit
//
//  Protocol for catalog vendor approval information (ISP - Interface Segregation)
//

import Foundation

/// Protocol for catalog vendor approval information.
///
/// Provides approval status and metadata for catalog vendors.
/// Part of the Interface Segregation Principle (ISP) - focused protocol.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol InventoryCatalogVendorApprovalProtocol: Sendable {
    /// Vendor approval status.
    var isApproved: Bool { get }
    
    /// Date vendor was approved.
    var approvedDate: Date? { get }
    
    /// Approval authority (who approved this vendor).
    var approvedBy: String? { get }
}

